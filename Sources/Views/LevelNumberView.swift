import SwiftUI
import AppKit

public struct LevelNumberView: View {
    let levelNumber: Int
    
    public init(levelNumber: Int) {
        self.levelNumber = levelNumber
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 6.0)
            .foregroundColor(.white)
            .frame(width: 48.0, height: 48.0)
            .overlay(
                Image(nsImage: ImageProvider.levelNumberIcon(for: self.levelNumber))
                    .resizable()
                    .padding(6.0)
            )
    }
}
