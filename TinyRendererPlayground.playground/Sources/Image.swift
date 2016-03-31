import UIKit

/// Class representing an image.
public class Image {
    public let width: Int
    public let height: Int
    var pixels: [Pixel]

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
     Create an image of particular size and fill it with the specified colour. If no
     background colour is provided, black will be used.

     - parameter width:            Width of image in pixels.
     - parameter height:           Height of image in pixels.
     - parameter backgroundColour: Background colour to fill the image with.

     - returns: The image with size and colour specified
     */
    public convenience init(width: Int, height: Int, backgroundColour: Colour = Colour(r: 0, g: 0, b: 0)) {
        let pixels = [Pixel](count: width * height, repeatedValue: backgroundColour)
        self.init(width: width, height: height, pixels: pixels)
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
