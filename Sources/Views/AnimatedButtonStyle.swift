import SwiftUI

public struct AnimatedButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.lightTextColor)
            .padding(EdgeInsets(top: 4.0, leading: 12.0, bottom: 4.0, trailing: 12.0))
            .background(Color.buttonColor)
            .cornerRadius(8.0)
    }
}
