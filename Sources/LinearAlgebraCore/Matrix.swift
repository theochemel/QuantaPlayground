import Foundation

public struct Matrix {
    public let rows: Int
    public let columns: Int
    var matrix: [[Complex]]
    
    public init(_ rows: Int, _ columns: Int) {
        self.rows = rows
        self.columns = columns
        self.matrix = Array(repeating: Array(repeating: Complex(0.0, 0.0), count: columns), count: rows)
    }
    
    public init(_ rows: Int, _ columns: Int, _ filler: Complex) {
        self.rows = rows
        self.columns = columns
        self.matrix = Array(repeating: Array(repeating: filler, count: columns), count: rows)
    }
    
    public init(_ rows: Int, _ columns: Int, _ elements: [Complex]) {
        self.rows = rows
        self.columns = columns
        self.matrix = Array(repeating: Array(repeating: Complex(0.0, 0.0), count: columns), count: rows)
        
        guard elements.count == rows * columns else { fatalError("Bad elements length.") }
        
        for i in 0 ..< self.rows {
            for j in 0 ..< self.columns {
                self[i, j] = elements[i * columns + j]
            }
        }
    }
    
    public subscript(row: Int, column: Int) -> Complex {
        get {
            return self.matrix[row][column]
        }
        set(newValue) {
            self.matrix[row][column] = newValue
        }
    }
    
    public func row(_ i: Int) -> Vector {
        return Vector(.row, elements: matrix[i])
    }
    
    public func column(_ i: Int) -> Vector {
        return Vector(.column, elements: matrix.map{ $0[i] })
    }
}

extension Matrix: CustomStringConvertible {
    public var description: String {
        
        var output = ""
        
        for i in 0 ..< self.rows {
            for j in 0 ..< self.columns {
                output += self[i, j].description
                output += " "
            }
            output += "\n"
        }
        return output
    }
}

extension Matrix: Equatable {
    public static func == (lhs: Matrix, rhs: Matrix) -> Bool {
        return lhs.matrix == rhs.matrix
    }
}

extension Matrix {
    public static func * (lhs: Matrix, rhs: Matrix) -> Matrix {
        guard lhs.columns == rhs.rows else { fatalError("Misshappen matricies.") }
        
        var product = Matrix(lhs.rows, rhs.columns)
        
        for i in 0 ..< product.rows {
            for j in 0 ..< product.columns {
                for k in 0 ..< lhs.columns {
                    product[i, j] = product[i, j] + (lhs[i, k] * rhs[k, j])
                }
            }
        }
        
        return product
    }
    
    public static func * (lhs: Matrix, rhs: Complex) -> Matrix {
        var product = lhs
        
        for i in 0 ..< product.rows {
            for j in 0 ..< product.columns {
                product[i, j] = product[i, j] * rhs
            }
        }
        
        return product
    }
    
    public func kroneckerProduct(_ other: Matrix) -> Matrix {
        var kroneckerProduct = Matrix(self.rows * other.rows, self.columns * other.columns)
        
        for i1 in 0 ..< self.rows {
            for j1 in 0 ..< self.columns {
                for i2 in 0 ..< other.rows {
                    for j2 in 0 ..< other.columns {
                        kroneckerProduct[i1 * other.rows + i2, j1 * other.rows + j2] = self[i1, j1].controlledProduct(other[i2, j2], i1, i2, j1, j2)
                    }
                }
            }
        }
        
        return kroneckerProduct
    }
    
    public func conjugate() -> Matrix {
        var conjugate = Matrix(self.rows, self.columns)
        
        for i in 0 ..< self.rows {
            for j in 0 ..< self.columns {
                conjugate[i, j] = self[i, j].conjugate()
            }
        }
        
        return conjugate
    }
    
    public func transpose() -> Matrix {
        var transpose = Matrix(self.columns, self.rows)
        
        for i in 0 ..< transpose.rows {
            for j in 0 ..< transpose.columns {
                transpose[i, j] = self[j, i]
            }
        }
        
        return transpose
    }
    
    public func conjugateTranspose() -> Matrix {
        return self.transpose().conjugate()
    }
    
    public func identity() -> Matrix {
        guard self.rows == self.columns else { fatalError("Misshappen matrix.") }
        
        var identity = Matrix(self.rows, self.columns)
        
        for i in 0 ..< rows {
            identity[i, i] = Complex(1.0, 0.0)
        }
        
        return identity
    }
    
    public func isUnitary() -> Bool {
        return self.conjugateTranspose() * self == self.identity()
    }
    
    public func clean() -> Matrix {
        var clean = Matrix(self.rows, self.columns)
        
        for i in 0  ..< self.rows {
            for j in 0 ..< self.columns {
                clean[i,j] = Complex(self[i,j].real, self[i,j].imaginary)
            }
        }
        
        return clean
    }
}
