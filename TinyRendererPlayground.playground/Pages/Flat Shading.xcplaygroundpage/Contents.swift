//: [Previous](@previous)

import Foundation

let image = Image(width: 640, height: 640)
let path = NSBundle.mainBundle().pathForResource("head", ofType: "obj")!
let mesh = Mesh(objPath: path)!
let lightDirection = Vector3(Float(0), Float(0), Float(-1))

renderFlatShaded(mesh, image: image, lightDirection: lightDirection)

uiImageForImage(image)

//: [Next](@next)
