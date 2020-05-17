import SwiftUI

public struct LevelIntroView: View {
    public let levelNumber: Int
    public let title: String
    public let subtitle: String
    
    public init(levelNumber: Int, title: String, subtitle: String) {
        self.levelNumber = levelNumber
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.backgroundColor)
            VStack {
                LevelNumberView(levelNumber: self.levelNumber)
                    .padding(12.0)
                Rectangle()
                    .foregroundColor(.subtitleTextColor)
                    .frame(width: 32.0, height: 1.0)
                Text(self.title)
                    .font(.system(size: 36.0))
                    .padding(6.0)
                Text(self.subtitle)
                    .font(Font.system(size: 18.0).italic())
                    .padding(4.0)
                    .foregroundColor(.subtitleTextColor)
            }
        }
    }
}
