import AppKit
import PlaygroundSupport
import SwiftUI

let gameDataPath = Bundle.main.url(forResource: "game", withExtension: "json")!
print(gameDataPath)
let gameData = try Data(contentsOf: gameDataPath)
let decoder = JSONDecoder()
let game = try decoder.decode(Game.self, from: gameData)

struct RootView: View {
    var body: some View {
        GameView(game: game)
            .frame(width: 720.0, height: 1024.0)
    }
}

PlaygroundPage.current.setLiveView(RootView())
