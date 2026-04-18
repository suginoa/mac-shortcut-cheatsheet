import Foundation

struct Shortcut: Identifiable {
    let id: String
    let keys: String
    let description: String
    let category: String

    init(keys: String, description: String, category: String) {
        self.id = "\(keys)-\(description)"
        self.keys = keys
        self.description = description
        self.category = category
    }
}

struct ShortcutData {
    static func shortcuts(for bundleId: String) -> [Shortcut] {
        switch bundleId {
        case "com.apple.finder":
            return finderShortcuts + commonShortcuts
        case "com.apple.Safari":
            return safariShortcuts + commonShortcuts
        case "com.google.Chrome", "com.google.Chrome.canary":
            return chromeShortcuts + commonShortcuts
        case "com.microsoft.VSCode":
            return vscodeShortcuts + commonShortcuts
        case "com.apple.Terminal":
            return terminalShortcuts + commonShortcuts
        case "com.googlecode.iterm2":
            return itermShortcuts + commonShortcuts
        case "com.apple.dt.Xcode":
            return xcodeShortcuts + commonShortcuts
        default:
            return commonShortcuts
        }
    }

    static let commonShortcuts: [Shortcut] = [
        Shortcut(keys: "⌘C",   description: "コピー",               category: "編集"),
        Shortcut(keys: "⌘V",   description: "ペースト",             category: "編集"),
        Shortcut(keys: "⌘X",   description: "カット",               category: "編集"),
        Shortcut(keys: "⌘Z",   description: "元に戻す",             category: "編集"),
        Shortcut(keys: "⌘⇧Z",  description: "やり直す",             category: "編集"),
        Shortcut(keys: "⌘A",   description: "すべてを選択",         category: "編集"),
        Shortcut(keys: "⌘F",   description: "検索",                 category: "編集"),
        Shortcut(keys: "⌘S",   description: "保存",                 category: "ファイル"),
        Shortcut(keys: "⌘⇧S",  description: "別名で保存",           category: "ファイル"),
        Shortcut(keys: "⌘N",   description: "新規",                 category: "ファイル"),
        Shortcut(keys: "⌘O",   description: "開く",                 category: "ファイル"),
        Shortcut(keys: "⌘P",   description: "印刷",                 category: "ファイル"),
        Shortcut(keys: "⌘W",   description: "ウィンドウを閉じる",   category: "ウィンドウ"),
        Shortcut(keys: "⌘Q",   description: "終了",                 category: "ウィンドウ"),
        Shortcut(keys: "⌘H",   description: "非表示",               category: "ウィンドウ"),
        Shortcut(keys: "⌘M",   description: "最小化",               category: "ウィンドウ"),
        Shortcut(keys: "⌘,",   description: "環境設定",             category: "ウィンドウ"),
        Shortcut(keys: "⌘Tab", description: "アプリを切り替える",   category: "システム"),
        Shortcut(keys: "⌘Space",description: "Spotlight検索",       category: "システム"),
        Shortcut(keys: "⌘⇧3",  description: "スクリーンショット（全画面）", category: "システム"),
        Shortcut(keys: "⌘⇧4",  description: "スクリーンショット（選択）",   category: "システム"),
        Shortcut(keys: "⌘⇧5",  description: "スクリーンショット（オプション）", category: "システム"),
    ]

    static let finderShortcuts: [Shortcut] = [
        Shortcut(keys: "⌘N",   description: "新しいFinderウィンドウ", category: "ファイル操作"),
        Shortcut(keys: "⌘⇧N",  description: "新しいフォルダ",        category: "ファイル操作"),
        Shortcut(keys: "⌘⌫",   description: "ゴミ箱に入れる",        category: "ファイル操作"),
        Shortcut(keys: "⌘⇧⌫",  description: "ゴミ箱を空にする",      category: "ファイル操作"),
        Shortcut(keys: "⌘D",   description: "複製",                  category: "ファイル操作"),
        Shortcut(keys: "⌘I",   description: "情報を見る",            category: "ファイル操作"),
        Shortcut(keys: "⌘L",   description: "エイリアスを作成",      category: "ファイル操作"),
        Shortcut(keys: "Space", description: "クイックルック",        category: "ファイル操作"),
        Shortcut(keys: "⌘↩",   description: "名前を変更",            category: "ファイル操作"),
        Shortcut(keys: "⌘1",   description: "アイコン表示",          category: "表示"),
        Shortcut(keys: "⌘2",   description: "リスト表示",            category: "表示"),
        Shortcut(keys: "⌘3",   description: "カラム表示",            category: "表示"),
        Shortcut(keys: "⌘4",   description: "ギャラリー表示",        category: "表示"),
        Shortcut(keys: "⌘↑",   description: "上位フォルダを開く",    category: "移動"),
        Shortcut(keys: "⌘↓",   description: "選択項目を開く",        category: "移動"),
        Shortcut(keys: "⌘⇧G",  description: "フォルダへ移動",        category: "移動"),
        Shortcut(keys: "⌘⇧H",  description: "ホームフォルダ",        category: "移動"),
        Shortcut(keys: "⌘⇧D",  description: "デスクトップ",          category: "移動"),
        Shortcut(keys: "⌘⇧A",  description: "アプリケーション",      category: "移動"),
        Shortcut(keys: "⌘⇧C",  description: "コンピュータ",          category: "移動"),
    ]

