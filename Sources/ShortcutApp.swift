import SwiftUI
import os

private let logger = Logger(subsystem: "com.local.ShortcutCheatSheet", category: "App")

@main
struct ShortcutApp: App {
    @StateObject private var appState = AppState()

    init() {
        logger.info("ShortcutApp.init() called")
        try? "init_called".write(toFile: "/tmp/shortcut_app_launched.txt", atomically: true, encoding: .utf8)
    }

    var body: some Scene {
        logger.info("ShortcutApp.body accessed")
        try? "body_called".write(toFile: "/tmp/shortcut_app_body.txt", atomically: true, encoding: .utf8)
        return MenuBarExtra {
            CheatSheetView(appState: appState)
        } label: {
            Image(systemName: "keyboard")
        }
        .menuBarExtraStyle(.window)
    }
}
