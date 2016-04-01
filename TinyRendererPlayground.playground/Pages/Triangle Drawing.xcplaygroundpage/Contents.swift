//: [Previous](@previous)

let image = Image(width: 320, height: 240)
let triangle1 = Triangle(Point2d(30, 90), Point2d(70, 190), Point2d(130, 30))
let triangle2 = Triangle(Point2d(230, 70), Point2d(190, 50), Point2d(120, 180))
let triangle3 = Triangle(Point2d(220, 170), Point2d(260, 140), Point2d(280, 200))

drawTriangle(triangle1, colour: Colour.red(), image: image)
drawTriangle(triangle2, colour: Colour.yellow(), image: image)
drawTriangle(triangle3, colour: Colour.green(), image: image)

let uiImage = uiImageForImage(image)

//: [Next](@next)
