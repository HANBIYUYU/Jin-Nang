# 锦囊 (Jin Nang) — 业务逻辑文档

> 版本：v1.0  
> 日期：2026-03-29  
> 状态：初期设计阶段

---

## 1. 产品概述

**锦囊** 是一款面向中文学习者的移动端应用，采用粗黑边框 + 硬阴影 + 莫兰迪色系的复古卡片视觉风格。核心玩法围绕「场景化学习」展开：用户选择生活场景（如餐厅点餐），先学习相关词汇，再通过闯关式对话练习巩固记忆。

### 1.1 核心循环

```
启动页 → 登录/注册 → 首页
                    ↓
            选择场景（Restaurant/Supermarket...）
                    ↓
            词汇学习（卡片点击 + 音频）
                    ↓
            词汇卡片详情（例句 + 关联词）
                    ↓
            对话练习（4关闯关模式）
                    ↓
            关卡结果（得分 + 星级 + 解锁下一关）
```

---

## 2. 页面结构与路由

### 2.1 路由表

| 路径 | 页面 | 底部导航 | 说明 |
|------|------|----------|------|
| `/splash` | SplashScreen | ❌ | 启动页，3秒自动跳转 |
| `/login` | LoginScreen | ❌ | 登录 |
| `/register` | RegisterScreen | ❌ | 注册 |
| `/study` | HomeScreen | ✅ Study | 学习首页 |
| `/toolbox` | ToolboxScreen | ✅ Toolbox | 工具箱 |
| `/toolbox/vocab-learning` | VocabLearningScreen | ✅ Toolbox | 词汇学习（6词卡片） |
| `/toolbox/vocab-card` | VocabCardScreen | ✅ Toolbox | 词汇详情（例句+关联词） |
| `/toolbox/dialogue-practice` | DialoguePracticeScreen | ✅ Toolbox | 关卡列表（4关） |
| `/toolbox/level/:levelId` | LevelScreen | ✅ Toolbox | 具体关卡答题 |
| `/me` | ProfileScreen | ✅ My | 个人资料 |

### 2.2 导航规则

- **底部 Tab 切换**：使用 `StatefulShellRoute.indexedStack`，各 Tab 保持独立导航栈
- **子页面跳转**：使用 `context.go()` 或 `context.push()`，支持返回
- **登录态**：Demo 版无真实鉴权，登录/注册后直接跳转 `/study`

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
  - 欢迎区："Yo! Alex 👋" + "Ready to Level Up?"
  - 统计卡片：Streak（12 天）+ Rank（Gold）
  - 任务列表：Vocab Learning、Dialogue Practice（可点击跳转）
- **交互**：
  - 点击任务卡片 → 对应页面
- **边界**：统计数据为写死值，无真实用户数据

### 3.5 工具箱 (ToolboxScreen)

- **内容**：场景卡片列表
  - Restaurant（解锁，可点击）
  - Supermarket（锁定）
  - Airport（锁定）
- **交互**：
  - 点击 Restaurant → `/toolbox/vocab-learning`
  - 锁定卡片：显示锁图标，不可点击
- **边界**：锁定/解锁状态为写死值

### 3.6 词汇学习页 (VocabLearningScreen)

- **内容**：6 张词汇卡片（2×3 网格）
  - 米饭、面条、水、茶、饭店、吃
- **交互**：
  1. 点击卡片 → 背景高亮 0.2 秒 + 播放音频（控制台打印）
  2. 已点击卡片显示绿色边框 + ✓ 图标
  3. 所有卡片点击后，底部按钮从禁用变为启用
  4. 点击 "学完了，去练习" → `/toolbox/vocab-card`
- **边界**：
  - 音频播放为占位（需接入 audioplayers）
  - 快速连续点击同一卡片：只响应第一次
  - 离开页面后学习进度重置

### 3.7 词汇卡片详情页 (VocabCardScreen)

