import Foundation
import simd

public struct Complex {
    public var real: Double
    public var imaginary: Double
    
    public var isControlEntry: Bool = false
    
    public init(_ real: Double, _ imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
    
    public init(_ real: Double) {
        self.real = real
        self.imaginary = 0.0
    }
    
    public init(imaginary: Double) {
        self.real = 0.0
        self.imaginary = imaginary
    }
    
    public static func controlEntry() -> Complex {
        var controlEntry = Complex(1.0)
        controlEntry.isControlEntry = true
        return controlEntry
    }
}

extension Complex: CustomStringConvertible {
    public var description: String { return "(\(real)\(imaginary >= 0 ? "+" : "")\(imaginary)i)" }
}

extension Complex: Equatable {
    public static func == (lhs: Complex, rhs: Complex) -> Bool {
        return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary && lhs.isControlEntry == rhs.isControlEntry
    }
}

extension Complex {
    
    // https://mathbitsnotebook.com/Algebra2/ComplexNumbers/CPArithmeticASM.html
    
    public static func + (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real + rhs.real, lhs.imaginary + rhs.imaginary)
    }
    
    public static func - (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real - rhs.real, lhs.imaginary - rhs.imaginary)
    }
    
    public static func * (lhs: Complex, rhs: Complex) -> Complex {
        
        // TODO: Take another look at this. Not sure if controlEntries should be allowed to propagate like this.
        return Complex(lhs.real * rhs.real - lhs.imaginary * rhs.imaginary, lhs.real * rhs.imaginary + lhs.imaginary * rhs.real)
    }
    
    public func controlledProduct(_ rhs: Complex, _ i1: Int, _ i2: Int, _ j1: Int, _ j2: Int) -> Complex {
        if self.isControlEntry {
            return (i2 == j2) ? Complex.controlEntry() : Complex(0.0)
        } else if rhs.isControlEntry {
            return (i1 == j1) ? Complex.controlEntry() : Complex(0.0)
        } else {
            return self * rhs
        }
    }
    
    public func abs() -> Double {
        return sqrt(pow(real, 2) + pow(imaginary, 2))
    }
    
    public func absSquared() -> Double {
        return pow(self.abs(), 2)
    }
    public func conjugate() -> Complex {
        return Complex(self.real, -self.imaginary)
    }
}
