@testable import CodexStatusCore
import XCTest

final class ClaudeStatusMonitorTests: XCTestCase {
    private let now = ISO8601DateFormatter().date(from: "2026-04-29T03:10:00Z")!

    func testThinkingWhenUserPromptHasNoEndTurn() throws {
        let root = try makeClaudeHome()
        try writeSession(
            root: root,
            name: "active.jsonl",
            lines: [
                event("2026-04-29T03:08:00.000Z", type: "user", text: "活跃 Claude 会话"),
                assistantEvent("2026-04-29T03:08:08.000Z", stopReason: "tool_use")
            ],
            modifiedAt: now
        )

        let snapshot = ClaudeStatusMonitor(claudeHome: root, staleAfter: 30 * 60).snapshot(at: now)

        XCTAssertEqual(snapshot.state, .thinking)
        XCTAssertEqual(snapshot.activeSessionCount, 1)
        XCTAssertEqual(snapshot.latestEventType, "assistant:tool_use")
        XCTAssertEqual(snapshot.latestSessionTitle, "活跃 Claude 会话")
        XCTAssertEqual(snapshot.activeSessions.map(\.title), ["活跃 Claude 会话"])
        XCTAssertEqual(snapshot.activeSessionTitles, ["活跃 Claude 会话"])
    }

    func testIdleWhenAssistantEndsTurn() throws {
        let root = try makeClaudeHome()
        try writeSession(
            root: root,
            name: "complete.jsonl",
            lines: [
                event("2026-04-29T03:08:00.000Z", type: "user", text: "闲置 Claude 会话"),
                assistantEvent("2026-04-29T03:08:20.000Z", stopReason: "end_turn")
            ],
            modifiedAt: now
        )

        let snapshot = ClaudeStatusMonitor(claudeHome: root, staleAfter: 30 * 60).snapshot(at: now)

        XCTAssertEqual(snapshot.state, .idle)
        XCTAssertEqual(snapshot.activeSessionCount, 0)
        XCTAssertEqual(snapshot.latestEventType, "assistant:end_turn")
        XCTAssertEqual(snapshot.latestSessionTitle, "闲置 Claude 会话")
        XCTAssertEqual(snapshot.idleSessions.map(\.title), ["闲置 Claude 会话"])
        XCTAssertEqual(snapshot.idleSessionTitles, ["闲置 Claude 会话"])
    }

    func testStaleClaudeTaskIsIdle() throws {
        let root = try makeClaudeHome()
        let oldDate = ISO8601DateFormatter().date(from: "2026-04-29T02:00:00Z")!
        try writeSession(
            root: root,
            name: "stale.jsonl",
            lines: [
                event("2026-04-29T02:00:00.000Z", type: "user")
            ],
            modifiedAt: oldDate
        )

        let snapshot = ClaudeStatusMonitor(claudeHome: root, staleAfter: 10 * 60).snapshot(at: now)

        XCTAssertEqual(snapshot.state, .idle)
        XCTAssertEqual(snapshot.activeSessionCount, 0)
    }

    private func makeClaudeHome() throws -> URL {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let project = root
            .appendingPathComponent("projects", isDirectory: true)
            .appendingPathComponent("example", isDirectory: true)
        try FileManager.default.createDirectory(at: project, withIntermediateDirectories: true)
        addTeardownBlock {
            try? FileManager.default.removeItem(at: root)
        }
        return root
    }

    private func writeSession(root: URL, name: String, lines: [String], modifiedAt: Date) throws {
        let fileURL = root
            .appendingPathComponent("projects", isDirectory: true)
            .appendingPathComponent("example", isDirectory: true)
            .appendingPathComponent(name)
        try lines.joined(separator: "\n").appending("\n").write(to: fileURL, atomically: true, encoding: .utf8)
        try FileManager.default.setAttributes([.modificationDate: modifiedAt], ofItemAtPath: fileURL.path)
    }

    private func event(_ timestamp: String, type: String, text: String? = nil) -> String {
        if let text {
            return #"{"timestamp":"\#(timestamp)","type":"\#(type)","message":{"role":"\#(type)","content":[{"type":"text","text":"\#(text)"}]}}"#
        }

        return #"{"timestamp":"\#(timestamp)","type":"\#(type)","message":{"role":"\#(type)"}}"#
    }

    private func assistantEvent(_ timestamp: String, stopReason: String) -> String {
        #"{"timestamp":"\#(timestamp)","type":"assistant","message":{"role":"assistant","stop_reason":"\#(stopReason)"}}"#
    }
}
