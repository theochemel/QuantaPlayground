import SwiftUI

public struct FinishView: View {
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.backgroundColor)
            Text("That's it!")
                .font(Font.system(size: 64.0))
                .foregroundColor(.lightTextColor)
        }
    }
}

