//: [Previous](@previous)

import Foundation

let image = Image(width: 640, height: 640)
let path = NSBundle.mainBundle().pathForResource("head", ofType: "obj")!
let mesh = Mesh(objPath: path)!

renderWireframe(mesh, image: image)

let uiImage = uiImageForImage(image)

//: [Next](@next)
