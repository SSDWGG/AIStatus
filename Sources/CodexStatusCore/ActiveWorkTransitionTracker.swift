import Foundation

public struct ActiveWorkTransitionTracker {
    private var previousActiveSessionCount: Int?

    public init() {}

    public mutating func update(activeSessionCount: Int) -> Bool {
        let didFinishAllWork = previousActiveSessionCount.map { previousCount in
            previousCount > 0 && activeSessionCount == 0
        } ?? false

        previousActiveSessionCount = activeSessionCount
        return didFinishAllWork
    }
}
