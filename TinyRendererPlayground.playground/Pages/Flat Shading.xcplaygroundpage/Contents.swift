//: [Previous](@previous)

import Foundation

let image = Image(width: 640, height: 640)
let path = NSBundle.mainBundle().pathForResource("head", ofType: "obj")!
let mesh = Mesh(objPath: path)!

renderFlatShaded(mesh, image: image)

uiImageForImage(image)

//: [Next](@next)
