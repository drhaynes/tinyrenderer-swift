import UIKit

struct Point2d<T> {
    let x: T
    let y: T
}

struct Pixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8 = 255
}

class Image {
    let width: Int
    let height: Int
    var pixels: [Pixel]

    init(width: Int, height: Int, pixels: [Pixel]) {
        self.width = width
        self.height = height
        self.pixels = pixels
    }

    func setPixel(location: Point2d<Int>, colour: Colour) {
        pixels[location.x + (pixels.count - (location.y * width))] = colour
    }
}

typealias Colour = Pixel

func uiImageForImage(image: Image) -> UIImage? {
    guard image.pixels.count == (image.width * image.height) else {
        return nil
    }

    let pixelData = NSData(bytes: image.pixels, length: image.pixels.count * sizeof(Pixel))
    let dataProvider = CGDataProviderCreateWithCFData(pixelData)
    let bytesPerPixel = 4
    let bitsPerComponent = 8
    let colourSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)

    if let cgImage = CGImageCreate(image.width, image.height, bitsPerComponent, bytesPerPixel * 8, bytesPerPixel * width, colourSpace, bitmapInfo, dataProvider, nil, false, .RenderingIntentDefault) {
        return UIImage(CGImage: cgImage)
    } else {
        return nil
    }
}

func drawLine(start: Point2d<Int>, end: Point2d<Int>, colour: Colour, image: Image) {
    (start.x..<end.x).forEach { (x) in
        let step = Double(x - start.x) / Double(end.x - start.x)
        let y = Double(start.y) * (1.0 - step) + Double(end.y) * step
        image.setPixel(Point2d(x: x, y: Int(y)), colour: colour)
    }
}

let width = 90
let height = 90
let backgroundColour = Colour(r: 0, g: 0, b: 0)
let pixels = [Pixel](count: width * height, repeatedValue: backgroundColour)
let image = Image(width: width, height: height, pixels: pixels)
let uiImage = uiImageForImage(image)
let lineColour = Colour(r: 255, g: 255, b: 255)
drawLine(Point2d(x: 13, y: 20), end: Point2d(x: 80, y: 40), colour: lineColour, image: image)
drawLine(Point2d(x: 20, y: 13), end: Point2d(x: 40, y: 80), colour: lineColour, image: image)
let uiImage2 = uiImageForImage(image)