- **内容**：
  - 单词卡片：汉字 + 拼音 + 词性 + 英文释义
  - 例句区：2 条中英对照例句
  - Toggle 按钮：短语开关、关联词开关
  - 关联词列表：3 个相关词汇
  - 翻页导航：Previous / Next
  - "开始对话练习" 按钮
- **交互**：
  1. Toggle 按钮可切换显示/隐藏
  2. Previous / Next 翻页（2 个示例词）
  3. 末页显示 "Finished ✓"
  4. 点击 "开始对话练习" → `/toolbox/dialogue-practice`
- **边界**：词汇数据为硬编码

### 3.8 对话练习页 (DialoguePracticeScreen)

- **内容**：4 个关卡卡片
  - Level 1: Vocab Match（已解锁，3星）
  - Level 2: Listen & Choose（已解锁，2星）
  - Level 3: Fill in Blanks（锁定）
  - Level 4: Challenge（锁定）
- **交互**：
  - 点击已解锁关卡 → `/toolbox/level/:levelId`
  - 锁定关卡不可点击
- **边界**：星级和解锁状态为写死值

### 3.9 关卡页 (LevelScreen)

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

### 3.10 个人资料页 (ProfileScreen)

- **内容**：
  - 资料卡片：头像 + 用户名 + 等级徽章
  - 统计行：连续天数 / 词汇量 / 平均分
  - 设置列表：Notifications、Language、Help
- **交互**：纯展示，无实际功能
- **边界**：所有数据为写死值

---

## 4. 数据模型

### 4.1 词汇数据 (VocabItem)

```dart
class VocabItem {
  final String chinese;    // 汉字
  final String pinyin;     // 拼音
  final String english;    // 英文释义
  final String audioAsset; // 音频资源路径
}
```

### 4.2 题目数据 (Question)

```dart
class Question {
  final String question;      // 题目文本
  final List<String> options; // 选项列表
  final int correctIndex;     // 正确答案索引
  final String explanation;   // 解释文本
}
```

### 4.3 关卡数据 (LevelData)

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

## 6. 音频系统（预留）

### 6.1 当前实现

- 词汇卡片点击时，控制台打印音频路径
- 无实际播放功能

### 6.2 接入方案

```yaml
# pubspec.yaml 添加依赖
 dependencies:
   audioplayers: ^6.0.0
```

```dart
// 播放音频
final player = AudioPlayer();
await player.play(AssetSource('audio/rice.mp3'));
```

### 6.3 音频资源规划

```
assets/audio/
├── rice.mp3        // 米饭
├── noodles.mp3     // 面条
├── water.mp3       // 水
├── tea.mp3         // 茶
├── restaurant.mp3  // 饭店
├── eat.mp3         // 吃
└── ...
```

---

## 7. 未实现功能清单

| 功能 | 优先级 | 说明 |
|------|--------|------|
| 用户认证 | P0 | 登录/注册 API 对接 |
| 数据持久化 | P0 | 学习进度、用户数据本地存储 |
| 音频播放 | P0 | 接入 audioplayers |
| 真实词汇数据库 | P1 | 从硬编码迁移到 JSON/数据库 |
| 关卡解锁逻辑 | P1 | 根据通关状态动态解锁 |
| 设置功能 | P2 | 通知、语言切换等 |
| 排行榜 | P2 | 用户排名 |
| 成就系统 | P2 | 徽章、积分 |
| 深色模式 | P3 | 主题切换 |
| 多语言支持 | P3 | i18n |

---

## 8. 技术栈

- **框架**：Flutter 3.x
- **状态管理**：StatefulWidget（初期）→ 未来迁移至 Riverpod/Bloc
- **路由**：go_router
- **UI 风格**：粗黑边框 + 硬阴影 + 莫兰迪色系 + 大圆角
- **音频**：audioplayers（预留）
- **存储**：SharedPreferences（预留）

---

*文档由 AI 生成，随项目迭代持续更新。*
