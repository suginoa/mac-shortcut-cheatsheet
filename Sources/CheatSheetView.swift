import SwiftUI

// 表示カテゴリの順序（アプリごとに重要な順）
private let categoryOrder = [
    "ファイル操作", "ファイル", "編集", "表示", "移動", "タブ",
    "ナビゲーション", "ブックマーク", "ウィンドウ", "ビルド", "テスト",
    "デバッグ", "開発", "プロセス", "カーソル", "履歴", "ペイン", "システム"
]

struct CheatSheetView: View {
    @ObservedObject var appState: AppState
    @State private var searchText = ""
    @State private var showFavoritesOnly = false

    private var filteredShortcuts: [Shortcut] {
        appState.shortcuts.filter { shortcut in
            let matchesSearch = searchText.isEmpty
                || shortcut.description.localizedCaseInsensitiveContains(searchText)
                || shortcut.keys.localizedCaseInsensitiveContains(searchText)
            let matchesFavorites = !showFavoritesOnly || appState.isFavorite(shortcut.id)
            return matchesSearch && matchesFavorites
        }
    }

    private var groupedShortcuts: [(String, [Shortcut])] {
        let groups = Dictionary(grouping: filteredShortcuts) { $0.category }
        return groups.sorted { a, b in
            let idxA = categoryOrder.firstIndex(of: a.key) ?? Int.max
            let idxB = categoryOrder.firstIndex(of: b.key) ?? Int.max
            return idxA != idxB ? idxA < idxB : a.key < b.key
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
            Divider()
            searchBarView
            Divider()
            contentView
        }
        .frame(width: 380, height: 480)
    }

    private var headerView: some View {
        HStack(spacing: 8) {
            if let icon = appState.currentAppIcon {
                Image(nsImage: icon)
                    .resizable()
                    .frame(width: 22, height: 22)
            }
            Text(appState.currentAppName)
                .font(.headline)
                .lineLimit(1)
            Spacer()
            Button(action: { showFavoritesOnly.toggle() }) {
                Image(systemName: showFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(showFavoritesOnly ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
            .help(showFavoritesOnly ? "全て表示" : "お気に入りのみ表示")

            Button("終了") { NSApp.terminate(nil) }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(NSColor.windowBackgroundColor))
    }

    private var searchBarView: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.caption)
            TextField("検索...", text: $searchText)
                .textFieldStyle(.plain)
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.controlBackgroundColor))
    }

    @ViewBuilder
    private var contentView: some View {
        if filteredShortcuts.isEmpty {
            Spacer()
            Text(showFavoritesOnly ? "お気に入りはありません" : "見つかりません")
                .foregroundColor(.secondary)
                .font(.body)
            Spacer()
        } else {
            List {
                ForEach(groupedShortcuts, id: \.0) { category, shortcuts in
                    Section(header:
                        Text(category)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .textCase(nil)
                    ) {
                        ForEach(shortcuts) { shortcut in
                            ShortcutRow(
                                shortcut: shortcut,
                                isFavorite: appState.isFavorite(shortcut.id),
                                onToggleFavorite: { appState.toggleFavorite(shortcut.id) }
                            )
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }
    }
}

struct ShortcutRow: View {
    let shortcut: Shortcut
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            KeyBadge(keys: shortcut.keys)
            Text(shortcut.description)
                .font(.body)
                .lineLimit(1)
            Spacer()
            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : Color.secondary.opacity(0.4))
                    .font(.caption)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 1)
    }
}

struct KeyBadge: View {
    let keys: String

    var body: some View {
        Text(keys)
            .font(.system(.caption, design: .monospaced))
            .fontWeight(.semibold)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.gray.opacity(0.12))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(minWidth: 60, alignment: .center)
    }
}
