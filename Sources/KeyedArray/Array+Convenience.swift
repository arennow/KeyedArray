extension Array where Element: Equatable {
	@discardableResult
	mutating func remove(_ element: Element) -> Bool {
		guard let index = self.firstIndex(of: element) else { return false }
		
		self.remove(at: index)
		return true
	}
}
