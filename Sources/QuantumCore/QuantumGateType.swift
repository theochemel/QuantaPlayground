import Foundation

public typealias QuantumGateType = String

extension QuantumGateType {
    public static func identity() -> QuantumGateType { "identity" }
    public static func pauliX() -> QuantumGateType { "pauliX" }
    public static func pauliY() -> QuantumGateType { "pauliY" }
    public static func pauliZ() -> QuantumGateType { "pauliZ" }
    public static func hadamard() -> QuantumGateType { "hadamard" }
    public static func t() -> QuantumGateType { "t" }
    public static func tComplexConj() -> QuantumGateType { "tComplexConj" }
    public static func v() -> QuantumGateType { "v" }
    public static func vComplexConj() -> QuantumGateType { "vComplexConj" }
    public static func qubitOnControl() -> QuantumGateType { "qubitOnControl" }
}
