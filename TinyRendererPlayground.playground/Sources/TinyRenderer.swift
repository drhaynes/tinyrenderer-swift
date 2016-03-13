import UIKit

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

/// Class representing an image.
public class Image {
    let width: Int
    let height: Int
    var pixels: [Colour]

    /**
     Initialser

     - parameter width:  Width of the image in pixels.
     - parameter height: Height of the image in pixels.
     - parameter pixels: Pixel data buffer array.

     - returns: An image with the values specified.
     */
    public init(width: Int, height: Int, pixels: [Pixel]) {
        self.width = width
        self.height = height
        self.pixels = pixels
    }

    /**
     Set the colour of a specified pixel in the image.

     - parameter location: The coordinate of the pixel to modify.
     - parameter colour:   Colour to set the specified pixel.
     */
    public func setPixel(location: Point2d<Int>, colour: Colour) {
        pixels[location.x + (pixels.count - (location.y * width))] = colour
    }
}

/**
 Convert a TinyRenderer Image into a UIImage.

 - parameter image: The image to convert.

 - returns: UIImage with contents of the input image.
 */
public func uiImageForImage(image: Image) -> UIImage? {
    guard image.pixels.count == (image.width * image.height) else {
        return nil
    }

    let pixelData = NSData(bytes: image.pixels, length: image.pixels.count * sizeof(Pixel))
    let dataProvider = CGDataProviderCreateWithCFData(pixelData)
    let bytesPerPixel = 4
    let bitsPerComponent = 8
    let colourSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)

    if let cgImage = CGImageCreate(image.width, image.height, bitsPerComponent, bytesPerPixel * 8, bytesPerPixel * image.width, colourSpace, bitmapInfo, dataProvider, nil, false, .RenderingIntentDefault) {
        return UIImage(CGImage: cgImage)
    } else {
        return nil
    }
}

/**
 Draws a coloured line from start to end in the provided image.

 - parameter start:  Starting point of the line.
 - parameter end:    End point of the line.
 - parameter colour: Colour to draw the line.
 - parameter image:  Image the line will be drawn in.
 */
public func drawLine(var start: Point2d<Int>, var end: Point2d<Int>, colour: Colour, image: Image) {
    var steepLine = false

    // If total dy is greater than dx, we work on x and y swapped, and draw 
    // them (y, x) in the call to setPixel. This prevents gaps when drawing
    // steep lines.
    if abs(start.x - end.x) < abs(start.y - end.y) {
        start = Point2d(x: start.y, y: start.x)
        end = Point2d(x: end.y, y: end.x)
        steepLine = true
    }

    // If line direction is right to left, swap the points to make it left to
    // right. This matches our drawing direction.
    if (start.x > end.x) {
        swap(&start, &end)
    }

    let deltaX = end.x - start.x
    let deltaY = end.y - start.y
    let deltaErrorTwice = abs(deltaY) * 2
    var totalErrorTwice = 0
    var y = start.y
    (start.x..<end.x).forEach { (x) in
        if steepLine {
            image.setPixel(Point2d(x: Int(y), y: x), colour: colour)
        } else {
            image.setPixel(Point2d(x: x, y: Int(y)), colour: colour)
        }
        totalErrorTwice += deltaErrorTwice
        if totalErrorTwice > deltaX {
            y += end.y > start.y ? 1 : -1
            totalErrorTwice -= deltaX * 2
        }
    }
}
