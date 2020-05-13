import Foundation
import SwiftUI
import AppKit

public struct QuantumGateStoreView: View {
    @Binding var store: QuantumGateCatalog
        
    private func width(for category: QuantumGateCategory) -> CGFloat {
        guard let gateCount = self.store.gates[category]?.count, gateCount > 0 else { return 0.0 }
        
        let width: CGFloat = 66.0 + CGFloat(gateCount) * 60.0 + CGFloat(gateCount - 1) * 12.0
        return width
    }
    
    private func grid(availableWidth: CGFloat) -> [[QuantumGateType]] {
        
        var grid: [[QuantumGateCategory]] = [[]]
        var rowIndex = 0
        var rowWidth: CGFloat = 0.0
        
        for category in self.store.categories {
            if rowWidth + width(for: category) - 18.0 < availableWidth {
                grid[rowIndex].append(category)
                rowWidth += width(for: category)
            } else {
                rowWidth = 0.0
                rowIndex += 1
                grid.append([category])
            }
        }
        return grid
    }
    
    private func gridView(availableWidth: CGFloat) -> some View {
        let grid = self.grid(availableWidth: availableWidth)
        
        return VStack(alignment: .center, spacing: 18.0) {
            ForEach(0..<grid.count, id: \.self) { rowIndex in
                HStack(alignment: .center, spacing: 18.0) {
                    ForEach(0..<grid[rowIndex].count, id: \.self) { columnIndex in
                        QuantumGateStoreCategoryView(store: self.$store, category: grid[rowIndex][columnIndex])
                    }
                }
            }
        }
    }
    
    public var body: some View {
        self.gridView(availableWidth: 640.0)
    }
}


