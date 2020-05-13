import SwiftUI

public struct QuantumCircuitStateProbabilityView: View {
    @ObservedObject public var state: QuantumCircuitState
    @ObservedObject public var solutionState: QuantumCircuitState
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            BarSetView(probabilities: self.$state.probabilities, solutionProbabilities: self.$solutionState.probabilities)
                .aspectRatio(3, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .layoutPriority(1.0)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: nil, height: 2.0)
                .offset(x: 0.0, y: -1.0)
        }
    }
}
