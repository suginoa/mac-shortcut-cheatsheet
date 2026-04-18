import AppKit

class AppState: ObservableObject {
    @Published var currentAppName: String = "システム共通"
    @Published var currentAppIcon: NSImage? = nil
    @Published var shortcuts: [Shortcut] = ShortcutData.commonShortcuts
    @Published var favorites: Set<String> = []

    init() {
        loadFavorites()
        setupWorkspaceObserver()
    }

    private func setupWorkspaceObserver() {
        // 現在のアクティブアプリで初期化
        if let app = NSWorkspace.shared.frontmostApplication,
           app.bundleIdentifier != Bundle.main.bundleIdentifier {
            updateApp(app)
        }
        // アプリ切り替えを監視
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self,
                  let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                  app.bundleIdentifier != Bundle.main.bundleIdentifier else { return }
            self.updateApp(app)
        }
    }

    func updateApp(_ app: NSRunningApplication) {
        let bundleId = app.bundleIdentifier ?? ""
        currentAppName = app.localizedName ?? "不明"
        currentAppIcon = app.icon
        shortcuts = ShortcutData.shortcuts(for: bundleId)
    }

    func toggleFavorite(_ id: String) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        saveFavorites()
    }

    func isFavorite(_ id: String) -> Bool {
        favorites.contains(id)
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(Array(favorites)) {
            UserDefaults.standard.set(data, forKey: "shortcut_favorites")
        }
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: "shortcut_favorites"),
              let array = try? JSONDecoder().decode([String].self, from: data) else { return }
        favorites = Set(array)
    }
}
