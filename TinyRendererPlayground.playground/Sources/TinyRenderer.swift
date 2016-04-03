

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
        let triangle = projectModelFaceIntoScreenSpaceTriangle(model.faces[index], model: model, image: image)
        drawLine(triangle.p1, end: triangle.p2, colour: Colour.white(), image: image)
        drawLine(triangle.p2, end: triangle.p3, colour: Colour.white(), image: image)
        drawLine(triangle.p3, end: triangle.p1, colour: Colour.white(), image: image)
    }
}

/**
 Renders a mesh into an image using a flat shaded style.

 - parameter model: The mesh model to render.
 - parameter image: The image to render into.
 */
public func renderFlatShaded(model: Mesh, image: Image, lightDirection: Vector3<Float>) {
    (0..<model.faces.count).forEach { (index) in
        let face = model.faces[index]
        let triangle = projectModelFaceIntoScreenSpaceTriangle(face, model: model, image: image)
        let normal = normalForFace(face, inModel: model)
        let lightIntensity = normal.dotProduct(lightDirection)
        if lightIntensity > 0 {
            drawTriangle(triangle, colour: Colour.white(UInt8(lightIntensity * Float(255))), image: image)
        }
    }
}

/**
 Renders a triangle into the image with colour speficied.
 
 - parameter triangle: The triangle to render.
 - parameter colour: The colour to render the triangle.
 - parameter image: The image to render into.
 */
public func drawTriangle(triangle: Triangle<Int>, colour: Colour, image: Image) {
    let bounds = triangle.axisAlignedBoundingBox()
    for x in bounds.0.x...bounds.1.x {
        for y in bounds.0.y...bounds.1.y {
            let point = Point2d(x, y)
            if triangleContainsPoint(triangle, point: point) {
                image.setPixel(point, colour: colour)
            }
        }
    }
}

/**
 Determines if a point is inside a given triangle.

 - parameter triangle: The triangle of interest.
 - parameter point: The point to test.

 - returns: True if the point is inside the given triangle, false if outside.
 */
func triangleContainsPoint(triangle: Triangle<Int>, point: Point2d<Int>) -> Bool {
    let v1 = Vector3(Float(triangle.p3.x - triangle.p1.x), Float(triangle.p2.x - triangle.p1.x), Float(triangle.p1.x - point.x))
    let v2 = Vector3(Float(triangle.p3.y - triangle.p1.y), Float(triangle.p2.y - triangle.p1.y), Float(triangle.p1.y - point.y))
    let u = v1.crossProduct(v2)

    let x = 1.0 - (u.x + u.y) / u.z
    let y = u.y / u.z
    let z = u.x / u.z
    let baryCentricCoordinate = Vector3(x, y, z)
    
    if baryCentricCoordinate.x < 0 || baryCentricCoordinate.y < 0 || baryCentricCoordinate.z < 0 {
        return false
    } else {
        return true
    }
}

/**
 Projects a 3d coordinate from world space into 2d image space orthographically.

 Coordinates will be scaled both horiztonally and vertically to fit the image
 dimensions.

 - parameter coordinate: The world-space 3d coordinate to project.
 - parameter image: The image to project into.

 - returns: The projected point.
 */
func screenCoordinateForWorldCoordinate(coordinate: Vector3<Float>, image: Image) -> Point2d<Int> {
    let halfWidth = Float(image.width / 2)
    let halfHeight = Float(image.height / 2)

    let vertex1NormalisedX = (coordinate.x + 1.0) * halfWidth
    let vertex1NormalisedY = (coordinate.y + 1.0) * halfHeight

    //TODO: remove hack, fix the root cause of drawing to y=0 blowing up
    let y = vertex1NormalisedY == 0 ? 1 : vertex1NormalisedY
    let x = vertex1NormalisedX == 0 ? 1 : vertex1NormalisedX

    return Point2d(Int(x), Int(y))
}

/**
 Projects a face consisting of three 3d coordinates from world space into 2d
 image space orthographically.

 Coordinates will be scaled both horiztonally and vertically to fit the image
 dimensions.

 - parameter face: The world-space 3d face to project (must be triangular).
 - parameter mode: The model the face belongs to. This is used to look up vertices.
 - parameter image: The image to project into.

 - returns: The projected triangle.
 */
func projectModelFaceIntoScreenSpaceTriangle(face: Vector3<Int>, model: Mesh, image: Image) -> Triangle<Int> {
    let vertex1 = model.vertices[face.x]
    let vertex2 = model.vertices[face.y]
    let vertex3 = model.vertices[face.z]

    let point1 = screenCoordinateForWorldCoordinate(vertex1, image: image)
    let point2 = screenCoordinateForWorldCoordinate(vertex2, image: image)
    let point3 = screenCoordinateForWorldCoordinate(vertex3, image: image)
    return Triangle(point1, point2, point3)
}

func normalForFace(face: Vector3<Int>, inModel model: Mesh) -> Vector3<Float> {
    let vertex1 = model.vertices[face.x]
    let vertex2 = model.vertices[face.y]
    let vertex3 = model.vertices[face.z]

    return normalise((vertex3 - vertex1).crossProduct(vertex2 - vertex1))
}
