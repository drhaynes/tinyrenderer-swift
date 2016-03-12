//: Playground - noun: a place where people can play

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

func createImage(width: Int, height: Int, pixels: [Pixel]) -> UIImage? {
    guard pixels.count == (width * height) else {
        return nil
    }
    let dataProvider = CGDataProviderCreateWithCFData(
        NSData(bytes: pixels, length: pixels.count * sizeof(Pixel))
    )

    let bytesPerPixel = 4
    let bitsPerComponent = 8
    let colourSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
    if let cgImage = CGImageCreate(width, height, bitsPerComponent, bytesPerPixel * 8, bytesPerPixel * width, colourSpace, bitmapInfo, dataProvider, nil, false, .RenderingIntentDefault) {
        let image = UIImage(CGImage: cgImage)
        UIImagePNGRepresentation(image)
        return image
    } else {
        return nil
    }
}

let width = 320
let height = 240
let redPixel = Pixel(r: 255, g: 0, b: 0)
let pixelData = [Pixel](count: width * height, repeatedValue: redPixel)
let image = createImage(width, height: height, pixels: pixelData)
