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

public func drawLine(start: Point2d<Int>, end: Point2d<Int>, colour: Colour, image: Image) {
    (start.x..<end.x).forEach { (x) in
        let step = Double(x - start.x) / Double(end.x - start.x)
        let y = Double(start.y) * (1.0 - step) + Double(end.y) * step
        image.setPixel(Point2d(x: x, y: Int(y)), colour: colour)
    }
}