    static let safariShortcuts: [Shortcut] = [
        Shortcut(keys: "⌘T",   description: "新しいタブ",                category: "タブ"),
        Shortcut(keys: "⌘W",   description: "タブを閉じる",              category: "タブ"),
        Shortcut(keys: "⌘⇧T",  description: "閉じたタブを再度開く",      category: "タブ"),
        Shortcut(keys: "⌘⇧]",  description: "次のタブ",                  category: "タブ"),
        Shortcut(keys: "⌘⇧[",  description: "前のタブ",                  category: "タブ"),
        Shortcut(keys: "⌘R",   description: "再読み込み",                category: "ナビゲーション"),
        Shortcut(keys: "⌘L",   description: "アドレスバーにフォーカス",  category: "ナビゲーション"),
        Shortcut(keys: "⌘[",   description: "戻る",                      category: "ナビゲーション"),
        Shortcut(keys: "⌘]",   description: "進む",                      category: "ナビゲーション"),
        Shortcut(keys: "⌘D",   description: "ブックマークに追加",        category: "ブックマーク"),
        Shortcut(keys: "⌘⇧D",  description: "リーディングリストに追加",  category: "ブックマーク"),
        Shortcut(keys: "⌘⌥B",  description: "ブックマークを表示",        category: "ブックマーク"),
        Shortcut(keys: "⌘+",   description: "拡大",                      category: "表示"),
        Shortcut(keys: "⌘-",   description: "縮小",                      category: "表示"),
        Shortcut(keys: "⌘0",   description: "実際のサイズ",              category: "表示"),
    ]

    static let chromeShortcuts: [Shortcut] = [
        Shortcut(keys: "⌘T",   description: "新しいタブ",                category: "タブ"),
        Shortcut(keys: "⌘W",   description: "タブを閉じる",              category: "タブ"),
        Shortcut(keys: "⌘⇧T",  description: "閉じたタブを再度開く",      category: "タブ"),
        Shortcut(keys: "⌘⇧]",  description: "次のタブ",                  category: "タブ"),
        Shortcut(keys: "⌘⇧[",  description: "前のタブ",                  category: "タブ"),
        Shortcut(keys: "⌘R",   description: "再読み込み",                category: "ナビゲーション"),
        Shortcut(keys: "⌘L",   description: "アドレスバー",              category: "ナビゲーション"),
        Shortcut(keys: "⌘[",   description: "戻る",                      category: "ナビゲーション"),
        Shortcut(keys: "⌘]",   description: "進む",                      category: "ナビゲーション"),
        Shortcut(keys: "⌘⇧N",  description: "シークレットウィンドウ",    category: "ウィンドウ"),
        Shortcut(keys: "⌘⌥I",  description: "DevToolsを開く",            category: "開発"),
        Shortcut(keys: "⌘⌥J",  description: "コンソールを開く",          category: "開発"),
        Shortcut(keys: "⌘+",   description: "拡大",                      category: "表示"),
        Shortcut(keys: "⌘-",   description: "縮小",                      category: "表示"),
        Shortcut(keys: "⌘0",   description: "実際のサイズ",              category: "表示"),
    ]

