//: [Previous](@previous)

let image = createImage(width: 320, height: 240)
let whiteColour = Colour(r: 255, g: 255, b: 255)
let redColour = Colour(r: 255, g: 0, b: 0)
let blueColour = Colour(r: 128, g: 128, b: 255)

drawLine(Point2d(40, 13), end: Point2d(80, 220), colour: whiteColour, image: image)
drawLine(Point2d(13, 50), end: Point2d(300, 140), colour: blueColour, image: image)
drawLine(Point2d(300, 120), end: Point2d(13, 30), colour: redColour, image: image)

let uiImage = uiImageForImage(image)

//: [Next](@next)
