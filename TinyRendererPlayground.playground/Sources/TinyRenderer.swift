import UIKit

public struct Point2d<T> {
    let x: T
    let y: T

    public init(x: T, y: T) {
        self.x = x
        self.y = y
    }
}

public struct Pixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8 = 255

    public init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
}

public typealias Colour = Pixel

public class Image {
    let width: Int
    let height: Int
    var pixels: [Colour]

    public init(width: Int, height: Int, pixels: [Pixel]) {
        self.width = width
        self.height = height
        self.pixels = pixels
    }

    public func setPixel(location: Point2d<Int>, colour: Colour) {
        pixels[location.x + (pixels.count - (location.y * width))] = colour
    }
}


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

    let deltaX = Double(end.x - start.x)
    let deltaY = Double(end.y - start.y)
    let deltaError = abs(deltaY / deltaX)
    var totalError = 0.0
    var y = start.y
    (start.x..<end.x).forEach { (x) in
        if steepLine {
            image.setPixel(Point2d(x: Int(y), y: x), colour: colour)
        } else {
            image.setPixel(Point2d(x: x, y: Int(y)), colour: colour)
        }
        totalError += deltaError
        if totalError > 0.5 {
            y += end.y > start.y ? 1 : -1
            totalError -= 1
        }
    }
}
