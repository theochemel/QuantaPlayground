import Foundation

public enum VectorType {
    case row
    case column
}

public struct Vector: Sequence {
    private var backing: [Complex] {
        didSet {
            self.length = self.backing.count
        }
    }
    private(set) public var type: VectorType
    private(set) public var length: Int
    
    public let startIndex: Int = 0
    public var endIndex: Int {
        return self.length
    }
    
    public init(_ type: VectorType, length: Int) {
        self.type = type
        self.length = length
        self.backing = Array(repeating: Complex(0.0, 0.0), count: length)
    }
    
    public init(_ type: VectorType, length: Int, repeating: Complex) {
        self.type = type
        self.length = length
        self.backing = Array(repeating: repeating, count: length)
    }
    
    public init(_ type: VectorType, elements: [Complex]) {
        self.type = type
        self.length = elements.count
        self.backing = elements
    }
    
    public subscript(position: Int) -> Complex {
        get {
            return self.backing[position]
        }
        set(newValue) {
            self.backing[position] = newValue
        }
    }
    
    public func index(after: Int) -> Int {
        return after + 1
    }
    
    public func makeIterator() -> VectorIterator {
        return VectorIterator(self)
    }
    
    public func asType(_ type: VectorType) -> Vector {
        return Vector(type, elements: self.backing)
    }
    
    public func matrixForm() -> Matrix {
        switch self.type {
        case .column: return Matrix(self.length, 1, self.backing)
        default: return Matrix(1, self.length, self.backing)
        }
    }
}

extension Vector {
    
    public static func + (lhs: Vector, rhs: Vector) -> Vector {
        guard lhs.type == rhs.type else { fatalError("Mismatched vector types") }
        guard lhs.length == rhs.length else { fatalError("Mismatched vector lengths") }
        
        return Vector(lhs.type, elements: zip(lhs, rhs).map { $0 + $1 })
    }
    
    public static func - (lhs: Vector, rhs: Vector) -> Vector {
        guard lhs.type == rhs.type else { fatalError("Mismatched vector types") }
        guard lhs.length == rhs.length else { fatalError("Mismatched vector lengths") }
        
        return Vector(lhs.type, elements: zip(lhs, rhs).map { $0 - $1 })
    }
    
    public static func * (lhs: Complex, rhs: Vector) -> Vector {
        return Vector(rhs.type, elements: rhs.map { $0 * lhs })
    }
    
    public func multiply(by matrix: Matrix) -> Vector {
        guard self.type == .column, matrix.columns == self.length, matrix.rows == self.length else { fatalError("Mismatched sizes / dimensions") }
        
        let clean = matrix.clean()
        
        var elements: [Complex] = []
        
        for i in 0 ..< self.length {
            
            var a = Complex(0.0)
            
            for j in 0 ..< self.length {
                a = a + (clean[i,j] * self[j])
            }
            
            elements.append(a)
        }
        
        return Vector(.column, elements: elements)
        
        // TODO: finish this!
    }
    
    public func kroneckerProduct(_ rhs: Vector) -> Vector {
        guard self.type == rhs.type else { fatalError("Mismatched vector types") }
        
        return Vector(self.type, elements: self.map { $0 * rhs }.flatMap{$0} )
    }
    
    public func conjugate() -> Vector {
        return Vector(self.type, elements: self.map{ $0.conjugate() })
    }
    
    public func transpose() -> Vector {
        return Vector(self.type == .row ? .column : .row, elements: self.backing)
    }
    
    public func conjugateTranspose() -> Vector {
        return self.transpose().conjugate()
    }
}

extension Vector: Equatable {
    public static func == (lhs: Vector, rhs: Vector) -> Bool {
        return lhs.backing == rhs.backing
    }
}

public struct VectorIterator: IteratorProtocol {
    let vector: Vector
    var index: Int
    
    init(_ vector: Vector) {
        self.vector = vector
        self.index = 0
    }
    
    public mutating func next() -> Complex? {
        
        guard index < vector.length else { return nil }
        
        let next = vector[index]
        index += 1
        return next
    }
}


