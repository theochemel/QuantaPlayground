import Combine

public final class QuantumCircuitState: ObservableObject {
    public let objectWillChange = ObservableObjectPublisher()
    public var vector: Vector
    public var numQubits: Int { didSet {
        self.vector = Vector(.column, elements: [
            [Complex(1.0)],
            Array(repeating: Complex(0.0), count: 1 << self.numQubits - 1),
        ].flatMap { $0 })
        self.probabilities = []
        self.updateProbabilities()
    }}
    public var probabilities: [Double]
    
    init(_ numQubits: Int) {
        self.vector = Vector(.column, elements: [
            [Complex(1.0)],
            Array(repeating: Complex(0.0), count: 1 << numQubits - 1),
        ].flatMap { $0 })
        self.probabilities = []
        self.numQubits = numQubits
        self.updateProbabilities()
    }
    
    public func reset() {
        self.objectWillChange.send()
        self.vector = Vector(.column, elements: [
            [Complex(1.0)],
            Array(repeating: Complex(0.0), count: self.vector.length - 1),
        ].flatMap { $0 })
        self.probabilities = []
        self.updateProbabilities()
    }
    
    public func transform(by transform: Matrix) {
        guard transform.rows == vector.length && transform.columns == vector.length else { fatalError("Misshapen state transform.") }
        
        self.objectWillChange.send()
        self.vector = self.vector.multiply(by: transform)
        self.updateProbabilities()
    }
    
    private func updateProbabilities() {
        self.objectWillChange.send()
        self.probabilities = self.vector.map { ($0.absSquared() * 10000).rounded() / 10000 }
    }
}

public struct DensityMatrix {
    public var real: [[Double]]
    public var imaginary: [[Double]]
    public var minRealAmplitude: Double
    public var maxRealAmplitude: Double
    public var minImaginaryAmplitude: Double
    public var maxImaginaryAmplitude: Double
    
    init(vector: Vector) {
        let density = vector.asType(.column).matrixForm().kroneckerProduct(vector.asType(.row).matrixForm().conjugate())
        
        real = density.matrix.map { $0.map { $0.real }}
        imaginary = density.matrix.map { $0.map { $0.imaginary }}
        
        minRealAmplitude = real.map { $0.min() ?? 0 }.min() ?? 0
        maxRealAmplitude = real.map { $0.max() ?? 0 }.max() ?? 0
        minImaginaryAmplitude = imaginary.map { $0.min() ?? 0 }.min() ?? 0
        maxImaginaryAmplitude = imaginary.map { $0.max() ?? 0 }.max() ?? 0
    }
}
