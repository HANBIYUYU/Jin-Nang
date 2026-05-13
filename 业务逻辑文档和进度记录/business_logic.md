# 锦囊 (Jin Nang) — 业务逻辑文档

---

## 1. 产品概述

**锦囊** 是一款面向中文学习者的移动端应用，采用粗黑边框 + 硬阴影 + 莫兰迪色系的复古卡片视觉风格。核心玩法围绕「场景化学习」展开：用户选择生活场景（如餐厅点餐），先学习相关词汇，再通过闯关式对话练习巩固记忆。

### 1.1 核心循环

**Study 分支（学习流）：**
```
启动页 → 登录/注册 → 首页（Study Tab）
                    ↓
            点击 Vocab Learning → 场景选择页
                    ↓
            选择场景（Restaurant / Supermarket...）
                    ↓
            词汇学习（6张卡片，点击高亮 + 音频）
                    ↓
            对话练习（4关闯关模式）
                    ↓
            关卡结果（得分 + 星级 + 解锁下一关）
```

**Toolbox 分支（工具流）：**
```
首页（Toolbox Tab）
    ↓
选择场景卡片 → Vocab Battle（词汇详情页）
    ↓
Prev / Next 翻页，末页 Finish 返回 Toolbox
```

---

## 2. 页面结构与路由

### 2.1 路由表

| 路径 | 页面 | 底部导航 | Tab | 说明 |
|------|------|----------|-----|------|
| `/splash` | SplashScreen | ❌ | — | 启动页，3秒自动跳转 |
| `/login` | LoginScreen | ❌ | — | 登录 |
| `/register` | RegisterScreen | ❌ | — | 注册 |
| `/study` | HomeScreen | ✅ | Study | 学习首页 |
| `/study/vocab-scene` | VocabSceneScreen | ✅ | Study | 场景选择页 |
| `/study/vocab-learning` | VocabLearningScreen | ✅ | Study | 词汇学习（6词卡片） |
| `/study/dialogue-practice` | DialoguePracticeScreen | ✅ | Study | 关卡列表（4关） |
| `/study/level/:levelId` | LevelScreen | ✅ | Study | 具体关卡答题 |
| `/toolbox` | ToolboxScreen | ✅ | Toolbox | 工具箱 |
| `/toolbox/vocab-card` | ToolboxCard | ✅ | Toolbox | Vocab Battle（词汇详情） |
| `/me` | ProfileScreen | ✅ | My | 个人资料 |

### 2.2 导航规则

- **底部 Tab 切换**：使用 `StatefulShellRoute.indexedStack`，各 Tab 保持独立导航栈
  - Study Tab：学习首页 + 场景选择 + 词汇学习 + 对话练习 + 关卡
  - Toolbox Tab：工具箱 + Vocab Battle
  - My Tab：个人资料
- **子页面跳转**：使用 `context.go()`，支持返回
- **登录态**：Demo 版无真实鉴权，登录/注册后直接跳转 `/study`
- **返回规则**：各子页面通过 AppHeader 的返回按钮回到上一级

---

## 3. 各页面业务逻辑

### 3.1 启动页 (SplashScreen)

- **触发**：App 启动时自动显示
- **行为**：
  1. 显示 App Logo + 名称 + Slogan
  2. 3 秒后自动跳转到 `/login`
- **边界**：用户不可跳过，无交互按钮

### 3.2 登录页 (LoginScreen)

- **输入**：Email、Password
- **行为**：
  1. 点击 Sign In → 直接跳转 `/study`（Demo 无校验）
  2. 点击 "Sign Up" → 跳转 `/register`
  3. 密码支持显示/隐藏切换
- **边界**：
  - 空输入不拦截（Demo 版）
  - 无"忘记密码"功能

### 3.3 注册页 (RegisterScreen)

- **输入**：Name、Email、Password
- **行为**：
  1. 点击 Create Account → 直接跳转 `/study`
  2. 点击 "Sign In" → 跳转 `/login`
  3. 左上角返回按钮 → 跳转 `/login`
- **边界**：同登录页

### 3.4 首页 (HomeScreen)

- **内容**：
  - 欢迎区："Yo! Alex 👋" + "Ready to Level Up?"（蓝绿色小卡片）
  - 统计卡片：Streak（12 天）+ Rank（Gold）
  - 任务列表：Vocab Learning、Dialogue Practice（可点击跳转）
- **交互**：
  - 点击 Vocab Learning → `/study/vocab-scene`
  - 点击 Dialogue Practice → `/study/dialogue-practice`
- **边界**：统计数据为写死值，无真实用户数据

### 3.5 场景选择页 (VocabSceneScreen)

- **内容**：场景卡片列表
  - Restaurant（解锁，蓝色）
  - Supermarket（锁定，紫色）
- **交互**：
  - 点击 Restaurant → `/study/vocab-learning`
  - 锁定卡片：原色保留 + Opacity 0.35 罩灰 + 锁标，不可点击
- **边界**：锁定/解锁状态为写死值

