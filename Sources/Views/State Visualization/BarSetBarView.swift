import SwiftUI

struct BarView: View {
    @Binding var probability: Double
    @Binding var solutionProbability: Double
    let index: Int
    var maxHeight: CGFloat
    @State private var isHovering = false { didSet {
        self.displayProbabilityPopover = (self.probability >= self.solutionProbability && isHovering && self.levelInteractionStatus.isInteractionEnabled)
        self.displaySolutionProbabilityPopover = (self.probability < self.solutionProbability && isHovering && self.levelInteractionStatus.isInteractionEnabled)
    }}
    @State private var displayProbabilityPopover = false
    @State private var displaySolutionProbabilityPopover = false
    @EnvironmentObject private var levelInteractionStatus: LevelInteractionStatus

    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer(minLength: 0.0)
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(.blue)
                    .frame(width: nil, height: maxHeight * CGFloat(probability))
                    .animation(.ripple(index: index))
                    .onHover { hovering in withAnimation(.linear) { self.isHovering = hovering }}
                    .popover(isPresented: self.$displayProbabilityPopover) {
                        VStack(spacing: 8.0) {
                            Text("State: \(String(self.index, radix: 2))")
                            Text("Probability: \(self.probability)")
                            Text("Target Probability: \(self.solutionProbability)")
                        }.padding()
                }
            }
            VStack {
                Spacer(minLength: 0.0)
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(Color.gray, lineWidth: 2.0)
                    .frame(width: nil, height: maxHeight * CGFloat(solutionProbability))
                    .animation(.ripple(index: index))
                    .onHover { hovering in withAnimation(.linear) { self.isHovering = hovering }}
                    .background(
                        Image(nsImage: NSImage(named: "stripes")!)
                            .renderingMode(.template)
                            .resizable()
                            .cornerRadius(10.0)
                            .foregroundColor(.gray)
                    )
                    .popover(isPresented: self.$displaySolutionProbabilityPopover) {
                        VStack(spacing: 8.0) {
                            Text("State: \(String(self.index, radix: 2))")
                            Text("Probability: \(self.probability)")
                            Text("Target Probability: \(self.solutionProbability)")
                        }.padding()
                    }
            }.zIndex(self.solutionProbability > self.probability ? -1.0 : 1.0)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 2.0, height: 8.0)
                .offset(x: 0.0, y: 4.0)
            Text(String(self.index, radix: 2))
                .foregroundColor(.lightTextColor)
                .font(.system(size: 12.0))
                .offset(x: 0.0, y: 24.0)
        }
    }
}

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.6)
        .speed(2)
            .delay(0.02 * Double(index))
    }
}
