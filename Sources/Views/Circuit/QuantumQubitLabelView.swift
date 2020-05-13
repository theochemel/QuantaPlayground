
import SwiftUI

struct QubitLabelView: View {
    var index: Int
    
    var body: some View {
        Image(nsImage: ImageProvider.qubitIcon(for: self.index))
            .resizable()
            .renderingMode(.template)
            .frame(width: 60.0, height: 60.0)
            .padding(8.0)
    }
}

struct QubitLabelColumnView: View {
    let numQubits: Int
    
    var body: some View {
        VStack(spacing: 0.0) {
            ForEach(0..<self.numQubits, id: \.self) {
                QubitLabelView(index: $0)
            }
        }
    }
}

struct QubitLabelSpacerColumnView: View {
    let numQubits: Int
    
    var body: some View {
        VStack(spacing: 0.0) {
            ForEach(0..<self.numQubits, id: \.self) { _ in
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 76.0, height: 76.0)
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [.clear, .gray]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 76.0, height: 2.0)
                }
            }
        }
    }
}

struct QubitTrailingColumnView: View {
    let numQubits: Int
    
    var body: some View {
        VStack(spacing: 0.0) {
            ForEach(0..<self.numQubits, id: \.self) { _ in
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 76.0, height: 76.0)
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [.gray, .clear]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 76.0, height: 2.0)
                }
            }
        }
    }
}

