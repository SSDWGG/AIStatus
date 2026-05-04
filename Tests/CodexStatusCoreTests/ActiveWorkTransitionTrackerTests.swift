@testable import CodexStatusCore
import XCTest

final class ActiveWorkTransitionTrackerTests: XCTestCase {
    func testDoesNotFireOnInitialSnapshot() {
        var tracker = ActiveWorkTransitionTracker()

        XCTAssertFalse(tracker.update(activeSessionCount: 1))
        XCTAssertFalse(tracker.update(activeSessionCount: 1))
    }

    func testFiresWhenLastActiveSessionEnds() {
        var tracker = ActiveWorkTransitionTracker()

        XCTAssertFalse(tracker.update(activeSessionCount: 2))
        XCTAssertFalse(tracker.update(activeSessionCount: 1))
        XCTAssertTrue(tracker.update(activeSessionCount: 0))
        XCTAssertFalse(tracker.update(activeSessionCount: 0))
    }

    func testDoesNotFireWhenAppStartsIdle() {
        var tracker = ActiveWorkTransitionTracker()

        XCTAssertFalse(tracker.update(activeSessionCount: 0))
        XCTAssertFalse(tracker.update(activeSessionCount: 0))
    }
}
