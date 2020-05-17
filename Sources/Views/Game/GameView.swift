import SwiftUI

public struct GameView: View {
    @ObservedObject public var game: Game
    
    public init(game: Game) {
        self.game = game
    }
    
    public var body: some View {
        ZStack {
            LevelView(level: $game.levels[game.selectedLevelIndex], displayLevelSelector: $game.displayLevelSelector)
                .environmentObject(self.game.dragDropStatus)
                .environmentObject(self.game.levelInteractionStatus)
            LevelIntroView(levelNumber: game.levels[game.selectedLevelIndex].levelNumber,
                           title: game.levels[game.selectedLevelIndex].title,
                           subtitle: game.levels[game.selectedLevelIndex].subtitle)
                .opacity(self.game.displayLevelIntro ? 1.0 : 0.0)
                .animation(.default)
            LevelSelectorView(levelCount: game.levels.count, selectedLevelIndex: $game.selectedLevelIndex, displayLevelSelector: $game.displayLevelSelector)
                .opacity(self.game.displayLevelSelector ? 1.0 : 0.0)
                .animation(.default)
            TutorialView(endTutorial: self.game.endTutorial)
                .opacity(self.game.displayTutorial ? 1.0 : 0.0)
                .animation(.default)
            FinishView()
                .opacity(self.game.isFinished ? 1.0 : 0.0)
                .animation(.default)
        }
    }
}