    static let vscodeShortcuts: [Shortcut] = [
        Shortcut(keys: "⌘P",   description: "クイックオープン",          category: "ファイル"),
        Shortcut(keys: "⌘⇧P",  description: "コマンドパレット",          category: "ファイル"),
        Shortcut(keys: "⌘B",   description: "サイドバー切り替え",        category: "表示"),
        Shortcut(keys: "⌘J",   description: "パネル切り替え",            category: "表示"),
        Shortcut(keys: "⌘`",   description: "ターミナル切り替え",        category: "表示"),
        Shortcut(keys: "⌘⇧E",  description: "エクスプローラー",          category: "表示"),
        Shortcut(keys: "⌘⇧F",  description: "プロジェクト内検索",        category: "表示"),
        Shortcut(keys: "⌘⇧G",  description: "ソース管理",                category: "表示"),
        Shortcut(keys: "⌘/",   description: "コメント切り替え",          category: "編集"),
        Shortcut(keys: "⌥↑",   description: "行を上に移動",              category: "編集"),
        Shortcut(keys: "⌥↓",   description: "行を下に移動",              category: "編集"),
        Shortcut(keys: "⌥⇧↑",  description: "行を上にコピー",            category: "編集"),
        Shortcut(keys: "⌥⇧↓",  description: "行を下にコピー",            category: "編集"),
        Shortcut(keys: "⌘D",   description: "次の選択に追加",            category: "編集"),
        Shortcut(keys: "⌘⇧K",  description: "行を削除",                  category: "編集"),
        Shortcut(keys: "F5",   description: "デバッグ開始",              category: "デバッグ"),
        Shortcut(keys: "F9",   description: "ブレークポイント切り替え",  category: "デバッグ"),
        Shortcut(keys: "F10",  description: "ステップオーバー",          category: "デバッグ"),
        Shortcut(keys: "F11",  description: "ステップイン",              category: "デバッグ"),
    ]

    static let terminalShortcuts: [Shortcut] = [
        Shortcut(keys: "⌘T",   description: "新しいタブ",            category: "ウィンドウ"),
        Shortcut(keys: "⌘N",   description: "新しいウィンドウ",      category: "ウィンドウ"),
        Shortcut(keys: "⌘K",   description: "クリア",                category: "ウィンドウ"),
        Shortcut(keys: "⌃C",   description: "中断",                  category: "プロセス"),
        Shortcut(keys: "⌃Z",   description: "バックグラウンドへ",    category: "プロセス"),
        Shortcut(keys: "⌃D",   description: "EOF / ログアウト",      category: "プロセス"),
        Shortcut(keys: "⌃A",   description: "行頭へ",                category: "カーソル"),
        Shortcut(keys: "⌃E",   description: "行末へ",                category: "カーソル"),
        Shortcut(keys: "⌃U",   description: "行全体を削除",          category: "カーソル"),
        Shortcut(keys: "⌃K",   description: "カーソル以降を削除",    category: "カーソル"),
        Shortcut(keys: "⌃W",   description: "単語を削除（前）",      category: "カーソル"),
        Shortcut(keys: "⌃R",   description: "コマンド履歴を検索",    category: "履歴"),
        Shortcut(keys: "↑",    description: "前のコマンド",          category: "履歴"),
        Shortcut(keys: "↓",    description: "次のコマンド",          category: "履歴"),
    ]

    static let itermShortcuts: [Shortcut] = terminalShortcuts + [
        Shortcut(keys: "⌘D",   description: "縦分割",                category: "ペイン"),
        Shortcut(keys: "⌘⇧D",  description: "横分割",                category: "ペイン"),
        Shortcut(keys: "⌘⌥↑",  description: "上のペインに移動",      category: "ペイン"),
        Shortcut(keys: "⌘⌥↓",  description: "下のペインに移動",      category: "ペイン"),
        Shortcut(keys: "⌘⌥←",  description: "左のペインに移動",      category: "ペイン"),
        Shortcut(keys: "⌘⌥→",  description: "右のペインに移動",      category: "ペイン"),
    ]

    static let xcodeShortcuts: [Shortcut] = [
        Shortcut(keys: "⌘B",   description: "ビルド",                    category: "ビルド"),
        Shortcut(keys: "⌘R",   description: "実行",                      category: "ビルド"),
        Shortcut(keys: "⌘⇧K",  description: "クリーン",                  category: "ビルド"),
        Shortcut(keys: "⌘.",   description: "停止",                      category: "ビルド"),
        Shortcut(keys: "⌘U",   description: "テスト実行",                category: "テスト"),
        Shortcut(keys: "⌘⇧O",  description: "クイックオープン",          category: "ナビゲーション"),
        Shortcut(keys: "⌘⌃↑",  description: "ヘッダー/実装を切り替え",   category: "ナビゲーション"),
        Shortcut(keys: "⌘⌃←",  description: "前の編集位置",              category: "ナビゲーション"),
        Shortcut(keys: "⌘⇧F",  description: "プロジェクト内検索",        category: "検索"),
        Shortcut(keys: "⌘⇧J",  description: "エクスプローラーで表示",    category: "ナビゲーション"),
        Shortcut(keys: "F5",   description: "デバッグ続行",              category: "デバッグ"),
        Shortcut(keys: "F6",   description: "ステップオーバー",          category: "デバッグ"),
        Shortcut(keys: "F7",   description: "ステップイン",              category: "デバッグ"),
    ]
}