### 3.6 词汇学习页 (VocabLearningScreen)

- **内容**：6 张词汇卡片（2×3 网格）
  - 米饭、面条、水、茶、饭店、吃
- **交互**：
  1. 点击卡片 → 背景高亮 0.2 秒 + 播放音频
  2. 已点击卡片显示绿色边框 + ✓ 图标
  3. 所有卡片点击后，底部按钮从禁用变为启用
  4. 点击 "学完了，去练习" → `/study/dialogue-practice`
  5. 返回按钮 → `/study/vocab-scene`
- **边界**：
  - 音频已接入 audioplayers
  - 快速连续点击同一卡片：只响应第一次
  - 离开页面后学习进度重置

### 3.7 Vocab Battle (ToolboxCard)

- **内容**：
  - 单词卡片：汉字（大字）+ 拼音 + 音量按钮（播放音频）
  - 词性标签 + 英文释义 + 中文释义（含拼音）
  - 例句区：2 条中英对照例句卡片
  - Toggle 按钮：关联词 / 短语 切换
  - 关联词列表：按近义/反义/拓展分类，带颜色标签
  - 短语列表：中英对照
  - 翻页导航：Previous / Next
- **交互**：
  1. 点击音量按钮 → 播放当前词音频
  2. Toggle 切换关联词 / 短语显示
  3. Previous / Next 翻页（2 个示例词）
  4. 末页显示 "Finish"，点击返回 Toolbox
  5. 返回按钮 → `/toolbox`
- **边界**：词汇数据为硬编码

### 3.8 对话练习页 (DialoguePracticeScreen)

- **内容**：4 个关卡卡片
  - Level 1: Vocab Match（已解锁，3星）
  - Level 2: Listen & Choose（已解锁，2星）
  - Level 3: Fill in Blanks（锁定）
  - Level 4: Challenge（锁定）
- **交互**：
  - 点击已解锁关卡 → `/study/level/:levelId`
  - 锁定关卡不可点击
  - 返回按钮 → `/study/vocab-learning`
- **边界**：星级和解锁状态为写死值

### 3.9 工具箱 (ToolboxScreen)

- **内容**：场景卡片列表
  - Restaurant（解锁，可点击 → Vocab Battle）
  - Supermarket（锁定）
  - Airport（锁定）
- **交互**：
  - 点击 Restaurant → `/toolbox/vocab-card`
  - 锁定卡片：原色保留 + Opacity 0.35 罩灰 + 锁标，不可点击
- **边界**：锁定/解锁状态为写死值

### 3.10 关卡页 (LevelScreen)

- **内容**：答题界面
  - 顶部栏：返回 + 关卡名称 + 进度
  - 进度条
  - 题目卡片
  - 选项按钮（A/B/C/D）
  - 反馈区（正确/错误 + 解释）
  - Next 按钮
- **交互**：
  1. 点击选项 → 显示对错 + 解释
  2. 正确选项绿色高亮，错误选项红色高亮
  3. 点击 Next → 下一题或结果页
  4. 结果页：显示得分、星级、通过/未通过
  5. 通过：显示 Continue + Retry
  6. 未通过：显示 Retry
- **计分规则**：
  - 正确率 ≥ 80%（第4关 100%）→ 通过
  - 星级：1-3 星根据正确率分配
- **边界**：
  - 题目数据为硬编码
  - 无生命值/限错机制
  - 无提示功能

### 3.11 个人资料页 (ProfileScreen)

- **内容**：
  - 资料卡片：头像 + 用户名 + 等级徽章
  - 统计行：连续天数 / 词汇量 / 平均分
  - 设置列表：Notifications、Language、Help
- **交互**：纯展示，无实际功能
- **边界**：所有数据为写死值

---

## 4. 数据模型

### 4.1 词汇数据（VocabLearningScreen）

```dart
class VocabItem {
  final String chinese;    // 汉字
  final String pinyin;     // 拼音
  final String english;    // 英文释义
  final String audioAsset; // 音频资源路径
}
```

### 4.2 Vocab Battle 数据模型（ToolboxCard）

```dart
class VocabWord {
  final String chinese;           // 汉字
  final String pinyin;            // 拼音
  final String partOfSpeech;      // 词性（如 n.）
  final String englishMeaning;    // 英文释义
  final String chineseMeaning;    // 中文释义
  final String chineseMeaningPinyin; // 中文释义拼音
  final List<Example> examples;   // 例句列表
  final List<RelatedWord> relatedWords; // 关联词列表
  final List<Phrase> phrases;     // 短语列表
  final String audioAsset;        // 音频资源路径
}

class Example {
  final String chinese;  // 中文例句
  final String pinyin;   // 例句拼音
  final String english;  // 英文翻译
}

class RelatedWord {
  final String type;     // synonym | antonym | expand
  final String chinese;  // 汉字
  final String pinyin;   // 拼音
  final String english;  // 英文释义
}

class Phrase {
  final String chinese;  // 中文短语
  final String english;  // 英文翻译
}
```

