
import Foundation // for sqrt

/**
 *  Generic two dimensional point.
 */
public struct Point2d<T: Comparable> {
    let x: T
    let y: T

    /**
     Initialiser

     - parameter x: X Coordinate of the point.
     - parameter y: Y Coordinate of the point.

     - returns: The point with (x, y) coordinates as specified.
     */
    public init(x: T, y: T) {
        self.x = x
        self.y = y
    }

    /**
     Convenience initialiser, useful for omitting x: & y: argument labels
     */
    public init(_ x: T, _ y: T) {
        self.x = x
        self.y = y
    }
}

/**
 *  Generic 3 component vector.
 */
public struct Vector3<T: ArithmeticType> {
    public let x: T
    public let y: T
    public let z: T

    init(x: T, y: T, z: T) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init(_ x: T, _ y: T, _ z: T) {
        self.x = x
        self.y = y
        self.z = z
    }

    public func crossProduct(other: Vector3<T>) -> Vector3<T> {
        let crossX = (y * other.z) - (other.y * z)
        let crossY = (z * other.x) - (other.z * x)
        let crossZ = (x * other.y) - (other.x * y)
        return Vector3(crossX, crossY, crossZ)
    }

    public func dotProduct(other: Vector3<T>) -> T {
        return (x * other.x) + (y * other.y) + (z * other.z)
    }
}

public func normalise(vector: Vector3<Float>) -> Vector3<Float> {
    let length = sqrtf((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z))
    return Vector3<Float>(Float(vector.x / length), Float(vector.y / length), Float(vector.z / length))
}

func - <T: ArithmeticType>(left: Vector3<T>, right: Vector3<T>) -> Vector3<T> {
    return Vector3(left.x - right.x, left.y - right.y, left.z - right.z)
}

/**
 *  Generic triangle type.
 */
public struct Triangle<T: ArithmeticType> {
    let p1: Point2d<T>
    let p2: Point2d<T>
    let p3: Point2d<T>

    public init(p1: Point2d<T>, p2: Point2d<T>, p3: Point2d<T>) {
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
    }

    public init(_ p1: Point2d<T>, _ p2: Point2d<T>, _ p3: Point2d<T>) {
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
    }

    public func axisAlignedBoundingBox() -> (Point2d<T>, Point2d<T>) {
        var minX = p1.x
        var maxX = p1.x
        var minY = p1.y
        var maxY = p1.y

        minX = min(minX, p2.x)
        minX = min(minX, p3.x)
        maxX = max(maxX, p2.x)
        maxX = max(maxX, p3.x)

        minY = min(minY, p2.y)
        minY = min(minY, p3.y)
        maxY = max(maxY, p2.y)
        maxY = max(maxY, p3.y)

        return (Point2d(minX, minY), Point2d(maxX, maxY))
    }
}
