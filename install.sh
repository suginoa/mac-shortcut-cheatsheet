#!/bin/bash
# macOS 26 対応版: Electron ベースの浮動ウィンドウ方式
set -e

APP_DIR="$(cd "$(dirname "$0")/electron-app" && pwd)"
LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
LAUNCH_AGENT_PLIST="$LAUNCH_AGENT_DIR/com.local.ShortcutCheatSheet.plist"
ELECTRON="$APP_DIR/node_modules/.bin/electron"

echo "📦 依存パッケージを確認中..."
cd "$APP_DIR"
npm install --silent 2>/dev/null || true

# electronバイナリが存在するか確認
if [ ! -f "$APP_DIR/node_modules/electron/dist/Electron.app/Contents/MacOS/Electron" ]; then
  echo "❌ Electronが見つかりません。npm install を実行してください。"
  exit 1
fi

ELECTRON_BIN="$APP_DIR/node_modules/electron/dist/Electron.app/Contents/MacOS/Electron"

# ── ログイン時に自動起動（LaunchAgent）──
mkdir -p "$LAUNCH_AGENT_DIR"
cat > "$LAUNCH_AGENT_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.ShortcutCheatSheet</string>
    <key>ProgramArguments</key>
    <array>
        <string>$ELECTRON_BIN</string>
        <string>$APP_DIR</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>WorkingDirectory</key>
    <string>$APP_DIR</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin</string>
    </dict>
    <key>StandardOutPath</key>
    <string>/tmp/shortcut-cheatsheet.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/shortcut-cheatsheet.log</string>
</dict>
</plist>
PLIST

launchctl unload "$LAUNCH_AGENT_PLIST" 2>/dev/null || true
launchctl load "$LAUNCH_AGENT_PLIST"
echo "✅ ログイン自動起動を設定しました"

# ── 今すぐ起動 ──
echo "🚀 アプリを起動中..."
pkill -f "electron-app/node_modules/electron" 2>/dev/null || true
sleep 0.5
"$ELECTRON_BIN" "$APP_DIR" &
sleep 3

echo ""
echo "═══════════════════════════════════════════"
echo "✅ ショートカットチートシートが起動しました！"
echo ""
echo "使い方:"
echo "  • 画面右上にショートカット一覧が表示されます"
echo "  • Cmd+Shift+K: 表示/非表示を切り替え"
echo "  • Dockアイコンクリック: 表示/非表示を切り替え"
echo "  • アプリを切り替えると自動的に対応ショートカットに変わります"
echo "  • 右上の☆: お気に入りフィルター"
echo "  • ✕ボタン: アプリを終了"
echo ""
echo "対応アプリ: Finder / Safari / Chrome / VS Code / Terminal / iTerm2 / Xcode"
echo "ログイン時に自動起動します"
echo "═══════════════════════════════════════════"
