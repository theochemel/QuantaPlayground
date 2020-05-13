
import SwiftUI

public struct QuantumCircuitView: View {
    @ObservedObject var circuit: QuantumCircuit
    @EnvironmentObject var dragDropStatus: DragDropStatus
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0.0) {
            QubitLabelColumnView(numQubits: circuit.numQubits)
            QubitLabelSpacerColumnView(numQubits: circuit.numQubits)
            ForEach(0..<self.circuit.timesteps.count, id: \.self) { i in
                QuantumTimestepView(timestepIndex: i, timestepID: self.circuit.timesteps[i].id, timestep: self.circuit.timesteps[i])
                    .zIndex(self.dragDropStatus.isDragging && self.dragDropStatus.sourceGatePath?.0 ?? 0 == i ? 1.0 : 0.0)
            }
            QubitTrailingColumnView(numQubits: circuit.numQubits)
        }
    }
}
