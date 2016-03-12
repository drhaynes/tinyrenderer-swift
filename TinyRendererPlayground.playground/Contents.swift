
let width = 320
let height = 240
let backgroundColour = Colour(r: 0, g: 0, b: 0)
let pixels = [Pixel](count: width * height, repeatedValue: backgroundColour)
let image = Image(width: width, height: height, pixels: pixels)
let uiImage = uiImageForImage(image)
let whiteColour = Colour(r: 255, g: 255, b: 255)
let redColour = Colour(r: 255, g: 0, b: 0)
drawLine(Point2d(x: 13, y: 30), end: Point2d(x: 300, y: 120), colour: whiteColour, image: image)
drawLine(Point2d(x: 40, y: 13), end: Point2d(x: 80, y: 220), colour: whiteColour, image: image)
drawLine(Point2d(x: 300, y: 120), end: Point2d(x: 13, y: 30), colour: redColour, image: image)

let uiImage2 = uiImageForImage(image)
