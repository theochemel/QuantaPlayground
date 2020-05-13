import Foundation
import SwiftUI
import Combine

public final class QuantumTimestep: Identifiable, ObservableObject, Decodable {
    public let id = UUID()
    public let objectWillChange = ObservableObjectPublisher()
    public var gates: [QuantumGateType] { didSet {
        self.objectWillChange.send()
        
        if self.gates.filter({[QuantumGateType.identity(), QuantumGateType.qubitOnControl()].contains($0)}).count == self.gates.count {
            self.gates = Array(repeating: QuantumGateType.identity(), count: self.numQubits)
        }
        
        updateQubitInvolvement()
    }}
    
    public var numQubits: Int { willSet(newValue) {
        self.objectWillChange.send()
        
        if newValue < numQubits {
            self.gates = Array(self.gates.prefix(newValue))
        } else {
            self.gates.append(contentsOf: Array(repeating: .identity(), count: newValue - numQubits))
        }
        
        self.updateQubitInvolvement()
    }}
    
    public var involvedQubits: [Int] = []
    public var containsControlledGate: Bool = false
    public var controlIndeces: [Int] = []
    public var controlCenterIndeces: [Int] = []
    public var controlConnectorIndeces: [Int] = []
    public var controlBottomIndeces: [Int] = []
    public var controlTopIndeces: [Int] = []
    
    public init(numQubits: Int) {
        self.numQubits = numQubits
        self.gates = Array(repeating: QuantumGateType.identity(), count: numQubits)
    }
    
    public init(numQubits: Int, _ gates: [QuantumGateType]) {
        guard gates.count == numQubits else { fatalError("Gate count and qubit count must match") }
        self.gates = gates
        self.numQubits = numQubits
        updateQubitInvolvement()
    }
    
    private func updateQubitInvolvement() {
        self.involvedQubits = self.gates.enumerated().filter { (i, v) in v != QuantumGateType.identity() }.map { (i, v) in i}
               
        self.containsControlledGate = self.gates.contains(QuantumGateType.qubitOnControl())
       
        if self.containsControlledGate {
               let controlIndeces = self.gates.enumerated().filter{ (i, v) in v == QuantumGateType.qubitOnControl() }.map { (i, v) in i}
               
               guard controlIndeces.count > 0 else { return }
               self.controlIndeces = controlIndeces
               
               guard let gateIndex = self.gates.firstIndex(where: { ![QuantumGateType.identity(), QuantumGateType.qubitOnControl()].contains($0) }) else { return }
              
               guard let topControlIndex = controlIndeces.min() else { return }
               guard let bottomControlIndex = controlIndeces.max() else { return }
               
               self.controlTopIndeces = (topControlIndex < gateIndex) ? [topControlIndex] : []
               self.controlBottomIndeces = (bottomControlIndex > gateIndex) ? [bottomControlIndex] : []
               
               self.controlCenterIndeces = self.controlIndeces.filter { !self.controlTopIndeces.contains($0) && !self.controlBottomIndeces.contains($0) }
               
               let min = (gateIndex < topControlIndex) ? gateIndex : topControlIndex
               let max = (gateIndex > bottomControlIndex) ? gateIndex : bottomControlIndex
               
               self.controlConnectorIndeces = ((min + 1)..<max).filter { !(controlIndeces + [gateIndex]).contains($0)}
        } else {
            self.controlIndeces = []
            self.controlCenterIndeces = []
            self.controlBottomIndeces = []
            self.controlTopIndeces = []
            self.controlConnectorIndeces = []
        }
    }
    
    public func canAddGate(_ gate: QuantumGateType, at index: Int) -> Bool {
        if gate == .identity() {
            return true
        }
        if self.containsControlledGate && gate == .qubitOnControl() {
            return true
        }
        return !self.containsControlledGate
    }
    
    public func addGate(_ gate: QuantumGateType, at index: Int) {
        guard index < self.numQubits, index >= 0 else { fatalError("Invalid index") }
        self.objectWillChange.send()
        self.gates[index] = gate
        self.updateQubitInvolvement()
    }
    
    public func removeGate(at index: Int) {
        guard index < self.numQubits, index >= 0 else { fatalError("Invalid index") }
        self.objectWillChange.send()
        self.gates[index] = .identity()
    }
    
    public func involves(_ qubit: Int) -> Bool {
        return self.involvedQubits.contains(qubit)
    }
    
    enum CodingKeys: String, CodingKey {
        case gates
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        gates = []
        var gatesContainer = try container.nestedUnkeyedContainer(forKey: .gates)
        while !gatesContainer.isAtEnd {
            gates.append(try gatesContainer.decode(QuantumGateType.self))
        }
        
        numQubits = gates.count
        
        updateQubitInvolvement()
    }
}
