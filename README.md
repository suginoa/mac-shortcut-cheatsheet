# Mac ショートカットキー チートシート

使っているアプリを自動検出して、そのショートカットキー一覧を画面の右上に常駐表示するMacアプリです。

![demo](https://raw.githubusercontent.com/suginoa/mac-shortcut-cheatsheet/main/docs/demo.png)

## 機能

- **自動アプリ検出** — アクティブなアプリが変わると自動でショートカット一覧が切り替わる
- **常駐フローティングウィンドウ** — 画面右上に透過できる浮かせたウィンドウで常時表示
- **キーボードショートカットでトグル** — `Cmd+Shift+K` で表示/非表示を切り替え
- **検索機能** — ショートカットをキーワードで絞り込み
- **お気に入り登録** — よく使うショートカットを★で保存
- **全スペース対応** — フルスクリーンアプリ上にも表示

## 対応アプリ

| アプリ | キー |
|--------|------|
| システム共通 | common |
| Finder | finder |
| Safari | safari |
| Google Chrome | chrome |
| VS Code | vscode |
| Terminal | terminal |
| iTerm2 | iterm |
| Xcode | xcode |

## 動作環境

- macOS (Sonoma / Sequoia / macOS 26 対応)
- Node.js 18以上
- Electron 41

## インストール

### 方法A：DMGをダウンロード（簡単・Node.js不要）

[Releases](https://github.com/suginoa/mac-shortcut-cheatsheet/releases/latest) から自分のMacに合ったファイルをダウンロードしてください。

| Mac | ファイル |
|-----|---------|
| Apple Silicon (M1/M2/M3/M4) | `ShortcutCheatSheet-1.0.0-arm64.dmg` |
| Intel Mac | `ShortcutCheatSheet-1.0.0.dmg` |

1. DMGを開いて `ShortcutCheatSheet.app` をアプリケーションフォルダにドラッグ
2. 初回は右クリック → 「開く」で起動（Gatekeeperの警告が出る場合）

### 方法B：ソースから実行（開発者向け）

```bash
git clone https://github.com/suginoa/mac-shortcut-cheatsheet.git
cd mac-shortcut-cheatsheet/electron-app
npm install
./node_modules/.bin/electron .
```

### 自動起動の設定（オプション）

```bash
bash install.sh
```

ログイン時に自動起動するLaunchAgentを登録します。

## 使い方

### 手動起動

```bash
cd electron-app
./node_modules/.bin/electron .
```

### 操作

| 操作 | 動作 |
|------|------|
| `Cmd+Shift+K` | ウィンドウの表示/非表示 |
| Dockアイコンクリック | ウィンドウの表示/非表示 |
| 検索バー | ショートカットを絞り込み |
| ★ ボタン | お気に入り登録/解除 |
| ✕ ボタン | アプリを終了 |

### アクセシビリティ権限について

アプリ起動時に「アクセシビリティ」の権限を求めるダイアログが表示されます。  
許可すると、アクティブなアプリを自動検出してショートカット一覧が切り替わります。  
許可しない場合でも、手動でアプリを切り替えることができます（今後実装予定）。

**許可手順:**
1. ダイアログで「システム設定を開く」をクリック
2. システム設定 → プライバシーとセキュリティ → アクセシビリティ
3. 「Electron」をオンにする

## ショートカットの追加・カスタマイズ

`electron-app/shortcuts.js` を編集してください。

```js
shortcuts.myapp = [
  { keys: ['⌘', 'S'], description: '保存' },
  { keys: ['⌘', 'Z'], description: '元に戻す' },
];
```

アプリ名のマッピングは `main.js` の `getBundleKey()` 関数で追加できます。

## ライセンス

MIT
