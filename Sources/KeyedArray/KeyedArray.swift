public struct KeyedArray<Key: Hashable, Element: Equatable> {
	public private(set) var array = Array<Element>()
	public private(set) var dictionary = Dictionary<Key, Element>()
	
	private let keyExtractor: (Element)->Key
	
	public init(keyExtractor: @escaping (Element)->Key) {
		self.keyExtractor = keyExtractor
	}
	
	public subscript(index: Int) -> Element { self.array[index] }
	public subscript(key: Key) -> Element? { self.dictionary[key] }
	
	public mutating func append(_ newElement: Element) {
		let key = self.keyExtractor(newElement)
		
		self.remove(by: key)
		
		self.array.append(newElement)
		self.dictionary[key] = newElement
	}
	
	public mutating func insert(_ newElement: Element, at index: Int) {
		let key = self.keyExtractor(newElement)
		
		self.remove(by: key)
		
		self.array.insert(newElement, at: index)
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

extension KeyedArray where Element: Identifiable, Key == Element.ID {
	public init() {
		self.init(keyExtractor: \.id)
	}
	
	public init<S: Sequence>(_ seq: S) where S.Element == Element {
		self.init()
		
		for element in seq {
			self.append(element)
		}
	}
}

extension KeyedArray: ExpressibleByArrayLiteral where Element: Identifiable, Key == Element.ID {
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
}

extension KeyedArray: Collection {
	public var startIndex: Int { array.startIndex }
	public var endIndex: Int { array.endIndex }
	
	public func index(after i: Int) -> Int { array.index(after: i) }
}

extension KeyedArray: Equatable {
	public static func ==(lhs: KeyedArray<Key, Element>, rhs: KeyedArray<Key, Element>) -> Bool {
		lhs.array == rhs.array
	}
}
