@testable import CodexStatusCore
import XCTest

final class CodexStatusMonitorTests: XCTestCase {
    private let now = ISO8601DateFormatter().date(from: "2026-04-29T03:10:00Z")!

    func testThinkingWhenTaskStartedWithoutCompletion() throws {
        let root = try makeCodexHome()
        try writeSession(
            root: root,
            name: "active.jsonl",
            lines: [
                event("2026-04-29T03:08:00.000Z", "task_started"),
                event("2026-04-29T03:08:10.000Z", "token_count")
            ],
            modifiedAt: now
        )

        let snapshot = CodexStatusMonitor(codexHome: root, staleAfter: 30 * 60).snapshot(at: now)

        XCTAssertEqual(snapshot.state, .thinking)
        XCTAssertEqual(snapshot.activeSessionCount, 1)
        XCTAssertEqual(snapshot.latestEventType, "token_count")
    }

    func testIdleWhenTaskCompleted() throws {
        let root = try makeCodexHome()
        try writeSession(
            root: root,
            name: "complete.jsonl",
            lines: [
                event("2026-04-29T03:08:00.000Z", "task_started"),
                event("2026-04-29T03:08:20.000Z", "task_complete")
            ],
            modifiedAt: now
        )

        let snapshot = CodexStatusMonitor(codexHome: root, staleAfter: 30 * 60).snapshot(at: now)

        XCTAssertEqual(snapshot.state, .idle)
        XCTAssertEqual(snapshot.activeSessionCount, 0)
        XCTAssertEqual(snapshot.latestEventType, "task_complete")
    }

    func testStaleOpenTaskIsTreatedAsIdle() throws {
        let root = try makeCodexHome()
        let oldDate = ISO8601DateFormatter().date(from: "2026-04-29T02:00:00Z")!
        try writeSession(
            root: root,
            name: "stale.jsonl",
            lines: [
                event("2026-04-29T02:00:00.000Z", "task_started")
            ],
            modifiedAt: oldDate
        )

        let snapshot = CodexStatusMonitor(codexHome: root, staleAfter: 10 * 60).snapshot(at: now)

        XCTAssertEqual(snapshot.state, .idle)
        XCTAssertEqual(snapshot.activeSessionCount, 0)
    }

    func testReportsActiveAndIdleSessionTitlesFromIndex() throws {
        let root = try makeCodexHome()
        let activeID = "00000000-0000-0000-0000-000000000001"
        let idleID = "00000000-0000-0000-0000-000000000002"
        try writeSessionIndex(
            root: root,
            entries: [
                (activeID, "活跃会话标题"),
                (idleID, "闲置会话标题")
            ]
        )
        try writeSession(
            root: root,
            name: "rollout-2026-04-29T11-08-00-\(activeID).jsonl",
            lines: [
                event("2026-04-29T03:08:00.000Z", "task_started")
            ],
            modifiedAt: now
        )
        try writeSession(
            root: root,
            name: "rollout-2026-04-29T11-07-00-\(idleID).jsonl",
            lines: [
                event("2026-04-29T03:07:00.000Z", "task_started"),
                event("2026-04-29T03:07:10.000Z", "task_complete")
            ],
            modifiedAt: now
        )

        let snapshot = CodexStatusMonitor(codexHome: root, staleAfter: 30 * 60).snapshot(at: now)

        XCTAssertEqual(snapshot.latestSessionTitle, "活跃会话标题")
        XCTAssertEqual(snapshot.activeSessionTitles, ["活跃会话标题"])
        XCTAssertEqual(snapshot.idleSessionTitles, ["闲置会话标题"])
    }

    private func makeCodexHome() throws -> URL {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let sessions = root
            .appendingPathComponent("sessions", isDirectory: true)
            .appendingPathComponent("2026", isDirectory: true)
            .appendingPathComponent("04", isDirectory: true)
            .appendingPathComponent("29", isDirectory: true)
        try FileManager.default.createDirectory(at: sessions, withIntermediateDirectories: true)
        addTeardownBlock {
            try? FileManager.default.removeItem(at: root)
        }
        return root
    }

    private func writeSession(root: URL, name: String, lines: [String], modifiedAt: Date) throws {
        let fileURL = root
            .appendingPathComponent("sessions", isDirectory: true)
            .appendingPathComponent("2026", isDirectory: true)
            .appendingPathComponent("04", isDirectory: true)
            .appendingPathComponent("29", isDirectory: true)
            .appendingPathComponent(name)
        try lines.joined(separator: "\n").appending("\n").write(to: fileURL, atomically: true, encoding: .utf8)
        try FileManager.default.setAttributes([.modificationDate: modifiedAt], ofItemAtPath: fileURL.path)
    }

    private func writeSessionIndex(root: URL, entries: [(String, String)]) throws {
        let lines = entries.map { id, title in
            #"{"id":"\#(id)","thread_name":"\#(title)","updated_at":"2026-04-29T03:08:00.000Z"}"#
        }
        try lines.joined(separator: "\n").appending("\n").write(
            to: root.appendingPathComponent("session_index.jsonl"),
            atomically: true,
            encoding: .utf8
        )
    }

    private func event(_ timestamp: String, _ type: String) -> String {
        #"{"timestamp":"\#(timestamp)","type":"event_msg","payload":{"type":"\#(type)"}}"#
    }
}
