import Combine

public final class LevelInteractionStatus: ObservableObject {
    public var isInteractionEnabled = true { willSet {
        self.objectWillChange.send()
    }}
}
