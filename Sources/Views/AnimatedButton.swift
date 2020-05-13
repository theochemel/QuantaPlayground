import SwiftUI

public struct AnimatedButton: View {
    let action: () -> Void
    let title: String
    @State private var isHovering = false
    
    public init(action: @escaping () -> Void, title: String) {
        self.action = action
        self.title = title
    }
    
    public var body: some View {
            Button(action: action) {
                Text(title)
            }
                .buttonStyle(AnimatedButtonStyle())
                .onHover { isHovering in withAnimation { self.isHovering = isHovering }}
                .shadow(radius: self.isHovering ? 18.0 : 10.0)
                .scaleEffect(self.isHovering ? 1.05 : 1.0)
    }
}
