
/**
 *  Type representing a 3d mesh
 */
public struct Mesh {
    public let vertices: [Vector3<Float>]
    public let faces: [Vector3<Int>]

    public init(vertices: [Vector3<Float>], faces: [Vector3<Int>]) {
        self.vertices = vertices
        self.faces = faces
    }

    /**
     Initialise with an .obj file specified by objPath

     - parameter objPath: Path to the .obj file that defines the mesh

     - returns: The mesh object. Coordinates in .obj are normalised from -1.0 to 1.0
     */
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
            let tokens = line.componentsSeparatedByString(" ")
            switch tokens[0] {
            case "v":
                vertices.append(Vector3(Float(tokens[1])!, Float(tokens[2])!, Float(tokens[3])!))
            case "f":
                let triplet1 = tokens[1].componentsSeparatedByString("/")
                let triplet2 = tokens[2].componentsSeparatedByString("/")
                let triplet3 = tokens[3].componentsSeparatedByString("/")
                let face = Vector3(Int(triplet1[0])! - 1, Int(triplet2[0])! - 1, Int(triplet3[0])! - 1)
                faces.append(face)
            default:
                break
            }
        }
        self.vertices = vertices
        self.faces = faces
    }
}
