
extension Comparable{
    
    func clamp(to range: ClosedRange<Self>) -> Self {
        return min(range.upperBound, max(self, range.lowerBound))
    }
    
}
