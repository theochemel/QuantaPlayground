import Foundation
import Combine

public final class QuantumCircuit: ObservableObject {
    public let objectWillChange = ObservableObjectPublisher()
    public var numQubits: Int { willSet(newValue) {
        self.objectWillChange.send()
        self.state.numQubits = newValue
        _ = self.timesteps.map { $0.numQubits = newValue }
        self.evaluate()
    }}
    public var timesteps: [QuantumTimestep]
    public var state: QuantumCircuitState
    public var gateCatalog: QuantumGateCatalog

    
    public init() {
        self.numQubits = 0
        self.timesteps = []
        self.state = QuantumCircuitState(0)
        
        // TODO: Inject this as a parameter. Let the level load the available gates and stick them in here.
        self.gateCatalog = QuantumGateCatalog()
    }
    
    public func reset(numTimesteps: Int) {
        self.timesteps = []
        self.state = QuantumCircuitState(self.numQubits)
        self.setTimestepCount(numTimesteps)
    }
    
    public func addTimestep() {
        self.objectWillChange.send()
        self.timesteps.append(QuantumTimestep(numQubits: self.numQubits))
        self.evaluate()
    }
    
    public func setTimestepCount(_ count: Int) {
        self.objectWillChange.send()
        
        if count < self.timesteps.count {
            self.timesteps = Array(self.timesteps.prefix(count))
        } else if count > self.timesteps.count {
            for _ in 0..<(count - self.timesteps.count) {
                self.timesteps.append(QuantumTimestep(numQubits: self.numQubits))
            }
        }
        
        self.evaluate()
    }
    
    public func evaluate() {
        self.objectWillChange.send()
        self.state.reset()

        for timestep in self.timesteps {
            var stateTransform = Matrix(1, 1, Complex(1.0))
            for gate in timestep.gates {
                guard let matrix = self.gateCatalog.matrices[gate] else { fatalError("No matrix for gate.") }
                stateTransform = stateTransform.kroneckerProduct(matrix)
            }
            stateTransform = stateTransform.clean()
            self.state.transform(by: stateTransform)
        }
    }
    
    public func executeDragDrop(sourceGateType: QuantumGateType?, sourceGatePath: (Int, Int)?, destinationGatePath: (Int, Int)?) {
        guard let sourceType = sourceGateType, let destinationPath = destinationGatePath else {
            return
        }
        self.timesteps[destinationPath.0].addGate(sourceType, at: destinationPath.1)
        
        if let sourcePath = sourceGatePath {
            self.timesteps[sourcePath.0].gates[sourcePath.1] = .identity()
        }
        self.evaluate()
    }
}
