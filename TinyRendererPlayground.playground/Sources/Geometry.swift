/**
 *  Generic two dimensional point.
 */
public struct Point2d<T> {
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
public struct Vector3<T> {
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
}

/**
 *  Generic triangle type.
 */
public struct Triangle<T> {
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
}
