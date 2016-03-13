import ModelIO

/**
 Create an image of particular size and fill it with the specified colour. If no
 background colour is provided, black will be used.

 - parameter width:            Width of image in pixels.
 - parameter height:           Height of image in pixels.
 - parameter backgroundColour: Background colour to fill the image with.

 - returns: The image with size and colour specified
 */
public func createImage(width width: Int, height: Int, backgroundColour: Colour = Colour(r: 0, g: 0, b: 0)) -> Image {
    let pixels = [Pixel](count: width * height, repeatedValue: backgroundColour)
    return Image(width: width, height: height, pixels: pixels)
}

public func loadObjModelNamed(name: String) -> MDLAsset {
    let path = NSBundle.mainBundle().pathForResource(name, ofType: "obj")!
    let url = NSURL(fileURLWithPath: path)
    return MDLAsset(URL: url)
}
