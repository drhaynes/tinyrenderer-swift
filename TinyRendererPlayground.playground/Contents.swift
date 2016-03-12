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

func drawLine(start: Point2d<Int>, end: Point2d<Int>, colour: Colour, image: Image) {
    for (var t = 0.0; t < 1.0; t += 0.05) {
        let x = Int(Double(start.x) * (1.0 - t)) + Int(Double(end.x) * t)
        let y = Int(Double(start.y) * (1.0 - t)) + Int(Double(end.y) * t)
        image.setPixel(Point2d(x: x, y: y), colour: colour)
    }
}

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

let width = 320
let height = 240
let backgroundColour = Colour(r: 0, g: 0, b: 0)
let pixels = [Pixel](count: width * height, repeatedValue: backgroundColour)
var image = Image(width: width, height: height, pixels: pixels)
let uiImage = uiImageForImage(image)
let lineColour = Colour(r: 255, g: 255, b: 255)
drawLine(Point2d(x: 40, y: 40), end: Point2d(x: 280, y: 120), colour: lineColour, image: image)
let uiImage2 = uiImageForImage(image)


