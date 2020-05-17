import Foundation
import AppKit

public class ImageProvider {
    static func gateIcon(for gate: QuantumGateType) -> NSImage {
        return NSImage(named: gate) ?? NSImage(named: "unknown")!
    }
    
    static func qubitIcon(for index: Int) -> NSImage {
        return NSImage(named: "qubit\(index)") ?? NSImage(named: "qubitN")!
    }
    
    static func levelNumberIcon(for index: Int) -> NSImage {
        return NSImage(named: "level\(index)")!
    }
    
    static func stripeTexture() -> NSImage {
        let image = NSImage(named: "stripe")!
        image.isTemplate = true
        return image
    }
    
    static func qubitTutorialImage() -> NSImage {
        return NSImage(named: "qubits")!
    }
    
    static func gateTutorialImage() -> NSImage {
        return NSImage(named: "gates")!
    }
}
