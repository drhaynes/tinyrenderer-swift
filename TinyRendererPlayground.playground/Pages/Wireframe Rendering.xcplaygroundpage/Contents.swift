//: [Previous](@previous)
import ModelIO

let image = createImage(width: 320, height: 240)

let modelPath = NSBundle.mainBundle().pathForResource("head", ofType: "obj")!

if let aStreamReader = StreamReader(path: modelPath) {
    defer {
        aStreamReader.close()
    }
    while let line = aStreamReader.nextLine() {
        print(line)
    }
}

let uiImage = uiImageForImage(image)
//: [Next](@next)
