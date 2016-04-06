//: [Previous](@previous)

let image = Image(width: 320, height: 240)
let triangle1 = Triangle<Float>(Vector3(30, 90, 1), Vector3(70, 190, 1), Vector3(130, 30, 1))
let triangle2 = Triangle<Float>(Vector3(230, 70, 1), Vector3(190, 50, 1), Vector3(120, 180, 1))
let triangle3 = Triangle<Float>(Vector3(220, 170, 1), Vector3(260, 140, 1), Vector3(280, 200, 1))

drawTriangle(triangle1, colour: Colour.red(), image: image)
drawTriangle(triangle2, colour: Colour.yellow(), image: image)
drawTriangle(triangle3, colour: Colour.green(), image: image)

let uiImage = uiImageForImage(image)

//: [Next](@next)
