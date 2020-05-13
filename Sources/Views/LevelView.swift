import SwiftUI

public struct LevelView: View {
    @Binding public var level: Level
    
    public init(level: Level) {
        print("New LevelView created")
        print(level.levelNumber)
        self.level = level
    }
    
    public var body: some View {
        VStack {
            LevelHeaderView(levelNumber: self.level.levelNumber, title: self.level.title, subtitle: self.level.subtitle)
            QuantumGateStoreView(store: self.$level.circuit.gateCatalog)
                .padding([.top, .leading, .trailing], 40.0)
                .zIndex(1.0)
            Spacer()
            QuantumCircuitView(circuit: self.level.circuit)
                .padding([.leading, .trailing], 40.0)
            Spacer()
            QuantumCircuitStateProbabilityView(state: self.level.circuit.state, solutionState: self.level.solutionCircuit.state)
                .padding([.bottom, .leading, .trailing], 40.0)
        }
            .background(Color.backgroundColor)
        .environmentObject(self.level.circuit.dragDropStatus)
//            .environmentObject(DragDropManager(circuit: self.level.circuit))
            .environmentObject(self.level.circuit.gateCatalog)
    }
}