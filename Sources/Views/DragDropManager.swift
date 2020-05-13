import Foundation
import SwiftUI

//final public class DragDropManager: ObservableObject {
//    public var circuit: QuantumCircuit?
//
//    @Published var isDragDropInProgress = false
//
//    @Published var draggedGate: (Int, Int)?
//    @Published var selectedGate: (Int, Int)?
//    @Published var draggedGateType: QuantumGateType?
//
//    public init() {
//        print("New drag drop manager")
//    }
//
//    public init(circuit: QuantumCircuit) {
//        self.circuit = circuit
//        circuit.evaluate()
//        print("New drag drop manager: \(circuit.numQubits)")
//    }
//
//    public func endDragDropSession() {
//        print("End of drag drop: \(self.circuit?.numQubits)")
//        guard let circuit = self.circuit else {
//            print("No circuit")
//            return
//        }
//        circuit.objectWillChange.send()
//        self.objectWillChange.send()
//        self.isDragDropInProgress = false
//
//        print(self.selectedGate, self.draggedGateType)
//
//        guard let gate = selectedGate, let gateType = self.draggedGateType else {
//            print("No selected gate and/or gateType")
//            return
//        }
//        if circuit.timesteps[gate.0].canAddGate(gateType, at: gate.1) {
//            circuit.timesteps[gate.0].gates[gate.1] = gateType
//        } else {
//            print("check failed")
//        }
//
//        if let draggedGate = draggedGate {
//            circuit.timesteps[draggedGate.0].gates[draggedGate.1] = .identity()
//        }
//
//        self.selectedGate = nil
//        self.draggedGate = nil
//        self.draggedGateType = nil
//        circuit.evaluate()
//    }
//}
