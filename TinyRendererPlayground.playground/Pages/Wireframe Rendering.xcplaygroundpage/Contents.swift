//: [Previous](@previous)
import ModelIO

let image = createImage(width: 320, height: 240)

let path = NSBundle.mainBundle().pathForResource("head", ofType: "obj")!

let mesh = Mesh(objPath: path)

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
    public let faces: [Vector3<Int>]

    public init(vertices: [Vector3<Float>], faces: [Vector3<Int>]) {
        self.vertices = vertices
        self.faces = faces
    }

    public init?(objPath: String) {
        guard let streamReader = StreamReader(path: objPath) else {
            return nil
        }
        defer {
            streamReader.close()
        }
        var vertices = [Vector3<Float>]()
        var faces = [Vector3<Int>]()
        while let line = streamReader.nextLine() {
            print(line)
            let tokens = line.componentsSeparatedByString(" ")
            switch tokens[0] {
            case "v":
                vertices.append(Vector3(Float(tokens[1])!, Float(tokens[2])!, Float(tokens[3])!))
                break
            case "f":
                let triplet1 = tokens[1].componentsSeparatedByString("/")
                let triplet2 = tokens[2].componentsSeparatedByString("/")
                let triplet3 = tokens[3].componentsSeparatedByString("/")
                let face = Vector3(Int(triplet1[0])! - 1, Int(triplet2[0])! - 1, Int(triplet3[0])! - 1)
                faces.append(face)
                break
            default:
                break
            }
        }
        self.vertices = vertices
        self.faces = faces
    }
}
