/**
 *  An RGBA32 Pixel.
 */
public struct Pixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8 = 255

    /**
     Initialiser

     - parameter r: The red value (0-255).
     - parameter g: Green value (0-255).
     - parameter b: Blue value (0-255).

     - returns: Pixel with the RGB values specified. Alpha value is always 255.
     */
    public init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
}

/// Convenience type to represent colours.
public typealias Colour = Pixel

extension Colour {
    public static func white() -> Colour {
        return Colour(r: 255, g: 255, b: 255)
    }

    public static func red() -> Colour {
        return Colour(r: 255, g: 0, b: 0)
    }

    public static func lightBlue() -> Colour {
        return Colour(r: 128, g: 128, b: 255)
    }
}
