
import SwiftUI

public struct QuantumTimestepView: View {
    let timestepIndex: Int
    let timestepID: UUID
    @ObservedObject var timestep: QuantumTimestep
    @EnvironmentObject var dragDropStatus: DragDropStatus
    
    init(timestepIndex: Int, timestepID: UUID, timestep: QuantumTimestep) {
        self.timestepIndex = timestepIndex
        self.timestepID = timestepID
        self.timestep = timestep
//        print("New QuantumTimestepView")
//        print("Index: \(self.timestepIndex), ID: \(self.timestepID)")
    }
    
    public var body: some View {
        
        VStack(alignment: .center, spacing: 0.0) {
            ForEach(0..<timestep.numQubits, id: \.self) { i in
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 76.0, height: 2.0)
                    if self.timestep.controlConnectorIndeces.contains(i) {
                        CircuitQuantumGateView(gate: self.timestep.gates[i], gatePath: (self.timestepIndex, i), controlViewType: .connector)
                    } else if self.timestep.controlCenterIndeces.contains(i) {
                        CircuitQuantumGateView(gate: self.timestep.gates[i], gatePath: (self.timestepIndex, i), controlViewType: .center)
                    } else if self.timestep.controlTopIndeces.contains(i) {
                        CircuitQuantumGateView(gate: self.timestep.gates[i], gatePath: (self.timestepIndex, i), controlViewType: .top)
                    } else if self.timestep.controlBottomIndeces.contains(i) {
                        CircuitQuantumGateView(gate: self.timestep.gates[i], gatePath: (self.timestepIndex, i), controlViewType: .bottom)
                    } else if self.timestep.gates[i] == QuantumGateType.identity() {
                        CircuitQuantumGateView(gate: self.timestep.gates[i], gatePath: (self.timestepIndex, i), controlViewType: .none)
                    } else if self.timestep.containsControlledGate {
                        CircuitQuantumGateView(gate: self.timestep.gates[i], gatePath: (self.timestepIndex, i), controlViewType: .controlledGate(self.timestep.controlIndeces.contains { $0 < i }, self.timestep.controlIndeces.contains { $0 > i }))
                    } else {
                        CircuitQuantumGateView(gate: self.timestep.gates[i], gatePath: (self.timestepIndex, i), controlViewType: .none)
                    }
                }.zIndex(self.dragDropStatus.isDragging && self.dragDropStatus.sourceGatePath ?? (0, 0) == (self.timestepIndex, i) ? 1.0 : 0.0)
            }
        }
    }
}
