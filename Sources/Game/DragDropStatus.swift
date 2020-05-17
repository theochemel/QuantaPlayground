import Foundation
import Combine

public final class DragDropStatus: ObservableObject {
    public let objectWillChange = ObservableObjectPublisher()
    public let requiresExecution = PassthroughSubject<Void, Never>()
    
    public var sourceGatePath: (Int, Int)? { willSet (newValue) {
        self.objectWillChange.send()
    }}
    public var sourceGateType: QuantumGateType? { willSet (newValue) {
        self.objectWillChange.send()
    }}
    public var destinationGatePath: (Int, Int)? { willSet (newValue) {
        self.objectWillChange.send()
    }}
    public var isDragging = false { willSet (newValue) {
        self.objectWillChange.send()
    }}
    
    public init() {
    }
    
    public func dragFinished() {
        self.requiresExecution.send()
    }
    
    public func isDragging(type: QuantumGateType) {
        if !self.isDragging {
            self.isDragging = true
            self.sourceGateType = type
        }
    }
    
    public func isDragging(path: (Int, Int), type: QuantumGateType) {
        if !self.isDragging {
            self.isDragging = true
            self.sourceGatePath = path
            self.sourceGateType = type
        }
    }
    
    public func isHovering(path: (Int, Int)) {
        self.destinationGatePath = path
    }
    
    public func hoverEnded() {
        self.destinationGatePath = nil
    }
    
    public func reset() {
        self.sourceGatePath = nil
        self.sourceGateType = nil
        self.destinationGatePath = nil
        self.isDragging = false
    }
}
