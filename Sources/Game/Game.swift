import Foundation
import Combine

public final class Game: ObservableObject, Decodable {
    public let objectWillChange = ObservableObjectPublisher()
    public var levels: [Level]
    public var selectedLevelIndex: Int = 0
    public var selectedLevel: Level
    public var isFinished = false
    
    private var anyCancellable: AnyCancellable? = nil
    
    public init(levels: [Level]) {
        self.levels = levels
        self.selectedLevel = levels[selectedLevelIndex]
        self.subscribeToSelectedLevel()
    }
    
    private func subscribeToSelectedLevel() {
        self.anyCancellable?.cancel()
        self.anyCancellable = self.selectedLevel.isCompleted
            .sink { (_) in
                print("Level was completed according to Game")
                self.objectWillChange.send()
                self.selectedLevelIndex += 1
                self.selectedLevel = self.levels[self.selectedLevelIndex]
                self.subscribeToSelectedLevel()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case levels
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var levelsContainer = try container.nestedUnkeyedContainer(forKey: .levels)
        
        levels = []
        
        while !levelsContainer.isAtEnd {
            let level = try levelsContainer.decode(Level.self)
            levels.append(level)
        }
        
        self.selectedLevel = self.levels[self.selectedLevelIndex]
        self.subscribeToSelectedLevel()
    }
}
