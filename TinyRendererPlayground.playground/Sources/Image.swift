import UIKit

/// Reference type used to represent an image.
public class Image {
    public let width: Int
    public let height: Int
    var pixels: [Pixel]
    var depthBuffer: [Float]

    /**
     Initialser

     - parameter width:  Width of the image in pixels.
     - parameter height: Height of the image in pixels.
     - parameter pixels: Pixel data buffer array.

     - returns: An image with the values specified.
     */
    public init(width: Int, height: Int, pixels: [Pixel], depthBuffer: [Float]) {
        self.width = width
        self.height = height
        self.pixels = pixels
        self.depthBuffer = depthBuffer
    }

    /**
     Create an image of particular size and fill it with the specified colour. If no
     background colour is provided, black will be used.

     - parameter width:            Width of image in pixels.
     - parameter height:           Height of image in pixels.
     - parameter backgroundColour: Background colour to fill the image with.

     - returns: The image with size and colour specified
     */
    public convenience init(width: Int, height: Int, backgroundColour: Colour = Colour(r: 0, g: 0, b: 0)) {
        let pixels = [Pixel](count: width * height, repeatedValue: backgroundColour)
        let depthBuffer = [Float](count: width * height, repeatedValue: Float(0.0))
        self.init(width: width, height: height, pixels: pixels, depthBuffer: depthBuffer)
    }

    /**
     Set the colour of a specified pixel in the image.

     - parameter location: The coordinate of the pixel to modify.
     - parameter colour:   Colour to set the specified pixel.
     */
    public func setPixel(location: Point2d<Int>, colour: Colour) {
        pixels[indexForPoint(location)] = colour
    }

    public func setDepth(location: Point2d<Int>, value: Float) {
        depthBuffer[indexForPoint(location)] = value
    }

    public func readDepth(location: Point2d<Int>) -> Float {
        return depthBuffer[indexForPoint(location)]
    }

    func indexForPoint(point: Point2d<Int>) -> Int {
        return point.x + (pixels.count - (point.y * width))
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
