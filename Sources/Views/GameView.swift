import SwiftUI

public struct GameView: View {
    @ObservedObject public var game: Game
    @State private var selectedLevelIndex: Int = 0
    
    public init(game: Game) {
        self.game = game
    }
    
    public var body: some View {
        LevelView(level: $game.levels[game.selectedLevelIndex])
            .environmentObject(self.game.levels[game.selectedLevelIndex].circuit.dragDropStatus)
    }
}
