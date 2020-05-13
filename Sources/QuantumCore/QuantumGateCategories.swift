import Foundation

public typealias QuantumGateCategory = String

extension QuantumGateCategory {
    static func base() -> QuantumGateCategory { "base" }
    static func pauli() -> QuantumGateCategory { "pauli" }
    static func superposition() -> QuantumGateCategory { "hadamard" }
    static func phase() -> QuantumGateCategory { "phase" }
    static func control() -> QuantumGateCategory { "control" }
}
