//: [Previous](@previous)

import Foundation

let image = createImage(width: 640, height: 640)
let path = NSBundle.mainBundle().pathForResource("head", ofType: "obj")!
let mesh = Mesh(objPath: path)!
renderMesh(mesh, image: image)
let uiImage = uiImageForImage(image)

//: [Next](@next)
