import SwiftUI

struct BarSetView: View {
    @Binding var probabilities: [Double]
    @Binding var solutionProbabilities: [Double]
    
    public var body: some View {
        ZStack {
            VStack {
                ForEach(0..<10, id: \.self) { _ in
                    Group {
                        Spacer()
                        Rectangle()
                            .foregroundColor(Color(NSColor.darkGray))
                            .frame(width: nil, height: 1.0)
                    }
                }
            }
            GeometryReader { geometry in
                HStack() {
                    ForEach(0..<self.probabilities.count, id: \.self) { i in
                        BarView(probability: self.$probabilities[i],
                                solutionProbability: self.$solutionProbabilities[i], index: i, maxHeight: geometry.size.height)
                    }
                }
            }
        }
    }
}
