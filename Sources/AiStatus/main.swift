import AppKit
import CodexStatusCore
import Foundation
import IOKit.pwr_mgt

@main
final class AiStatusApp: NSObject, NSApplicationDelegate {
    private let gptMonitor = CodexStatusMonitor()
    private let claudeMonitor = ClaudeStatusMonitor()
    private let colorPreferences = StatusLightColorPreferences()
    private let sleepPreventionPreferences = SleepPreventionPreferences()
    private let sleepPreventer = SleepPreventer()
    private let statusItem = NSStatusBar.system.statusItem(withLength: 24)
    private let menu = NSMenu()
    private let stateMenuItem = NSMenuItem(title: "状态：检测中", action: nil, keyEquivalent: "")
    private let gptStateMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    private let gptDetailMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    private let claudeStateMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    private let claudeDetailMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    private let errorMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    private let gptActiveSessionsMenuItem = NSMenuItem(title: "GPT 活跃会话", action: nil, keyEquivalent: "")
    private let gptIdleSessionsMenuItem = NSMenuItem(title: "GPT 闲置会话", action: nil, keyEquivalent: "")
    private let claudeActiveSessionsMenuItem = NSMenuItem(title: "Claude 活跃会话", action: nil, keyEquivalent: "")
    private let claudeIdleSessionsMenuItem = NSMenuItem(title: "Claude 闲置会话", action: nil, keyEquivalent: "")
    private let gptActiveSessionsMenu = NSMenu(title: "GPT 活跃会话")
    private let gptIdleSessionsMenu = NSMenu(title: "GPT 闲置会话")
    private let claudeActiveSessionsMenu = NSMenu(title: "Claude 活跃会话")
    private let claudeIdleSessionsMenu = NSMenu(title: "Claude 闲置会话")
    private let runningColorMenu = NSMenu(title: "运行时灯颜色")
    private let idleColorMenu = NSMenu(title: "空闲时灯颜色")
    private let preventSleepMenuItem = NSMenuItem(title: "保持 Mac 活跃（防休眠）", action: #selector(toggleSleepPrevention(_:)), keyEquivalent: "")

    private var timer: Timer?
    private var powerAssertionErrorMessage: String?

    static func main() {
        let app = NSApplication.shared
        let delegate = AiStatusApp()
        app.delegate = delegate
        app.setActivationPolicy(.accessory)
        app.run()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        configureStatusItem()
        configureMenu()
        applySleepPreventionPreference()
        refresh()

        let timer = Timer(timeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.refresh()
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    func applicationWillTerminate(_ notification: Notification) {
        timer?.invalidate()
        sleepPreventer.disable()
    }

    private func configureStatusItem() {
        guard let button = statusItem.button else {
            return
        }

        button.imagePosition = .imageOnly
        button.imageScaling = .scaleProportionallyDown
        button.toolTip = "AiStatus"
        statusItem.menu = menu
    }

    private func configureMenu() {
        [stateMenuItem, gptStateMenuItem, gptDetailMenuItem, claudeStateMenuItem, claudeDetailMenuItem, errorMenuItem].forEach {
            $0.isEnabled = false
        }
        gptActiveSessionsMenuItem.submenu = gptActiveSessionsMenu
        gptIdleSessionsMenuItem.submenu = gptIdleSessionsMenu
        claudeActiveSessionsMenuItem.submenu = claudeActiveSessionsMenu
        claudeIdleSessionsMenuItem.submenu = claudeIdleSessionsMenu

        menu.addItem(stateMenuItem)
        menu.addItem(.separator())
        menu.addItem(gptStateMenuItem)
        menu.addItem(gptDetailMenuItem)
        menu.addItem(gptActiveSessionsMenuItem)
        menu.addItem(gptIdleSessionsMenuItem)
        menu.addItem(claudeStateMenuItem)
        menu.addItem(claudeDetailMenuItem)
        menu.addItem(claudeActiveSessionsMenuItem)
        menu.addItem(claudeIdleSessionsMenuItem)
        menu.addItem(errorMenuItem)
        menu.addItem(.separator())
        preventSleepMenuItem.target = self
        menu.addItem(preventSleepMenuItem)
        menu.addItem(.separator())
        addColorMenus()
        menu.addItem(.separator())

        let refreshItem = NSMenuItem(title: "立即刷新", action: #selector(refreshNow(_:)), keyEquivalent: "r")
        refreshItem.target = self
        menu.addItem(refreshItem)

        let openCodexItem = NSMenuItem(title: "打开 ~/.codex", action: #selector(openCodexFolder(_:)), keyEquivalent: "")
        openCodexItem.target = self
        menu.addItem(openCodexItem)

        let openClaudeItem = NSMenuItem(title: "打开 ~/.claude", action: #selector(openClaudeFolder(_:)), keyEquivalent: "")
        openClaudeItem.target = self
        menu.addItem(openClaudeItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "退出 AiStatus", action: #selector(quit(_:)), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
    }

    private func addColorMenus() {
        let runningItem = NSMenuItem(title: "运行时灯颜色", action: nil, keyEquivalent: "")
        runningItem.submenu = runningColorMenu
        menu.addItem(runningItem)

        let idleItem = NSMenuItem(title: "空闲时灯颜色", action: nil, keyEquivalent: "")
        idleItem.submenu = idleColorMenu
        menu.addItem(idleItem)

        for color in StatusLightColor.available {
            let runningColorItem = NSMenuItem(title: color.title, action: #selector(selectRunningColor(_:)), keyEquivalent: "")
            runningColorItem.target = self
            runningColorItem.representedObject = color.id
            runningColorMenu.addItem(runningColorItem)

            let idleColorItem = NSMenuItem(title: color.title, action: #selector(selectIdleColor(_:)), keyEquivalent: "")
            idleColorItem.target = self
            idleColorItem.representedObject = color.id
            idleColorMenu.addItem(idleColorItem)
        }

        updateColorMenuChecks()
    }

    @objc private func refreshNow(_ sender: Any?) {
        refresh()
    }

    @objc private func selectRunningColor(_ sender: NSMenuItem) {
        guard let colorID = sender.representedObject as? String else {
            return
        }
        colorPreferences.runningColorID = colorID
        updateColorMenuChecks()
        refresh()
    }

    @objc private func selectIdleColor(_ sender: NSMenuItem) {
        guard let colorID = sender.representedObject as? String else {
            return
        }
        colorPreferences.idleColorID = colorID
        updateColorMenuChecks()
        refresh()
    }

    @objc private func toggleSleepPrevention(_ sender: NSMenuItem) {
        sleepPreventionPreferences.isEnabled.toggle()
        applySleepPreventionPreference()
        refresh()
    }

    @objc private func openCodexFolder(_ sender: Any?) {
        NSWorkspace.shared.open(gptMonitor.codexHome)
    }

    @objc private func openClaudeFolder(_ sender: Any?) {
        NSWorkspace.shared.open(claudeMonitor.claudeHome)
    }

    @objc private func quit(_ sender: Any?) {
        NSApp.terminate(nil)
    }

    private func refresh() {
        let gptSnapshot = gptMonitor.snapshot()
        let claudeSnapshot = claudeMonitor.snapshot()
        let activeNames = [
            gptSnapshot.isThinking ? "GPT" : nil,
            claudeSnapshot.isThinking ? "Claude" : nil
        ].compactMap { $0 }
        let isActive = !activeNames.isEmpty
        let color = isActive ? colorPreferences.runningColor : colorPreferences.idleColor
        let stateText = isActive
            ? "\(colorPreferences.runningColorTitle)灯，\(activeNames.joined(separator: " + ")) 正在使用"
            : "\(colorPreferences.idleColorTitle)灯，GPT / Claude 空闲"

        if let button = statusItem.button {
            button.image = StatusDotImage.make(color: color, gptActive: gptSnapshot.isThinking, claudeActive: claudeSnapshot.isThinking)
            button.toolTip = "AiStatus：\(stateText)"
            button.setAccessibilityLabel("AiStatus \(stateText)")
        }

        stateMenuItem.title = "状态：\(stateText)"
        gptStateMenuItem.title = providerStateTitle(name: "GPT", isThinking: gptSnapshot.isThinking, activeCount: gptSnapshot.activeSessionCount)
        gptDetailMenuItem.title = providerDetailTitle(
            latestSessionTitle: gptSnapshot.latestSessionTitle
        )
        populateSessionMenu(gptActiveSessionsMenu, titles: gptSnapshot.activeSessionTitles)
        populateSessionMenu(gptIdleSessionsMenu, titles: gptSnapshot.idleSessionTitles)

        claudeStateMenuItem.title = providerStateTitle(name: "Claude", isThinking: claudeSnapshot.isThinking, activeCount: claudeSnapshot.activeSessionCount)
        claudeDetailMenuItem.title = providerDetailTitle(
            latestSessionTitle: claudeSnapshot.latestSessionTitle
        )
        populateSessionMenu(claudeActiveSessionsMenu, titles: claudeSnapshot.activeSessionTitles)
        populateSessionMenu(claudeIdleSessionsMenu, titles: claudeSnapshot.idleSessionTitles)

        let errors = [gptSnapshot.errorMessage, claudeSnapshot.errorMessage, powerAssertionErrorMessage].compactMap { $0 }
        if !errors.isEmpty {
            errorMenuItem.title = "提示：\(errors.joined(separator: "；"))"
            errorMenuItem.isHidden = false
        } else {
            errorMenuItem.isHidden = true
        }
    }

    private func applySleepPreventionPreference() {
        if sleepPreventionPreferences.isEnabled {
            powerAssertionErrorMessage = sleepPreventer.enable()
            if powerAssertionErrorMessage != nil {
                sleepPreventionPreferences.isEnabled = false
                sleepPreventer.disable()
            }
        } else {
            powerAssertionErrorMessage = nil
            sleepPreventer.disable()
        }

        updateSleepPreventionMenuCheck()
    }

    private func updateColorMenuChecks() {
        for item in runningColorMenu.items {
            item.state = (item.representedObject as? String) == colorPreferences.runningColorID ? .on : .off
        }
        for item in idleColorMenu.items {
            item.state = (item.representedObject as? String) == colorPreferences.idleColorID ? .on : .off
        }
    }

    private func updateSleepPreventionMenuCheck() {
        preventSleepMenuItem.state = sleepPreventer.isEnabled ? .on : .off
    }

    private func providerStateTitle(name: String, isThinking: Bool, activeCount: Int) -> String {
        let stateText = isThinking ? "运行中" : "空闲"
        return "\(name)：\(stateText) · 活跃会话 \(activeCount)"
    }

    private func providerDetailTitle(
        latestSessionTitle: String?
    ) -> String {
        "最近事件：\(latestSessionTitle ?? "无")"
    }

    private func populateSessionMenu(_ menu: NSMenu, titles: [String]) {
        menu.removeAllItems()

        guard !titles.isEmpty else {
            let emptyItem = NSMenuItem(title: "无", action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            menu.addItem(emptyItem)
            return
        }

        for title in titles {
            let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
            item.isEnabled = false
            menu.addItem(item)
        }
    }
}

private final class StatusLightColorPreferences {
    private enum Key {
        static let runningColorID = "runningColorID"
        static let idleColorID = "idleColorID"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var runningColorID: String {
        get { colorID(forKey: Key.runningColorID, defaultID: "blue") }
        set { defaults.set(newValue, forKey: Key.runningColorID) }
    }

    var idleColorID: String {
        get { colorID(forKey: Key.idleColorID, defaultID: "green") }
        set { defaults.set(newValue, forKey: Key.idleColorID) }
    }

    var runningColor: NSColor {
        StatusLightColor.color(for: runningColorID).color
    }

    var idleColor: NSColor {
        StatusLightColor.color(for: idleColorID).color
    }

    var runningColorTitle: String {
        StatusLightColor.color(for: runningColorID).title
    }

    var idleColorTitle: String {
        StatusLightColor.color(for: idleColorID).title
    }

    private func colorID(forKey key: String, defaultID: String) -> String {
        guard let storedID = defaults.string(forKey: key),
              StatusLightColor.available.contains(where: { $0.id == storedID })
        else {
            return defaultID
        }
        return storedID
    }
}

private final class SleepPreventionPreferences {
    private enum Key {
        static let isEnabled = "preventSystemSleep"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isEnabled: Bool {
        get { defaults.bool(forKey: Key.isEnabled) }
        set { defaults.set(newValue, forKey: Key.isEnabled) }
    }
}

private final class SleepPreventer {
    private var assertionID = IOPMAssertionID(kIOPMNullAssertionID)

    private(set) var isEnabled = false

    func enable() -> String? {
        guard assertionID == kIOPMNullAssertionID else {
            isEnabled = true
            return nil
        }

        var newAssertionID = IOPMAssertionID(kIOPMNullAssertionID)
        let result = IOPMAssertionCreateWithName(
            kIOPMAssertionTypePreventUserIdleSystemSleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            "AiStatus 保持 Mac 活跃" as CFString,
            &newAssertionID
        )

        guard result == kIOReturnSuccess else {
            isEnabled = false
            return "无法开启防休眠（IOKit \(result)）"
        }

        assertionID = newAssertionID
        isEnabled = true
        return nil
    }

    func disable() {
        guard assertionID != kIOPMNullAssertionID else {
            isEnabled = false
            return
        }

        IOPMAssertionRelease(assertionID)
        assertionID = IOPMAssertionID(kIOPMNullAssertionID)
        isEnabled = false
    }

    deinit {
        disable()
    }
}

private struct StatusLightColor {
    let id: String
    let title: String
    let color: NSColor

    static let available: [StatusLightColor] = [
        StatusLightColor(id: "blue", title: "蓝色", color: .systemBlue),
        StatusLightColor(id: "green", title: "绿色", color: .systemGreen),
        StatusLightColor(id: "teal", title: "青色", color: .systemTeal),
        StatusLightColor(id: "purple", title: "紫色", color: .systemPurple),
        StatusLightColor(id: "orange", title: "橙色", color: .systemOrange),
        StatusLightColor(id: "yellow", title: "黄色", color: .systemYellow),
        StatusLightColor(id: "red", title: "红色", color: .systemRed),
        StatusLightColor(id: "gray", title: "灰色", color: .systemGray)
    ]

    static func color(for id: String) -> StatusLightColor {
        available.first { $0.id == id } ?? available[0]
    }
}

private enum StatusDotImage {
    static func make(color: NSColor, gptActive: Bool, claudeActive: Bool) -> NSImage {
        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size)
        image.lockFocus()

        let bounds = NSRect(origin: .zero, size: size)
        NSColor.clear.setFill()
        bounds.fill()

        let glowRect = NSRect(x: 2, y: 2, width: 14, height: 14)
        color.withAlphaComponent(0.20).setFill()
        NSBezierPath(ovalIn: glowRect).fill()

        let dotRect = NSRect(x: 5, y: 5, width: 8, height: 8)
        color.setFill()
        NSBezierPath(ovalIn: dotRect).fill()

        NSColor.white.withAlphaComponent(0.55).setFill()
        NSBezierPath(ovalIn: NSRect(x: 7, y: 10, width: 3, height: 3)).fill()

        drawProviderMarkers(gptActive: gptActive, claudeActive: claudeActive)

        image.unlockFocus()
        image.isTemplate = false
        return image
    }

    private static func drawProviderMarkers(gptActive: Bool, claudeActive: Bool) {
        guard gptActive || claudeActive else {
            return
        }

        let markerColor = NSColor.white.withAlphaComponent(0.90)
        markerColor.setFill()

        if gptActive && claudeActive {
            NSBezierPath(ovalIn: NSRect(x: 4, y: 3, width: 3, height: 3)).fill()
            NSBezierPath(ovalIn: NSRect(x: 11, y: 3, width: 3, height: 3)).fill()
        } else if gptActive {
            NSBezierPath(ovalIn: NSRect(x: 5, y: 3, width: 3, height: 3)).fill()
        } else if claudeActive {
            NSBezierPath(ovalIn: NSRect(x: 10, y: 3, width: 3, height: 3)).fill()
        }
    }
}
