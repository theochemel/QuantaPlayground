import SwiftUI

public struct LevelHeaderView: View {
    public let levelNumber: Int
    public let title: String
    public let subtitle: String
    @Binding public var displayLevelSelector: Bool
    
    public var body: some View {
        VStack(spacing: 0.0) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [.headerGradientTop, .headerGradientBottom]), startPoint: .top, endPoint: .bottom))
                HStack {
                    LevelNumberView(levelNumber: self.levelNumber)
                        .padding([.trailing], 16.0)
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.system(size: 24.0))
                        Text(self.subtitle)
                            .font(Font.system(size: 12.0).italic())
                            .padding(.top, 4.0)
                            .foregroundColor(.subtitleTextColor)
                    }
                    Spacer()
                    VStack(spacing: 8.0) {
                        AnimatedButton(action: {
                            self.displayLevelSelector = true
                        }, title: "Select Level")
                    }
                }.padding(EdgeInsets(top: 24.0, leading: 36.0, bottom: 24.0, trailing: 36.0))
                .shadow(radius: 10.0)
            }.frame(width: nil, height: 112.0)
            Rectangle()
                .foregroundColor(.black)
                .frame(width: nil, height: 1.0)
        }
    }
}
