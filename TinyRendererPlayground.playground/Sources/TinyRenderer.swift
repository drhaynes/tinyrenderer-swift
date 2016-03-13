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

extension Colour {
    public static func white() -> Colour {
        return Colour(r: 255, g: 255, b: 255)
    }
}

/// Class representing an image.
public class Image {
    public let width: Int
    public let height: Int
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

    guard start.x < image.width && start.y < image.height && end.x < image.width && end.y < image.height else {
        print("Tried to draw line outside image")
        return
    }

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

public struct Vector3<T> {
    public let x: T
    public let y: T
    public let z: T

    init(x: T, y: T, z: T) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init(_ x: T, _ y: T, _ z: T) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public struct Mesh {
    public let vertices: [Vector3<Float>]
    public let faces: [Vector3<Int>]

    public init(vertices: [Vector3<Float>], faces: [Vector3<Int>]) {
        self.vertices = vertices
        self.faces = faces
    }

    public init?(objPath: String) {
        guard let streamReader = StreamReader(path: objPath) else {
            return nil
        }
        defer {
            streamReader.close()
        }
        var vertices = [Vector3<Float>]()
        var faces = [Vector3<Int>]()
        while let line = streamReader.nextLine() {
            let tokens = line.componentsSeparatedByString(" ")
            switch tokens[0] {
            case "v":
                vertices.append(Vector3(Float(tokens[1])!, Float(tokens[2])!, Float(tokens[3])!))
                break
            case "f":
                let triplet1 = tokens[1].componentsSeparatedByString("/")
                let triplet2 = tokens[2].componentsSeparatedByString("/")
                let triplet3 = tokens[3].componentsSeparatedByString("/")
                let face = Vector3(Int(triplet1[0])! - 1, Int(triplet2[0])! - 1, Int(triplet3[0])! - 1)
                faces.append(face)
                break
            default:
                break
            }
        }
        self.vertices = vertices
        self.faces = faces
    }
}

public func renderMesh(model: Mesh, image: Image) {
    (0..<model.faces.count).forEach { (index) in
        let face = model.faces[index]
        let vertex1 = model.vertices[face.x]
        let vertex2 = model.vertices[face.y]
        let vertex3 = model.vertices[face.z]

        let halfWidth = Float(image.width / 2)
        let halfHeight = Float(image.height / 2)

        let vertex1NormalisedX = (vertex1.x + 1.0) * halfWidth
        let vertex1NormalisedY = (vertex1.y + 1.0) * halfHeight
        let vertex2NormalisedX = (vertex2.x + 1.0) * halfWidth
        let vertex2NormalisedY = (vertex2.y + 1.0) * halfHeight
        let vertex3NormalisedX = (vertex3.x + 1.0) * halfWidth
        let vertex3NormalisedY = (vertex3.y + 1.0) * halfHeight

        //TODO: remove hack, fix the root cause of drawing to y=0 blowing up
        let v1y = vertex1NormalisedY == 0 ? 1 : vertex1NormalisedY
        let v2y = vertex2NormalisedY == 0 ? 1 : vertex2NormalisedY
        let v3y = vertex3NormalisedY == 0 ? 1 : vertex3NormalisedY
        let v1x = vertex1NormalisedX == 0 ? 1 : vertex1NormalisedX
        let v2x = vertex2NormalisedX == 0 ? 1 : vertex2NormalisedX
        let v3x = vertex3NormalisedX == 0 ? 1 : vertex3NormalisedX

        // 1-2
        let startPoint = Point2d(Int(v1x), Int(v1y))
        let endPoint = Point2d(Int(v2x), Int(v2y))
        drawLine(startPoint, end: endPoint, colour: Colour.white(), image: image)

        // 2-3
        let startPoint2 = Point2d(Int(v2x), Int(v2y))
        let endPoint2 = Point2d(Int(v3x), Int(v3y))
        drawLine(startPoint2, end: endPoint2, colour: Colour.white(), image: image)

        // 3-1
        let startPoint3 = Point2d(Int(v3x), Int(v3y))
        let endPoint3 = Point2d(Int(v1x), Int(v1y))
        drawLine(startPoint3, end: endPoint3, colour: Colour.white(), image: image)
    }
}
