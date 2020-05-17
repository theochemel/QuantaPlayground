import Foundation
import Combine

public final class Level: ObservableObject, Decodable {
    public let objectWillChange = ObservableObjectPublisher()
    public let isCompleted = PassthroughSubject<Void, Never>()
    public var levelNumber: Int
    public var title: String
    public var subtitle: String
    public var numQubits: Int
    public var numTimesteps: Int
    public var allowedGates: [QuantumGateType]
        
    public var circuit =  QuantumCircuit()
    public var solutionCircuit = QuantumCircuit()
    
    private var anyCancellable: AnyCancellable? = nil
    
    public init(levelNumber: Int, title: String, subtitle: String, numQubits: Int, numTimesteps: Int, allowedGates: [QuantumGateType], solution: [QuantumTimestep]) {
        self.levelNumber = levelNumber
        self.title = title
        self.subtitle = subtitle
        self.numQubits = numQubits
        self.numTimesteps = numTimesteps
        self.allowedGates = allowedGates
        
        self.circuit.numQubits = numQubits
        self.circuit.setTimestepCount(numTimesteps)
        self.circuit.evaluate()
        
        self.solutionCircuit.numQubits = numQubits
        self.solutionCircuit.setTimestepCount(numTimesteps)
        self.solutionCircuit.timesteps = solution
        self.solutionCircuit.evaluate()
        
        self.anyCancellable = self.circuit.objectWillChange.sink { (_) in
            DispatchQueue.main.async {
                self.compareCircuitToSolution()
            }
        }
    }
    
    public func reset() {
        self.circuit.reset(numTimesteps: self.numTimesteps)

        self.anyCancellable = self.circuit.objectWillChange.sink { (_) in
            DispatchQueue.main.async {
                self.compareCircuitToSolution()
            }
        }
    }
    
    private func compareCircuitToSolution() {
        let circuitProbabilities = self.circuit.state.probabilities
        let solutionProbabilities = self.solutionCircuit.state.probabilities
            
        if circuitProbabilities == solutionProbabilities {
            self.isCompleted.send()
            self.anyCancellable?.cancel()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case levelNumber = "level_number"
        case title
        case subtitle
        case numQubits = "num_qubits"
        case numTimesteps = "num_timesteps"
        case allowedGates = "allowed_gates"
        case solution
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        levelNumber = try container.decode(Int.self, forKey: .levelNumber)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        numQubits = try container.decode(Int.self, forKey: .numQubits)
        numTimesteps = try container.decode(Int.self, forKey: .numTimesteps)
        
        allowedGates = []
        var allowedGatesContainer = try container.nestedUnkeyedContainer(forKey: .allowedGates)
        while !allowedGatesContainer.isAtEnd {
            allowedGates.append(try allowedGatesContainer.decode(QuantumGateType.self))
        }
        
        var solution: [QuantumTimestep] = []
        var solutionContainer = try container.nestedUnkeyedContainer(forKey: .solution)
        while !solutionContainer.isAtEnd {
            solution.append(try solutionContainer.decode(QuantumTimestep.self))
        }
        
        self.circuit.numQubits = numQubits
        self.circuit.setTimestepCount(numTimesteps)
        self.circuit.evaluate()
        
        self.solutionCircuit.numQubits = numQubits
        self.solutionCircuit.setTimestepCount(numTimesteps)
        self.solutionCircuit.timesteps = solution
        self.solutionCircuit.evaluate()
        
        self.anyCancellable = self.circuit.objectWillChange.sink { (_) in
            DispatchQueue.main.async {
                self.compareCircuitToSolution()
            }
        }
    }
}
