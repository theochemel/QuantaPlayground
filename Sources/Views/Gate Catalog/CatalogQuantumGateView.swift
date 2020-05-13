import SwiftUI

struct CatalogQuantumGateView: View {
    @EnvironmentObject var gateCatalog: QuantumGateCatalog
    @EnvironmentObject var dragDropStatus: DragDropStatus
    @State private var isDragging = false
    @State private var isHovering = false
    @State private var dragOffset: CGSize = .zero
    @State private var opacity: Double = 1.0
    var gate: QuantumGateType
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { info in
                self.dragDropStatus.isDragging(type: self.gate)
                self.isDragging = true
                self.dragOffset = info.translation
        }
        .onEnded { _ in
            self.dragDropStatus.dragFinished()
            self.opacity = 0.0
            self.dragOffset = .zero
            withAnimation {
                self.isDragging = false
                self.opacity = 1.0
            }
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white)
                .shadow(radius: self.isHovering ? 8.0 : 0.0)
            Image(nsImage: ImageProvider.gateIcon(for: self.gate))
                .resizable()
        }
        .frame(width: 60.0, height: 60.0)
        .scaleEffect(self.isHovering ? 1.05 : 1.0)
        .opacity(self.opacity)
        .onHover { isHovering in
                withAnimation { self.isHovering = isHovering }
        }
        .zIndex(self.isDragging ? 1.0 : 0.0)
        .offset(self.dragOffset)
        .gesture(drag)
    }
}
