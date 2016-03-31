//: [Previous](@previous)

import Foundation

let image = Image(width: 320, height: 240)
let triangle1 = Triangle(Point2d(10, 70), Point2d(50, 160), Point2d(70, 80))
let triangle2 = Triangle(Point2d(180, 50), Point2d(150, 10), Point2d(70, 180))
let triangle3 = Triangle(Point2d(180, 150), Point2d(120, 160), Point2d(130, 180))

drawTriangle(triangle1, colour: Colour.red(), image: image)
drawTriangle(triangle2, colour: Colour.yellow(), image: image)
drawTriangle(triangle3, colour: Colour.green(), image: image)

let uiImage = uiImageForImage(image)


//: [Next](@next)
