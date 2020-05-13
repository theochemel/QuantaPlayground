import Foundation
import AppKit

public final class QuantumGateCatalog: ObservableObject {
      
    @Published var categories: [QuantumGateCategory] = [
        QuantumGateCategory.base(),
        QuantumGateCategory.pauli(),
        QuantumGateCategory.superposition(),
        QuantumGateCategory.phase(),
        QuantumGateCategory.control(),
    ]
    
    @Published var gates: [QuantumGateCategory: [QuantumGateType]] = [
        QuantumGateCategory.base(): [
            QuantumGateType.identity(),
        ],
        QuantumGateCategory.pauli(): [
            QuantumGateType.pauliX(),
            QuantumGateType.pauliY(),
            QuantumGateType.pauliZ(),
        ],
        QuantumGateCategory.superposition(): [
            QuantumGateType.hadamard()
        ],
        QuantumGateCategory.phase(): [
            QuantumGateType.t(),
            QuantumGateType.tComplexConj(),
            QuantumGateType.v(),
            QuantumGateType.vComplexConj(),
        ],
        QuantumGateCategory.control(): [
            QuantumGateType.qubitOnControl(),
        ],
    ]
    
    @Published var matrices: [QuantumGateType: Matrix] = [
        QuantumGateType.identity():       Matrix(2, 2, [Complex(1.0), Complex(0.0), Complex(0.0), Complex(1.0)]),
        QuantumGateType.pauliX():         Matrix(2, 2, [Complex(0.0), Complex(1.0), Complex(1.0), Complex(0.0)]),
        QuantumGateType.pauliY():         Matrix(2, 2, [Complex(0.0), Complex(imaginary: -1.0), Complex(imaginary: 1.0), Complex(0.0)]),
        QuantumGateType.pauliZ():         Matrix(2, 2, [Complex(1.0), Complex(0.0), Complex(0.0), Complex(-1.0)]),
        QuantumGateType.hadamard():       Matrix(2, 2, [Complex(1.0), Complex(1.0), Complex(1.0), Complex(-1.0)]) * Complex(1/sqrt(2.0)),
        QuantumGateType.t():              Matrix(2, 2, [Complex(1.0), Complex(0.0), Complex(0.0), Complex(cos(.pi/4), sin(.pi/4))]),
        QuantumGateType.tComplexConj():   Matrix(2, 2, [Complex(1.0), Complex(0.0), Complex(0.0), Complex(sin(.pi/4), -cos(.pi/4))]),
        QuantumGateType.v():              Matrix(2, 2, [Complex(0.5, 0.5), Complex(0.5, -0.5), Complex(0.5, -0.5), Complex(0.5, 0.5)]),
        QuantumGateType.vComplexConj():   Matrix(2, 2, [Complex(0.5, -0.5), Complex(0.5, 0.5), Complex(0.5, 0.5), Complex(0.5, -0.5)]),
        QuantumGateType.qubitOnControl(): Matrix(2, 2, [Complex.controlEntry(), Complex(0.0), Complex(0.0), Complex(1.0),
        ]),
    ]
    
    @Published var icons: [QuantumGateType: String] = [
        QuantumGateType.identity():       "Identity",
        QuantumGateType.pauliX():         "Pauli X",
        QuantumGateType.pauliY():         "Pauli Y",
        QuantumGateType.pauliZ():         "Pauli Z",
        QuantumGateType.hadamard():       "Hadamard",
        QuantumGateType.t():              "T",
        QuantumGateType.tComplexConj():   "T Conjugate Transpose",
        QuantumGateType.v():              "V",
        QuantumGateType.vComplexConj():   "V Conjugate Transpose",
        QuantumGateType.qubitOnControl(): "Control",
    ]
}
