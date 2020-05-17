import SwiftUI

public struct TutorialView: View {
    public var endTutorial: () -> Void
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.backgroundColor)
            VStack {
                Text("QUANTA")
                    .font(.system(size: 64.0, weight: .ultraLight, design: .default))
                    .foregroundColor(.lightTextColor)
                    .padding(4.0)
                Text("A puzzle game for the mathematically inclined.")
                    .font(Font.system(size: 18.0, weight: .light).italic())
                    .foregroundColor(.subtitleTextColor)
                    .padding(4.0)
                Text("Made with ❤️ for WWDC 2020.")
                    .font(Font.system(size: 18.0, weight: .light).italic())
                    .foregroundColor(.subtitleTextColor)
                    .padding(4.0)
                Rectangle()
                    .foregroundColor(.subtitleTextColor)
                    .frame(width: 80.0, height: 1.0)
                    .padding(4.0)
                
                Spacer()
                
                Group {
                    Text("Quantum circuits are made of sets of qubits - like bits, but subject to quantum effects.")
                        .font(Font.system(size: 18.0, weight: .light))
                        .foregroundColor(.subtitleTextColor)
                        .padding(4.0)
                    Image(nsImage: ImageProvider.qubitTutorialImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 360.0, height: nil)
                        .padding(12.0)
                    Text("Different quantum gates act on qubits in different ways. Combining them can create all kinds of circuits.")
                        .font(.system(size: 18.0, weight: .light))
                        .foregroundColor(.subtitleTextColor)
                        .padding(4.0)
                    Image(nsImage: ImageProvider.gateTutorialImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 360.0, height: nil)
                        .padding(12.0)
                    Text("Find a gate arrangement that shifts the circuit to the given state, and you win!")
                        .font(.system(size: 18.0, weight: .light))
                        .foregroundColor(.subtitleTextColor)
                        .padding(4.0)
                }
                
                Spacer()
                
                AnimatedButton(action: {
                    self.endTutorial()
                }, title: "Get Started")
                
            }.padding(40.0)
        }
    }
}
