import SwiftUI

struct QuantumGateView: View {
    let gate: QuantumGateType
    
    @EnvironmentObject var gateCatalog: QuantumGateCatalog
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white)
            Image(nsImage: ImageProvider.gateIcon(for: self.gate))
                .resizable()
        }.frame(width: 60.0, height: 60.0)
    }
}

struct QuantumGateDropTargetView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.backgroundColor)
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(style: StrokeStyle(lineWidth: 2.0, lineCap: .round, dash: [10.0]))
                .foregroundColor(.gray)
        }
        .frame(width: 58.0, height: 58.0)
        .padding(1.0)
    }
}

struct CircuitQuantumGateView: View {
    let gate: QuantumGateType
    let gatePath: (Int, Int)
    let controlViewType: ControlViewType
    
    @EnvironmentObject var dragDropStatus: DragDropStatus
    @EnvironmentObject var gateCatalog: QuantumGateCatalog
    
    @State private var isSheetPresented = false
    @State private var isDragging = false
    @State private var isHovering = false
    @State private var dragOffset: CGSize = .zero
    private var displayEditMode: Bool { self.dragDropStatus.isDragging && !self.isDragging }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { info in
                self.dragDropStatus.isDragging(path: self.gatePath, type: self.gate)
                self.dragOffset = info.translation
        }
        .onEnded { _ in
            self.dragDropStatus.dragFinished()
            withAnimation {
                self.isDragging = false
                self.dragOffset = .zero
            }
        }
    }
    
    var body: some View {
        return ZStack {
            QuantumGateDropTargetView()
                .opacity(self.displayEditMode ? 1.0 : 0.0)
            QuantumControlView(controlViewType: self.controlViewType)
                .opacity(self.dragDropStatus.isDragging || self.isDragging ? 0.0 : 1.0)
            if ![.identity(), .qubitOnControl()].contains(self.gate) {
                QuantumGateView(gate: self.gate)
            }
            if self.gate == .qubitOnControl() {
                QuantumGateView(gate: self.gate)
                    .opacity(self.dragDropStatus.isDragging || self.isDragging ? 1.0 : 0.0)
            }
        }.frame(width: 60.0, height: 60.0)
            .scaleEffect(self.isHovering ? 1.05 : 1.0)
            .onHover { isHovering in
                withAnimation {
                    if isHovering != self.isHovering {
                        self.isHovering = isHovering
                    }
                }
                
                if isHovering {
                    self.dragDropStatus.isHovering(path: self.gatePath)
                } else {
                    self.dragDropStatus.hoverEnded()
                }
            }
            .onTapGesture(count: 2) {
                self.isSheetPresented = true
            }
            .padding(8.0)
            .zIndex(self.isDragging ? 5.0 : 0.0)
            .offset(self.dragOffset)
            .gesture(drag)
            .sheet(isPresented: self.$isSheetPresented) {
                GateInfoSheet(gate: self.gate)
                    .environmentObject(self.gateCatalog)
            }
    }
}

struct GateInfoSheet: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var gateCatalog: QuantumGateCatalog
    let gate: QuantumGateType
    
    var body: some View {
        VStack {
            Text(gate)
                .font(.system(.title))
            QuantumGateView(gate: gate)
            Button(action: { self.presentation.wrappedValue.dismiss() }) {
                Text("Done")
            }
        }.frame(width: 600.0, height: 300.0)
    }
}
