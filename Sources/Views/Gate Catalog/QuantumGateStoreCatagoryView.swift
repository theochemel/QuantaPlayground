import SwiftUI

public struct QuantumGateStoreCategoryView: View {
    @Binding var store: QuantumGateCatalog
    let category: QuantumGateCategory
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: 12.0) {
                ForEach(self.store.gates[self.category] ?? [], id: \.self) { gate in
                    CatalogQuantumGateView(gate: gate)
                }
            }
            .padding(24.0)
                .background(
                    RoundedRectangle(cornerRadius: 16.0)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.gray)
                )
            Text(category)
                .padding([.leading, .trailing], 8.0)
                .foregroundColor(.gray)
                .font(Font.system(Font.TextStyle.caption).italic())
                .background(Color.backgroundColor)
                .alignmentGuide(.leading, computeValue: { (d) -> CGFloat in
                    return -(54 - d.width / 2.0)
                })
                .alignmentGuide(.top) { (d) -> CGFloat in
                    return (d.height / 2.0)
            }
        }
    }
}