### 4.3 题目数据 (Question)

```dart
class Question {
  final String question;      // 题目文本
  final List<String> options; // 选项列表
  final int correctIndex;     // 正确答案索引
  final String explanation;   // 解释文本
}
```

### 4.4 关卡数据 (LevelData)

```dart
class LevelData {
  final int levelId;          // 关卡ID
  final String title;         // 标题
  final String subtitle;      // 副标题
  final List<Question> questions; // 题目列表
  final int passThreshold;    // 通过阈值（默认80%）
}
```

---

## 5. 状态管理

### 5.1 当前状态

- **页面级状态**：使用 `StatefulWidget` + `setState`
  - VocabCardScreen：当前词索引、toggle 状态
  - VocabLearningScreen：已点击卡片集合、高亮索引
  - LevelScreen：当前题索引、选中选项、正确数

### 5.2 待实现

- [ ] 用户登录态（Token/Session）
- [ ] 学习进度持久化（SharedPreferences/本地数据库）
- [ ] 关卡解锁状态
- [ ] 用户统计数据（streak、rank、词汇量）
- [ ] 设置项持久化

---

## 6. 音频系统

### 6.1 当前实现

- 已接入 `audioplayers: ^6.0.0`
- 词汇学习页：点击卡片播放对应音频（防重复点击）
- Vocab Battle：点击音量按钮播放当前词音频
- 错误静默处理，不影响用户体验

### 6.2 使用方式

```dart
final player = AudioPlayer();
await player.play(AssetSource('audio/rice.mp3'));
```

注意：`AssetSource` 路径不需要 `assets/` 前缀。

### 6.3 音频资源

```
assets/audio/
├── rice.mp3        // 米饭
├── noodle.mp3      // 面条
├── water.mp3       // 水
├── tea.mp3         // 茶
├── restaurant.mp3  // 饭店
├── eat.mp3         // 吃
└── ...
```

---

## 7. 未实现功能清单

| 功能 | 优先级 | 状态 | 说明 |
|------|--------|------|------|
| 用户认证 | P0 | ❌ | 登录/注册 API 对接 |
| 数据持久化 | P0 | ❌ | 学习进度、用户数据本地存储（SharedPreferences） |
| 音频播放 | P0 | ✅ | 已接入 audioplayers |
| 真实词汇数据库 | P1 | ❌ | 从硬编码迁移到 JSON/数据库 |
| 关卡解锁逻辑 | P1 | ❌ | 根据通关状态动态解锁 |
| 设置功能 | P2 | ❌ | 通知、语言切换等 |
| 排行榜 | P2 | ❌ | 用户排名 |
| 成就系统 | P2 | ❌ | 徽章、积分 |
| 深色模式 | P3 | ❌ | 主题切换 |
| 多语言支持 | P3 | ❌ | i18n |

## 8. 公共组件

| 组件 | 路径 | 说明 |
|------|------|------|
| AppCard | `widgets/app_card.dart` | 粗边框 + 硬阴影卡片容器 |
| AppHeader | `widgets/app_header.dart` | 返回按钮 + 标题标签 + 可选进度计数 |
| IconContainer | `widgets/icon_container.dart` | 带边框图标方块（多尺寸变体） |
| SelectableCard | `widgets/selectable_card.dart` | 场景/工具卡片，支持锁定态（onTap == null） |

---

## 9. 技术栈

- **框架**：Flutter 3.x
- **状态管理**：StatefulWidget + setState（初期）
- **路由**：go_router（StatefulShellRoute.indexedStack）
- **UI 风格**：粗黑边框 + 硬阴影 + 莫兰迪色系 + 大圆角
- **字体**：Inter（本地加载，Regular/Medium/SemiBold/Bold）
- **图标**：本地 PNG（assets/icon/）
- **音频**：audioplayers（已接入）
- **存储**：SharedPreferences（预留）

## 10. 目录结构

```
lib/
├── main.dart                 # 入口 + 路由表
├── theme/
│   ├── app_theme.dart        # 全局 ThemeData
│   ├── app_colors.dart       # 莫兰迪色值
│   └── app_spacing.dart      # 间距常量
├── widgets/                  # 公共组件
│   ├── app_card.dart
│   ├── app_header.dart
│   ├── icon_container.dart
│   └── selectable_card.dart
└── features/
    ├── auth/                 # 启动 + 登录 + 注册
    ├── shell/                # 底部导航栏
    ├── home/                 # 首页
    │   └── vocab_learning/   # 场景选择 + 词汇学习
    ├── toolbox/              # 工具箱 + Vocab Battle
    ├── dialogue/             # 对话练习 + 关卡
    └── profile/              # 个人资料
```

---

*文档由 AI 生成，随项目迭代持续更新。*

**更新记录：**
- v1.1 (2026-05-14)：更新路由结构（Study/Toolbox Tab 分离）、新增 VocabSceneScreen、Vocab Battle 数据模型、音频系统接入、公共组件、目录结构
