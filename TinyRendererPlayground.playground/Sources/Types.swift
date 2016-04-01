
public protocol ArithmeticType: Comparable {
    init()
    func * (lhs: Self, rhs: Self) -> Self
    func - (lhs: Self, rhs: Self) -> Self
    func + (lhs: Self, rhs: Self) -> Self
    func / (lhs: Self, rhs: Self) -> Self
}

extension Int: ArithmeticType {}
extension Double: ArithmeticType {}
extension Float: ArithmeticType {}
