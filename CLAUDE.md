# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**锦囊 (Jin-Nang)** — a Flutter Chinese-learning app targeting iOS, Android, Web, macOS, Linux, Windows. The pubspec name is still the scaffold default `test1`; do not assume it's renamed.

## Commands

```bash
# Daily dev (Nix devShell + direnv auto-loads when entering the directory)
flutter pub get
flutter run                  # default device
flutter run -d chrome        # Web
flutter run -d macos         # macOS desktop

# Quality gates
flutter analyze              # static analysis (flutter_lints)
flutter test                 # widget tests (only test/widget_test.dart today)
flutter test test/widget_test.dart -p "MyApp ..."   # single test by name

# Native splash regeneration (config in flutter_native_splash.yaml)
dart run flutter_native_splash:create
```

### iOS builds — non-standard

The Nix-packaged Flutter SDK does **not** include the full iOS engine framework. iOS device builds must use the Homebrew Flutter:

```bash
/opt/homebrew/Caskroom/flutter/*/flutter/bin/flutter build ios --debug --no-codesign
open ios/Runner.xcworkspace   # configure signing in Xcode, then Cmd+R
```

If regenerating the `ios/` directory: also `chmod -R u+w ios/` afterwards — Nix-created files are read-only and break pod installs.

`flake.nix` exports `DEVELOPER_DIR=/Applications/Xcode.app/...` and clears `SDKROOT` so Xcode resolves the real iOS SDK rather than Nix's minimal Apple SDK. Don't override these.

## Architecture

### Routing — go_router with StatefulShellRoute

`lib/main.dart` is the single source of truth for the route table. Three top-level full-screen routes (`/splash`, `/login`, `/register`) sit outside the shell. Everything else lives inside a `StatefulShellRoute.indexedStack` with three branches:

- **Study** (`/study/...`) — home, vocab scene selection, vocab learning, dialogue practice, individual levels
- **Toolbox** (`/toolbox/...`) — toolbox grid, Vocab Battle card
- **My** (`/me`) — profile

Each branch has its own `GlobalKey<NavigatorState>` so tabs preserve their navigation stack independently. Sub-page transitions use the `_slidePage` helper (right-slide) defined in `main.dart` — reuse it for new sub-routes instead of inventing per-screen transitions.

### Feature-first layout under `lib/`

```
lib/
├── main.dart              # entry + router
├── theme/                 # design tokens (colors, fonts, spacing, ThemeData)
├── widgets/               # cross-feature reusable widgets
└── features/<feature>/    # screens grouped by product area
```

Feature folders are flat by default (`features/auth/login_screen.dart`); nested sub-features (e.g. `features/home/vocab_learning/`, `features/home/dialogue/`) appear when a feature has multiple screens.

### Theming

- `AppTheme.lightTheme` in `lib/theme/app_theme.dart` is wired into `MaterialApp.router`. There is no dark theme yet.
- `AppFonts` declares **two font families** with fallback: `Inter` for Latin glyphs, `LXGW WenKai` for Chinese. Always set `fontFamily: AppFonts.english` with `fontFamilyFallback: [AppFonts.chinese]` (already done globally in the theme) — don't hardcode font families on individual `TextStyle`s.
- `AppColors` is the only place HEX values live. Two namespaces coexist: standard semantic (`brandPurple`, `semanticRed`, `neutralGray0X`) and the Figma-named Morandi palette (`morandiText`, `baliHai30`, `straw14`, `oldRose15`, …). Tabs in `MainShell` and feature screens use the Figma names.

### Visual language — thick-border + hard-shadow card system

Every card-like surface follows the same primitive: black ~2.5–4px border, offset solid-color drop shadow (no blur), large rounded corners, pastel Morandi fills. The reusable building blocks are:

- `widgets/app_card.dart` — base card container
- `widgets/app_header.dart` — back button + title tab + optional progress counter
- `widgets/icon_container.dart` — bordered icon tile, multiple sizes
- `widgets/selectable_card.dart` — scene/tool card; **disabled state = `onTap == null`** (no separate `enabled` flag), per the project's design-system rule
- `widgets/pressable.dart` — universal tap wrapper providing the press feedback (offset + opacity dip), haptic, and SFX. Prefer `Pressable` over raw `GestureDetector`/`InkWell` for any interactive surface so press feedback stays consistent.

Press SFX comes from `ButtonSounds` (singleton in `pressable.dart`) playing `assets/audio/btn_pressed.mp3` / `btn_released.mp3`.

### Audio

Two categories with different storage and playback:

| 类别 | 存储 | 播放方式 |
|------|------|----------|
| 按钮音效（btn_pressed / btn_released） | App 包体 `assets/audio/` | `AssetSource` |
| 词汇音频（全部业务音频） | CF R2，按需下载 | `DeviceFileSource`（本地缓存后） |

`AssetSource` 路径相对于 `assets/` — 传 `'audio/btn_pressed.mp3'`，不含 `assets/` 前缀。词汇音频不再打包进 App，由 `flutter_cache_manager` 管理下载和缓存（待接入）。

### State management

Currently `StatefulWidget` + `setState` only — no Riverpod/BLoC yet. All user data (streak, rank, unlock state, vocabulary, questions) is hardcoded in screen files. No persistence layer exists — data will come from the backend once the network layer is built.

## Conventions

- File names: `snake_case.dart`. Classes: `PascalCase`. Variables/methods/constants: `lowerCamelCase` (even for constants — `appSpacingMd`, not `APP_SPACING_MD`).
- Spacing values must come from `lib/theme/app_spacing.dart`, on the 4pt/8pt grid. No raw magic numbers for padding/margin.
- Strict Figma 1:1 alignment — colors, spacing, and component states come from Figma tokens, not designer-eye approximation in code.
- All interactive widgets carry their states from Figma Variants: `Default / Pressed / Disabled` (no `Hover` since mobile-only). Disabled = null callback.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `refactor:`, `perf:`, `chore:`, `docs:`). Recent history shows this is enforced by convention.
- The project's design and Flutter coding rules are written up in `flutter规范.md` and `figma规范.md` at the repo root — read these for style decisions not covered here.

## Backend architecture

**Cloudflare Workers + D1 + R2** — all backend is deployed on Cloudflare:

- **Workers** (Hono): HTTP/HTTPS/WebSocket API, JWT auth
- **D1** (SQLite): all business data — users, scenes, vocab, levels, progress
- **R2**: vocab audio files (`audio/{scene}/{word}.mp3`)

DB stores `audio_key` as a relative path (e.g. `restaurant/rice.mp3`); the full URL is assembled by Workers at response time.

### API surface

```
POST /auth/register   POST /auth/login    GET /auth/me
GET  /scenes          GET /scenes/:id/vocab
GET  /vocab/:id       GET /scenes/:id/levels
GET  /user/progress   POST /user/progress
```

All authenticated endpoints require `Authorization: Bearer <jwt>`.

### Flutter network layer (not yet built)

Planned under `lib/core/`:
- `network/` — Dio client with JWT injection interceptor
- `audio/` — `flutter_cache_manager` wrapper for vocab audio
- `auth/` — JWT storage and refresh

Each feature gets a `data/` subfolder with its Repository once the network layer exists.

## Project context docs

`業務逻辑文档和进度记录/business_logic.md` is the live spec — every screen's flow, route table, data models, API routes, audio architecture, and the full "未实现功能清单" (P0–P3). Check it before adding screens or changing flow. `progress.md` in the same folder tracks ongoing work.
