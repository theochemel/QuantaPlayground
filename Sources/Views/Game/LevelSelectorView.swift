import SwiftUI

public struct LevelSelectorView: View {
    public let levelCount: Int
    @Binding public var selectedLevelIndex: Int
    @Binding public var displayLevelSelector: Bool
    
    private var numRows: Int {
        return self.levelCount / 3
    }
    
    private func numInRow(_ row: Int) -> Int {
        if self.levelCount - (3 * row) > 3 {
            return 3
        } else {
            return self.levelCount - (3 * row)
        }
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.backgroundColor)
            VStack {
                VStack(spacing: 24.0) {
                    ForEach(0...self.numRows, id: \.self) { rowIndex in
                        HStack(spacing: 24.0) {
                            ForEach(0..<self.numInRow(rowIndex), id: \.self) { columnIndex in
                                LevelNumberView(levelNumber: rowIndex * 3 + columnIndex + 1)
                                    .onTapGesture {
                                        self.selectedLevelIndex = rowIndex * 3 + columnIndex
                                }
                            }
                            ForEach(0..<(3-self.numInRow(rowIndex)), id: \.self) { _ in
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 48.0, height: 48.0)
                            }
                        }
                    }
                }
                .padding(40.0)
                .background (
                    RoundedRectangle(cornerRadius: 24.0)
                        .foregroundColor(.offsetBackground)
                )
                AnimatedButton(action: {
                    self.displayLevelSelector = false
                    }, title: "Done")
                    .padding(24.0)
            }
        }
    }
}


