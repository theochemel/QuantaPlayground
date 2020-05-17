import Foundation
import Combine

public final class Game: ObservableObject, Decodable {
    public let objectWillChange = ObservableObjectPublisher()
    public var levels: [Level]
    public var selectedLevelIndex: Int = 0 { willSet {
        self.objectWillChange.send()
        } didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.displayLevelSelector = false
            }
            self.subscribeToSelectedLevel()
    }}
    public var isFinished = false { willSet {
        self.objectWillChange.send()
        } didSet {
            self.updateLevelInteractionStatus()
        }}
    public var displayLevelIntro = true { willSet {
        self.objectWillChange.send()
        } didSet {
            self.updateLevelInteractionStatus()
        }}
    public var displayTutorial = true { willSet {
        self.objectWillChange.send()
        } didSet {
            self.updateLevelInteractionStatus()
        }}
    public var displayLevelSelector = false { willSet {
        self.objectWillChange.send()
        } didSet {
            self.updateLevelInteractionStatus()
        }}
    
    public var dragDropStatus: DragDropStatus
    
    private var dragDropStatusSubscription: AnyCancellable? = nil
    
    public var levelInteractionStatus: LevelInteractionStatus
    
    private var anyCancellable: AnyCancellable? = nil
    
    private var introTimerTask: DispatchWorkItem?
    
    public init(levels: [Level]) {
        self.levels = levels
        
        self.dragDropStatus = DragDropStatus()
        self.levelInteractionStatus = LevelInteractionStatus()
        
        self.dragDropStatusSubscription = self.dragDropStatus.requiresExecution
            .subscribe(on: DispatchQueue.main)
            .sink { (_) in
                self.executeDragDrop()
        }
        
        self.subscribeToSelectedLevel()
    }
    
    public func updateLevelInteractionStatus() {
        self.levelInteractionStatus.isInteractionEnabled = !(self.displayLevelSelector || self.displayTutorial || self.displayTutorial || self.isFinished)
    }
    
    public func endTutorial() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.displayTutorial = false
        }
        
        self.resetIntroTimer()
    }
    
    private func resetIntroTimer() {
        self.displayLevelIntro = true
        self.introTimerTask?.cancel()
        let introTimerTask = DispatchWorkItem {
            self.displayLevelIntro = false
        }
        self.introTimerTask = introTimerTask
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: introTimerTask)
    }
    
    private func subscribeToSelectedLevel() {
        self.objectWillChange.send()
        self.resetIntroTimer()
        self.levels[selectedLevelIndex].reset()
        self.dragDropStatus.reset()
        self.anyCancellable?.cancel()
        
        self.anyCancellable = self.levels[selectedLevelIndex].isCompleted
            .sink { (_) in
                guard self.selectedLevelIndex + 1 < self.levels.count else {
                    self.isFinished = true
                    return
                }
                self.selectedLevelIndex += 1
                self.subscribeToSelectedLevel()
        }
    }
    
    private func executeDragDrop() {
        self.levels[self.selectedLevelIndex].circuit.executeDragDrop(sourceGateType: self.dragDropStatus.sourceGateType, sourceGatePath: self.dragDropStatus.sourceGatePath, destinationGatePath: self.dragDropStatus.destinationGatePath)
        self.dragDropStatus.reset()
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
        
        self.dragDropStatus = DragDropStatus()
        self.levelInteractionStatus = LevelInteractionStatus()
        
        self.dragDropStatusSubscription = self.dragDropStatus.requiresExecution
            .subscribe(on: DispatchQueue.main)
            .sink { (_) in
                self.executeDragDrop()
        }
        
        self.subscribeToSelectedLevel()
    }
}
