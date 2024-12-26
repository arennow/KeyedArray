import KeyedArray
import Testing

struct KeyedArrayTests {
	struct DemoVal: Equatable, Identifiable, ExpressibleByStringLiteral, CustomStringConvertible {
		let str: String
		var id: Character { str.first! }
		var description: String { str }
		
		init(_ str: String) { self.str = str }
		init(stringLiteral str: String) { self.str = str }
	}
	
	var ar: KeyedArray<Character, DemoVal>!
	
	init() {
		self.ar = ["alpha", "beta"]
	}
	
	@Test
	mutating func append() {
		ar.append("charlie")
		
		#expect(ar.array == ["alpha", "beta", "charlie"])
		#expect(ar["a"] == "alpha")
		#expect(ar["b"] == "beta")
		#expect(ar["c"] == "charlie")
	}
	
	@Test
	mutating func insert() {
		ar.insert("charlie", at: 1)
		
		#expect(ar.array == ["alpha", "charlie", "beta"])
		#expect(ar["a"] == "alpha")
		#expect(ar["b"] == "beta")
		#expect(ar["c"] == "charlie")
	}
	
	@Test
	mutating func removeByIndex() {
		ar.remove(at: 1)
		
		#expect(ar.array == ["alpha"])
	}
	
	@Test
	mutating func removeByKey() {
		#expect(ar.remove(by: "Q") == nil)
		
		#expect(ar.remove(by: "b") == "beta")
		#expect(ar.array == ["alpha"])
	}
	
	@Test
	mutating func replaceByAppend() {
		ar.append("bravo")
		
		#expect(ar.array == ["alpha", "bravo"])
		#expect(ar.dictionary == ["a": "alpha", "b": "bravo"])
	}
	
	@Test
	mutating func mutateValueInPlaceByKey() {
		ar.mutateValueInPlace(for: "a") { existing in
			existing = "alpine"
		}
		
		#expect(ar.array == ["alpine", "beta"])
		#expect(ar.dictionary == ["a": "alpine", "b": "beta"])
	}
	
	@Test
	mutating func mutateValueInPlaceByIndex() {
		ar.mutateValueInPlace(for: 0) { existing in
			existing = "alpine"
		}
		
		#expect(ar.array == ["alpine", "beta"])
		#expect(ar.dictionary == ["a": "alpine", "b": "beta"])
	}
	
	@Test
	mutating func arrayIsArray() {
		#expect(Array(ar.array) == ar.array)
	}
	
	@Test
	mutating func iterator() {
		var it = ar.makeIterator()
		#expect(it.next() == "alpha")
		#expect(it.next() == "beta")
		#expect(it.next() == nil)
	}
	
	@Test
	mutating func equality() {
		var other = ar!
		
		#expect(ar == other)
		
		other.insert("charlie", at: 1)
		#expect(ar != other)
	}
}
