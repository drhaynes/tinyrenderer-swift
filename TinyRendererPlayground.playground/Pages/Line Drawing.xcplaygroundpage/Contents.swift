//: [Previous](@previous)

let image = Image(width: 320, height: 240)

drawLine(Point2d(40, 13), end: Point2d(80, 220), colour: Colour.white(), image: image)
drawLine(Point2d(13, 50), end: Point2d(300, 140), colour: Colour.lightBlue(), image: image)
drawLine(Point2d(300, 120), end: Point2d(13, 30), colour: Colour.red(), image: image)

let uiImage = uiImageForImage(image)

//: [Next](@next)
