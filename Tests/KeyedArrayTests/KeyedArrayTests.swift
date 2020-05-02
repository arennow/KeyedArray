import XCTest
import KeyedArray

final class KeyedArrayTests: XCTestCase {
	struct DemoVal: Equatable, Identifiable, ExpressibleByStringLiteral {
		let str: String
		var id: Character { str.first! }
		
		init(_ str: String) { self.str = str }
		init(stringLiteral str: String) { self.str = str }
	}
	
	static var allTests = [
		("testAppend", testAppend),
		("testInsert", testInsert),
		("testRemoveByIndex", testRemoveByIndex),
		("testRemoveByKey", testRemoveByKey),
		("testReplaceByIndex", testReplaceByIndex),
		("testArrayIsArray", testArrayIsArray),
		("testIterator", testIterator)
	]
	
	var ar: KeyedArray<Character, DemoVal>!
	
	override func setUp() {
		self.ar = ["alpha", "beta"]
	}
	
	func testAppend() {
		ar.append("charlie")
		
		XCTAssertEqual(ar.array, ["alpha", "beta", "charlie"])
		XCTAssertEqual(ar["a"], "alpha")
		XCTAssertEqual(ar["b"], "beta")
		XCTAssertEqual(ar["c"], "charlie")
	}
	
	func testInsert() {
		ar.insert("charlie", at: 1)
		
		XCTAssertEqual(ar.array, ["alpha", "charlie", "beta"])
		XCTAssertEqual(ar["a"], "alpha")
		XCTAssertEqual(ar["b"], "beta")
		XCTAssertEqual(ar["c"], "charlie")
	}
	
	func testRemoveByIndex() {
		ar.remove(at: 1)
		
		XCTAssertEqual(ar.array, ["alpha"])
	}
	
	func testRemoveByKey() {
		XCTAssertNil(ar.remove(by: "Q"))
		
		XCTAssertEqual(ar.remove(by: "b"), "beta")
		XCTAssertEqual(ar.array, ["alpha"])
	}
	
	func testReplaceByIndex() {
		ar.append("bravo")
		
		XCTAssertEqual(ar.array, ["alpha", "bravo"])
		XCTAssertEqual(ar.dictionary, ["a": "alpha", "b": "bravo"])
	}
	
	func testArrayIsArray() {
		XCTAssertEqual(Array(ar.array), ar.array)
	}
	
	func testIterator() {
		var it = ar.makeIterator()
		XCTAssertEqual(it.next(), "alpha")
		XCTAssertEqual(it.next(), "beta")
		XCTAssertEqual(it.next(), nil)
	}
}
