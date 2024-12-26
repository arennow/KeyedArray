public struct KeyedArray<Key: Hashable, Element: Equatable> {
	public private(set) var array = Array<Element>()
	public private(set) var dictionary = Dictionary<Key, Element>()

	private let keyExtractor: (Element) -> Key

	public init(keyExtractor: @escaping (Element) -> Key) {
		self.keyExtractor = keyExtractor
	}

	public init(_ seq: some Sequence<Element>, keyExtractor: @escaping (Element) -> Key) {
		self.init(keyExtractor: keyExtractor)

		for element in seq {
			self.append(element)
		}
	}

	public subscript(index: Int) -> Element { self.array[index] }
	public subscript(key: Key) -> Element? { self.dictionary[key] }

	public mutating func append(_ newElement: Element) {
		self.insert(newElement, at: .end)
	}

	public mutating func insert(_ newElement: Element, at index: Int) {
		self.insert(newElement, at: .index(index))
	}

	private enum InsertionPoint {
		case index(Int)
		case end
	}

	private mutating func insert(_ newElement: Element, at insertionPoint: InsertionPoint) {
		let key = self.keyExtractor(newElement)

		self.remove(by: key)

		switch insertionPoint {
			case .index(let index): self.array.insert(newElement, at: index)
			case .end: self.array.append(newElement)
		}
		self.dictionary[key] = newElement
	}

	public mutating func remove(at index: Int) {
		let element = self.array.remove(at: index)

		let key = self.keyExtractor(element)
		self.dictionary.removeValue(forKey: key)
	}

	@discardableResult
	public mutating func remove(by key: Key) -> Element? {
		guard let removedElement = self.dictionary.removeValue(forKey: key) else { return nil }

		self.array.remove(removedElement)

		return removedElement
	}
}

public extension KeyedArray {
	/// Mutates an existing value without changing its position.
	///
	/// The mutation function will not be called if no value can be found for `key`.
	///
	/// - Complexity: O(n)
	///
	/// - Warning: The new element **must** produce the same key as the old value.
	///
	/// - Parameters:
	///   - key: The key whose value to look up and mutate.
	///   - function: A function that mutates the existing value.
	mutating func mutateValueInPlace(for key: Key, using function: (inout Element) -> Void) {
		guard var value = self[key], let index = self.array.firstIndex(of: value) else { return }
		function(&value)

		precondition(self.keyExtractor(value) == key, "New value's key must match old value's key")

		self.array[index] = value
		self.dictionary[key] = value
	}

	/// Mutates an existing value without changing its position.
	///
	/// - Complexity: O(1)
	///
	/// - Warning: The new element **must** produce the same key as the old value.
	///
	/// - Parameters:
	///   - index: The index whose value to mutate.
	///   - function: A function that mutates the existing value.
	mutating func mutateValueInPlace(for index: Int, using function: (inout Element) -> Void) {
		var value = self[index]
		let oldKey = self.keyExtractor(value)
		function(&value)

		precondition(self.keyExtractor(value) == oldKey, "New value's key must match old value's key")

		self.array[index] = value
		self.dictionary[oldKey] = value
	}
}

public extension KeyedArray where Element: Identifiable, Key == Element.ID {
	init() {
		self.init(keyExtractor: \.id)
	}

	init(_ seq: some Sequence<Element>) {
		self.init(seq, keyExtractor: \.id)
	}
}

extension KeyedArray: ExpressibleByArrayLiteral where Element: Identifiable, Key == Element.ID {
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
}

extension KeyedArray: Collection {
	public var startIndex: Int { self.array.startIndex }
	public var endIndex: Int { self.array.endIndex }

	public func index(after i: Int) -> Int { self.array.index(after: i) }
}

extension KeyedArray: Equatable {
	public static func == (lhs: KeyedArray<Key, Element>, rhs: KeyedArray<Key, Element>) -> Bool {
		lhs.array == rhs.array
	}
}
