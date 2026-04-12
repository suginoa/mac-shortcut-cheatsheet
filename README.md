# Mac ショートカットキー チートシート

使っているアプリを自動検出して、そのショートカットキー一覧を画面の右上に常駐表示するMacアプリです。  
自由に修正・改造して使ってください。

## 使い方

**Node.js が必要です。** 入っていない場合は [nodejs.org](https://nodejs.org) からインストールしてください。

```bash
git clone https://github.com/suginoa/mac-shortcut-cheatsheet.git
cd mac-shortcut-cheatsheet/electron-app
npm install
./node_modules/.bin/electron .
```

## 操作

| 操作 | 動作 |
|------|------|
| `Cmd+Shift+K` | ウィンドウの表示/非表示 |
| Dockアイコンクリック | ウィンドウの表示/非表示 |
| 検索バー | ショートカットを絞り込み |
| ★ ボタン | お気に入り登録/解除 |
| ✕ ボタン | アプリを終了 |

## アクセシビリティ権限について

初回起動時にアクセシビリティ権限を求めるダイアログが表示されます。  
許可すると、アクティブなアプリを自動検出してショートカット一覧が切り替わります。

1. ダイアログで「システム設定を開く」をクリック
2. システム設定 → プライバシーとセキュリティ → アクセシビリティ
3. 「Electron」をオンにする

## カスタマイズ

### ショートカットを追加・変更する

`electron-app/shortcuts.js` を編集します。

```js
shortcuts.myapp = [
  { keys: ['⌘', 'S'], description: '保存' },
  { keys: ['⌘', 'Z'], description: '元に戻す' },
];
```

### 対応アプリを追加する

`electron-app/main.js` の `getBundleKey()` にアプリ名を追加します。

```js
const map = {
  'Finder': 'finder',
  'MyApp': 'myapp',  // ← 追加
};
```

アプリ名は `Cmd+Space` でSpotlightを開き、アプリを起動すると左上のメニューバーに表示されます。

## ログイン時に自動起動する（オプション）

```bash
bash install.sh
```

## ライセンス

MIT — 自由に使用・改変・再配布できます。
