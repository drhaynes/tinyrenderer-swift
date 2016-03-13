//: [Previous](@previous)
import ModelIO

let image = createImage(width: 320, height: 240)

let modelPath = NSBundle.mainBundle().pathForResource("head", ofType: "obj")!

let uiImage = uiImageForImage(image)
//: [Next](@next)

public struct Vector3<T> {
    let x: T
    let y: T
    let z: T

    init(x: T, y: T, z: T) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init(_ x: T, _ y: T, _ z: T) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public struct Mesh {
    public let vertices: [Vector3<Float>]
    public let faces: [Int]

    public init(vertices: [Vector3<Float>], faces: [Int]) {
        self.vertices = vertices
        self.faces = faces
    }

    public init?(objPath: String) {
        guard let streamReader = StreamReader(path: modelPath) else {
            return nil
        }
        defer {
            streamReader.close()
        }
        while let line = streamReader.nextLine() {
            print(line)
        }
        self.vertices = [Vector3]()
        self.faces = [Int]()
    }
}
