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
    public var dragDropStatus: DragDropStatus
    
    private var dragDropStatusSubscription: AnyCancellable? = nil
    
    public init() {
        self.numQubits = 0
        self.timesteps = []
        self.state = QuantumCircuitState(0)
        
        // TODO: Inject this as a parameter. Let the level load the available gates and stick them in here.
        self.gateCatalog = QuantumGateCatalog()
        self.dragDropStatus = DragDropStatus()
        
        self.dragDropStatusSubscription = self.dragDropStatus.requiresExecution
            .subscribe(on: DispatchQueue.main)
            .sink { (_) in
                self.executeDragDrop()
        }
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
    
    private func executeDragDrop() {
        print("Checking drag drop...")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let sourceGateType = self.dragDropStatus.sourceGateType, let destinationGatePath = self.dragDropStatus.destinationGatePath else {
                print("Not enough info. sourceGateType: \(self.dragDropStatus.sourceGateType), destinationGatePath: \(self.dragDropStatus.destinationGatePath)")
                return
            }
    //        self.timesteps[destinationGatePath.0].gates[destinationGatePath.1] = sourceGateType
            print("Setting \(destinationGatePath) to \(sourceGateType)")
            self.timesteps[destinationGatePath.0].addGate(sourceGateType, at: destinationGatePath.1)
            
            if let sourceGatePath = self.dragDropStatus.sourceGatePath {
                self.timesteps[sourceGatePath.0].gates[sourceGatePath.1] = .identity()
            }
            self.evaluate()
            self.dragDropStatus.reset()
//        }
    }
}
