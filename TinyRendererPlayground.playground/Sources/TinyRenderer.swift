

/**
 Draws a coloured line from start to end in the provided image.

 - parameter start:  Starting point of the line.
 - parameter end:    End point of the line.
 - parameter colour: Colour to draw the line.
 - parameter image:  Image the line will be drawn in.
 */
public func drawLine(start: Point2d<Int>, end: Point2d<Int>, colour: Colour, image: Image) {

    guard start.x < image.width && start.y < image.height && end.x < image.width && end.y < image.height else {
        print("Tried to draw line outside image")
        return
    }

    var steepLine = false

    // make start and end points mutable so we can swap them if required.
    var start = start
    var end = end

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

    // Optimised line drawing loop
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

/**
 Renders a mesh into an image as a wireframe.

 - parameter model: The mesh model to render.
 - parameter image: The image to render into.
 */
public func renderWireframe(model: Mesh, image: Image) {
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

/**
 Renders a triangle into the image with colour speficied.
 
 - parameter triangle: The triangle to render.
 - parameter colour: The colour to render the triangle.
 - parameter image: The image to render into.
 */
public func drawTriangle(triangle: Triangle<Int>, colour: Colour, image: Image) {
    let topLeft = Point2d(image.width - 1, image.height - 1)
    let bottomRight = Point2d(0, 0)
    let clamp = topLeft
    drawLine(triangle.p1, end: triangle.p2, colour: colour, image: image)
    drawLine(triangle.p2, end: triangle.p3, colour: colour, image: image)
    drawLine(triangle.p3, end: triangle.p1, colour: colour, image: image)
}
