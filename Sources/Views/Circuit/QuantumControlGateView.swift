import SwiftUI

enum ControlViewType {
    case center
    case bottom
    case top
    case connector
    case controlledGate(Bool, Bool)
    case none
}

struct QuantumControlView: View {
    let controlViewType: ControlViewType
    
    func view(for controlViewType: ControlViewType) -> AnyView {
        switch controlViewType {
            case .center: return AnyView(QuantumCenterControlView())
            case .bottom: return AnyView(QuantumBottomControlView())
            case .top: return AnyView(QuantumTopControlView())
            case .connector: return AnyView(QuantumConnectorControlView())
            case .controlledGate(let topConnector, let bottomConnector): return AnyView(QuantumControlledGateControlView(topConnector: topConnector, bottomConnector: bottomConnector))
            default: return AnyView(QuantumPlaceholderGateView())
        }
    }
    
    var body: some View {
        view(for: self.controlViewType)
    }
}

struct QuantumCenterControlView: View {
    public var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 96.0, height: 96.0)
                .foregroundColor(.clear)
            Circle()
                .stroke(lineWidth: 4.0)
                .foregroundColor(.white)
                .frame(width: 40.0, height: 40.0)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 4.0, height: 96.0)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 40.0, height: 4.0)
        }
    }
}

struct QuantumBottomControlView: View {
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 96.0, height: 96.0)
            Circle()
                .stroke(lineWidth: 4.0)
                .foregroundColor(.white)
                .frame(width: 40.0, height: 40.0)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 4.0, height: 68.0)
                .offset(x: 0.0, y: -14.0)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 40.0, height: 4.0)
        }
    }
}

struct QuantumTopControlView: View {
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 96.0, height: 96.0)
            Circle()
                .stroke(lineWidth: 4.0)
                .foregroundColor(.white)
                .frame(width: 40.0, height: 40.0)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 4.0, height: 68.0)
                .offset(x: 0.0, y: 14.0)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 40.0, height: 4.0)
        }
    }
}

struct QuantumConnectorControlView: View {
    public var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 96.0, height: 96.0)
                .foregroundColor(.clear)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 4.0, height: 96.0)
        }
    }
}

struct QuantumControlledGateControlView: View {
    let topConnector: Bool
    let bottomConnector: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 96.0, height: 96.0)
                .foregroundColor(.clear)
            Rectangle()
                .foregroundColor(topConnector ? .white : .clear)
                .frame(width: 4.0, height: 48.0)
                .offset(x: 0.0, y: -48.0)
            Rectangle()
                .foregroundColor(bottomConnector ? .white : .clear)
                .frame(width: 4.0, height: 48.0)
                .offset(x: 0.0, y: 48.0)
        }
    }
}
