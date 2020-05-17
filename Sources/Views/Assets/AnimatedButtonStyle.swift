import SwiftUI

public struct AnimatedButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.lightTextColor)
            .font(.system(size: 14.0))
            .padding(EdgeInsets(top: 6.0, leading: 12.0, bottom: 6.0, trailing: 12.0))
            .background(Color.buttonColor)
            .cornerRadius(8.0)
    }
}
