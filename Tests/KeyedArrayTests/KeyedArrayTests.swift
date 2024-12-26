import KeyedArray
import Testing

struct KeyedArrayTests {
	struct DemoVal: Equatable, Identifiable, ExpressibleByStringLiteral, CustomStringConvertible {
		let str: String
		var id: Character { self.str.first! }
		var description: String { self.str }

		init(_ str: String) { self.str = str }
		init(stringLiteral str: String) { self.str = str }
	}

	var ar: KeyedArray<Character, DemoVal>!

	init() {
		self.ar = ["alpha", "beta"]
	}

	@Test
	mutating func append() {
		self.ar.append("charlie")

		#expect(self.ar.array == ["alpha", "beta", "charlie"])
		#expect(self.ar["a"] == "alpha")
		#expect(self.ar["b"] == "beta")
		#expect(self.ar["c"] == "charlie")
	}

	@Test
	mutating func insert() {
		self.ar.insert("charlie", at: 1)

		#expect(self.ar.array == ["alpha", "charlie", "beta"])
		#expect(self.ar["a"] == "alpha")
		#expect(self.ar["b"] == "beta")
		#expect(self.ar["c"] == "charlie")
	}

	@Test
	mutating func removeByIndex() {
		self.ar.remove(at: 1)

		#expect(self.ar.array == ["alpha"])
	}

	@Test
	mutating func removeByKey() {
		#expect(self.ar.remove(by: "Q") == nil)

		#expect(self.ar.remove(by: "b") == "beta")
		#expect(self.ar.array == ["alpha"])
	}

	@Test
	mutating func replaceByAppend() {
		self.ar.append("bravo")

		#expect(self.ar.array == ["alpha", "bravo"])
		#expect(self.ar.dictionary == ["a": "alpha", "b": "bravo"])
	}

	@Test
	mutating func mutateValueInPlaceByKey() {
		self.ar.mutateValueInPlace(for: "a") { existing in
			existing = "alpine"
		}

		#expect(self.ar.array == ["alpine", "beta"])
		#expect(self.ar.dictionary == ["a": "alpine", "b": "beta"])
	}

	@Test
	mutating func mutateValueInPlaceByIndex() {
		self.ar.mutateValueInPlace(for: 0) { existing in
			existing = "alpine"
		}

		#expect(self.ar.array == ["alpine", "beta"])
		#expect(self.ar.dictionary == ["a": "alpine", "b": "beta"])
	}

	@Test
	mutating func arrayIsArray() {
		#expect(Array(self.ar.array) == self.ar.array)
	}

	@Test
	mutating func iterator() {
		var it = self.ar.makeIterator()
		#expect(it.next() == "alpha")
		#expect(it.next() == "beta")
		#expect(it.next() == nil)
	}

	@Test
	mutating func equality() {
		var other = self.ar!

		#expect(self.ar == other)

		other.insert("charlie", at: 1)
		#expect(self.ar != other)
	}
}
