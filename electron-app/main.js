const { app, BrowserWindow, screen, ipcMain, globalShortcut, systemPreferences } = require('electron');
const { execSync } = require('child_process');
const path = require('path');

// シングルインスタンス保証（二重起動を防ぐ）
const gotLock = app.requestSingleInstanceLock();
if (!gotLock) {
  // 既に起動中 → 既存インスタンスにフォーカスを戻して終了
  app.quit();
}

let win = null;
let currentAppName = 'システム共通';
let pollInterval = null;
let appReady = false; // 起動直後のactivateを無視するフラグ

// アクティブなアプリ名を取得
function getFrontmostApp() {
  try {
    const name = execSync(
      `osascript -e "tell application \\"System Events\\" to get name of first application process whose frontmost is true"`,
      { timeout: 500, stdio: ['pipe', 'pipe', 'ignore'] }
    ).toString().trim();
    return name;
  } catch {
    return null;
  }
}

// アプリ名 → ショートカットデータキー
function getBundleKey(appName) {
  const map = {
    'Finder': 'finder',
    'Safari': 'safari',
    'Google Chrome': 'chrome',
    'Code': 'vscode',
    'Terminal': 'terminal',
    'iTerm2': 'iterm',
    'Xcode': 'xcode',
  };
  return map[appName] || 'common';
}

function getWindowPosition() {
  const { workAreaSize } = screen.getPrimaryDisplay();
  const winWidth = 390;
  const winHeight = 520;
  const x = workAreaSize.width - winWidth - 10;
  const y = 30;
  return { x, y, winWidth, winHeight };
}

function createWindow() {
  const { x, y, winWidth, winHeight } = getWindowPosition();
  const APP_DIR = app.getAppPath();

  win = new BrowserWindow({
    x, y,
    width: winWidth,
    height: winHeight,
    minWidth: 280,
    minHeight: 200,
    show: true,
    frame: false,
    resizable: true,
    alwaysOnTop: true,
    skipTaskbar: false,
    backgroundColor: '#ffffff',
    hasShadow: true,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
    },
  });

  win.loadFile(path.join(APP_DIR, 'index.html'));

  // ページ読み込み完了後に確実に表示
  win.webContents.on('did-finish-load', () => {
    win.show();
    win.focus();
    appReady = true;
    console.log('ShortcutCheatSheet ready — ショートカットキーが表示されました');
  });
}

function toggleWindow() {
  if (!win) return;
  if (win.isVisible()) {
    win.hide();
  } else {
    // ウィンドウ位置を画面右上に合わせて更新（サイズは維持）
    const { workAreaSize } = screen.getPrimaryDisplay();
    const bounds = win.getBounds();
    const newX = workAreaSize.width - bounds.width - 10;
    win.setPosition(newX, 30);

    // 現在のアクティブアプリを取得してから表示
    const appName = getFrontmostApp();
    if (appName && appName !== 'Electron' && appName !== 'ShortcutCheatSheet') {
      currentAppName = appName;
      win.webContents.send('app-changed', {
        appName: currentAppName,
        key: getBundleKey(currentAppName),
      });
    }
    win.show();
    win.focus();
  }
}

function startPolling() {
  // 権限チェックはポーリング開始時（3秒後）に行う
  setTimeout(() => {
    const trusted = systemPreferences.isTrustedAccessibilityClient(false);
    if (!trusted) {
      console.log('Accessibility not granted — app detection disabled.');
      return;
    }
    console.log('Accessibility granted — starting app detection polling.');
    pollInterval = setInterval(() => {
      const appName = getFrontmostApp();
      if (appName && appName !== 'Electron' && appName !== 'ShortcutCheatSheet' && appName !== currentAppName) {
        currentAppName = appName;
        if (win && win.webContents) {
          win.webContents.send('app-changed', {
            appName: appName,
            key: getBundleKey(appName),
          });
        }
      }
    }, 600);
  }, 3000); // 権限ダイアログへの応答を待つ
}

// 2つ目のインスタンスが起動しようとした時は、既存ウィンドウを表示
app.on('second-instance', () => {
  if (win) {
    if (!win.isVisible()) toggleWindow();
    win.focus();
  }
});

app.whenReady().then(() => {
  createWindow();

  // アクセシビリティ権限が未許可なら、ウィンドウ表示後に一度だけリクエスト
  // isTrustedAccessibilityClient(true) = プロンプトを表示してシステム設定を開く
  const alreadyTrusted = systemPreferences.isTrustedAccessibilityClient(false);
  if (!alreadyTrusted) {
    setTimeout(() => {
      systemPreferences.isTrustedAccessibilityClient(true);
    }, 800); // ウィンドウが表示されてから少し後
  }

  startPolling();

  // グローバルショートカット: Cmd+Shift+K でトグル
  const ok = globalShortcut.register('CommandOrControl+Shift+K', () => {
    toggleWindow();
  });
  if (!ok) {
    console.warn('Warning: Could not register global shortcut Cmd+Shift+K');
  }

  // Dockアイコンクリックでウィンドウをトグル（起動直後は無視）
  app.on('activate', () => {
    if (!appReady) return; // 起動直後のactivateは無視
    toggleWindow();
  });
});

app.on('window-all-closed', (e) => e.preventDefault());

app.on('will-quit', () => {
  globalShortcut.unregisterAll();
  if (pollInterval) clearInterval(pollInterval);
});

ipcMain.on('quit', () => app.quit());
ipcMain.on('hide-window', () => { if (win) win.hide(); });
ipcMain.on('resize-window', (_, bounds) => { if (win) win.setBounds(bounds, false); });
ipcMain.handle('get-window-bounds', () => win ? win.getBounds() : null);

// IPC: レンダラーから現在アプリ情報を要求
ipcMain.handle('get-current-app', () => ({
  appName: currentAppName,
  key: getBundleKey(currentAppName),
}));
