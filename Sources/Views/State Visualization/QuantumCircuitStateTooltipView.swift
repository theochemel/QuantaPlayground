import Foundation
import SwiftUI

public struct QuantumCircuitStateTooltipView: View {
    
    public let state: Int
    public let probability: Double
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(.gray)
            Text("State: \(String(state, radix: 2))")
            Text("Probability: \(probability)")
        }
    }
}
