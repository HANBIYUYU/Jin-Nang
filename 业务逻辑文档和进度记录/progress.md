# 锦囊开发进度日记

> 每次更新后追加，格式：`序号. 日期 时间 — 内容` 简明直接

---

1. 2026-05-13 14:00 — 全局 Bug 修复

   - 修复 7 个文件的已知问题，0 lint 错误
   - 修报错、修布局溢出、修弃用警告
   - 统一 const、圆角、阴影、颜色逻辑

---

2. 2026-05-13 15:00 — 底部导航栏溢出修复

   - 缩小图标/文字/间距，总高从 72px 降到 60px

---

3. 2026-05-13 17:00 — 新增 7 个页面 + 完整交互链

   - 启动页、登录页、注册页
   - 对话练习列表页、关卡答题页（4 关完整数据）
   - 重写词汇学习页（6 词卡片 + 点击高亮 + 解锁机制）
   - 更新路由，打通所有页面导航
   - 生成业务逻辑文档

---

4. 2026-05-13 20:00 — Lint 修复

   - 修报错 2 处

---

5. 2026-05-13 20:39 — 接入 Inter 本地字体

   - 配置 pubspec.yaml 字体映射（Regular/Medium/SemiBold/Bold）
   - 全局 ThemeData 设置 fontFamily + 中文 fallback
   - 移除 google_fonts 依赖

---

6. 2026-05-13 21:21 — 提取公共标题组件

   - 新建 `TitleSection`，统一大标题 + 副标题 + 阴影样式
   - Home / Toolbox 两个页面替换为公共组件，删掉重复代码

---

7. 2026-05-13 21:46 — 修正页面分支结构

   - 新建 `vocab_scene_screen.dart` — 场景选择页（Select a scene）
   - Home Vocab Learning 卡片 → 场景选择 → Restaurant → 词汇学习（6张卡片）→ 闯关
   - Toolbox Restaurant 卡片 → 句子页（原 vocab_card），移除闯关入口
   - 句子页和闯关彻底解耦

---

8. 2026-05-13 22:03 — 重构 vocab 目录结构

   - vocab_learning_screen + vocab_scene_screen → home/vocab_learning/
   - vocab_card_screen → toolbox/toolbox_card.dart（类名 ToolboxCard）
   - 修复回退导航：学习页回到场景选择，句子页回到 Toolbox
   - 删除旧 vocab/ 文件夹

---

9. 2026-05-13 22:14 — 修复 Tab 分支隔离

   - 学习页子路由从 Toolbox Tab 移到 Study Tab
   - Home / 场景选择 / 词汇学习 / 闯关 全部在 Study 分支内
   - Toolbox 仅保留句子页
   - 修复所有页面导航路径

---

10. 2026-05-13 22:28 — 接入音频播放

   - 添加 audioplayers 依赖
   - 注册 assets/audio/ 资源
   - 修复 noodle.mp3 文件名不匹配
   - 词汇卡片点击播放音频，防重复点击，错误静默处理

---

11. 2026-05-13 22:40 — 重写 Toolbox 句子页为 Vocab Battle

   - 标题改为 Vocab Battle，大圆角卡片风格
   - 数据模型扩展：词性、英/中文释义、拼音、例句、关联词（近义/反义/拓展）、短语
   - 两张示例词：米饭、饭店
   - Toggle：关联词 / 短语
   - 关联词分三类标签色（蓝/红/紫）
   - 右上角音量按钮播放音频
   - 底部 Prev / Finish

---

12. 2026-05-13 22:51 — Vocab Battle Finish 回到 Toolbox

   - 最后一页点击 Finish → 回到 Toolbox 页面

---

13. 2026-05-13 22:53 — 统一三页标题高度

   - Home 顶部间距 39 → 9（蓝色小卡片 + 标题对齐 48）
   - Toolbox 顶部间距 69 → 48
   - Profile 已是 48，无需调整

---

14. 2026-05-13 23:08 — 提取 4 个公共组件

   - AppCard：粗边框 + 硬阴影卡片容器
   - AppHeader：返回按钮 + 标题标签 + 可选进度
   - IconContainer：带边框图标方块
   - SelectableCard：带锁定状态的场景/工具卡片
   - 替换 vocab_scene / dialogue_practice / toolbox_card / toolbox_screen
   - Home 顶部间距 9 → 20（因 Yo Alex 卡片需要更往下）

---

15. 2026-05-13 23:22 — 底部导航栏重设计 + 全量图标替换

   - 重写 main_shell：贯穿黑线、选中倾斜动画、本地 PNG 图标
   - SelectableCard 锁定态保留原样文字图标，仅去阴影 + 加锁标
   - Home：fire → fire.png、cup → cup.png、study.png、dialogue_learning.png
   - Profile：头像/统计/设置项全部换本地图标

---

16. 2026-05-13 23:30 — 修复 pubspec 资源路径

   - 移除不存在的 assets/images/Icon-*.png 引用
   - 修正 YAML 缩进，icon 资源改为显式文件列表

---

17. 2026-05-13 23:41 — SelectableCard 锁定态背景互换

   - 锁定态：卡片背景 = 彩色，图标框 = 白色
   - 已解锁：保持不变（卡片白，图标框彩色）
   - 整体 Opacity 0.45 罩灰保留

---

---

18. 2026-05-13 23:55 — SelectableCard 配色全部统一

   - 取消锁定态与解锁态的配色差异
   - 全部统一：卡片背景白色，图标框彩色
   - 锁定态仍保留 Opacity 0.35 罩灰 + 去阴影 + 锁标

---

---

19. 2026-05-14 00:10 — 更新业务逻辑文档

   - 版本 v1.0 → v1.1
   - 更新路由表（Study/Toolbox Tab 分离）
   - 新增 VocabSceneScreen 页面逻辑
   - Vocab Battle 数据模型扩展（词性、释义、例句、关联词、短语）
   - 音频系统从"预留"改为"已接入"
   - 新增公共组件章节（AppCard / AppHeader / IconContainer / SelectableCard）
   - 新增目录结构章节
   - 未实现功能清单增加状态列

---

---

20. 2026-05-14 07:58 — 全局字体统一为 LXGW 文楷

   - 新增 `app_fonts.dart`：集中管理 `AppFonts.primary` / `AppFonts.secondary`
   - `AppTheme` 全局 `fontFamily` 改为 `AppFonts.primary`（LXGWWenKai）
   - pubspec.yaml 注册 LXGWWenKai 三档字重（Light 300 / Regular 400 / Medium 500）
   - 移除 `fontFamilyFallback` 中的系统字体名，避免网络查找
   - 0 lint 错误

---

21. 2026-05-14 08:01 — 修复全局字体：英文 Inter + 中文 LXGW 文楷

   - 原因：LXGW 文楷字体文件内部 family name 为 "LXGW WenKai"（带空格），pubspec 写错导致字体全失效
   - `AppFonts` 拆分：`english = 'Inter'`, `chinese = 'LXGW WenKai'`
   - `AppTheme`：fontFamily = Inter, fallback = ['LXGW WenKai']，实现英文 Inter、中文 LXGW 自动分发
   - pubspec.yaml 修正 family name，补充 Inter Medium / SemiBold / Italic
   - 清理字体文件：从 40+ 个减少到 9 个（Inter 6 + LXGW 3）
   - 0 lint 错误

---

22. 2026-05-14 08:41 — 修复 streak 字体回退

   - `TextSpan` 不继承 ThemeData 字体，显式指定 fontFamily

---

23. 2026-05-14 08:45 — 统一顶部安全间距

   - 新建 `AppSafeArea`，10 个页面统一替换

---

24. 2026-05-14 08:53 — 统一顶部留白和返回键样式

   - 所有页面顶部留白 48dp，返回键统一 44×44 粗边框硬阴影

---

25. 2026-05-14 09:01 — 卡片式右滑转场动画

   - `_slidePage` helper，5 个子页面套用

---

26. 2026-05-14 16:34 — 统一按钮按下效果 + 音效

   - 新建 `Pressable` 组件，全项目替换 GestureDetector / InkWell

---

27. 2026-05-14 16:50 — 重写 Pressable 组件

   - `ValueNotifier` 替代 `setState`，彻底解决销毁时崩溃
   - 新增 `PressFeedback` 配置类、触觉反馈、长按支持、`_pressId` 防竞态
   - `ButtonSounds` 改为单例，支持资源释放

---

28. 2026-05-14 17:31 — dialogue 文件夹移入 home

   - `features/dialogue/` → `features/home/dialogue/`
   - 更新 `main.dart` import 路径，0 lint 错误

---

29. 2026-05-14 18:07 — 启动页渐变 + 导航栏改版

   - 启动页：延迟 2 秒后 800ms 快速渐变消失，第 3 秒跳转
   - 导航栏：手动精调，图标框选中 65 / 未选中 56，图标选中 28 / 未选中 22，上移超出黑线，去圆角, 改善倾斜动画 ,完美还原

---

30. 2026-05-15 — 确立前后端分离架构

   - 后端选型：Cloudflare Workers（Hono）+ D1（SQLite）+ R2（对象存储）
   - 放弃 SharedPreferences 本地持久化，数据全部走后端
   - 明确前后端数据边界：
     - 打包进 App：按钮音效、字体、UI 图标
     - 走后端：用户数据、场景/词汇/关卡内容、用户进度、词汇音频
   - 音频策略：词汇音频存 R2，flutter_cache_manager 管理本地缓存，首次播放下载，后续离线可用
   - 定义 API 路由（/auth、/scenes、/vocab、/levels、/user/progress）
   - 规划 Flutter 目标目录结构（core/network、core/audio、features/*/data）
   - 更新 business_logic.md v1.2、CLAUDE.md

---

31. 2026-05-15 — 前后端接入、后端部署、仓库整理

   - 完成前端全部屏幕的硬编码剥离，接入 CF Workers API
   - 后端完整部署：D1 建表+种子数据、R2 音频上传、Worker 上线
   - 自定义域名 jntest.lonnet.uk 绑定至 Worker
   - JWT 认证链路验证通过（register / login / me / scenes / vocab / levels）
   - 修复 hono/jwt 在 CF Workers 下的兼容问题，改用 Web Crypto 自实现
   - Profile 屏幕接入 /auth/me，展示真实用户数据
   - Dio 401 拦截器：token 失效自动清除并跳回登录页
   - SelectableCard 新增 onLockedTap，锁定视觉与点击响应解耦
   - 锁定场景点击弹出 "coming soon" 提示
   - 仓库结构整理：backend/ 新增 migrations/、README.md，清除无效文件

---

## 纯展示 / 逻辑未完成清单

> 记录当前界面上已渲染但无实际功能或数据链路不完整的部分，供后续开发参考。

### Profile 页

| 元素 | 现状 | 缺失 |
|------|------|------|
| 用户名 / 等级 / Rank | 从 /auth/me 读取，只读 | 无编辑入口，无 PATCH 接口 |
| 头像 | 静态图标 | 无上传，无更换 |
| Logout | 不存在 | 需要清 token 并跳回登录页 |
| Notifications | 点击无响应 | 纯占位 |
| Language Settings | 点击无响应 | 纯占位 |
| Help & FAQ | 点击无响应 | 纯占位 |

### HomeScreen 任务卡

| 元素 | 现状 | 缺失 |
|------|------|------|
| Dialogue Practice 快捷入口 | 跳到场景选择页，和 Vocab Learning 一样 | 应直接进入对话练习，需产品确认流程 |
| Words learned 副标题 | 显示 total_words_seen，从 API 读 | 数值仅在关卡完成时更新，不反映单词学习进度 |

### 数据与业务逻辑

| 项目 | 现状 | 缺失 |
|------|------|------|
| streak_days | 始终为 0 | 无每日签到 / 学习触发的 streak 更新逻辑 |
| rank | 始终为 Bronze | 无升级规则，无触发时机 |
| total_words_seen | 关卡完成时粗略累加 | 未按实际学过的词计算，user_vocab_seen 表从未写入 |
| 关卡 Continue 按钮 | 点击返回对话练习列表 | 无"进入下一关"逻辑，无整体通关流程 |
| 词汇学习完成 | 点完所有卡片可进入下一步 | 离开页面后学习记录重置，user_vocab_seen 未记录 |

### 音频

| 项目 | 现状 | 缺失 |
|------|------|------|
| 词汇音频缓存 | flutter_cache_manager + DeviceFileSource 代码已接入 | 未在真机验证，Web 平台不支持 DeviceFileSource |
| 按钮音效 | AssetSource 正常 | — |

### 场景与内容

| 项目 | 现状 | 缺失 |
|------|------|------|
| Supermarket / Airport | 场景存在于 DB，点击显示 coming soon | 无词库、无关卡数据 |
| 关卡解锁 | 后端 POST /user/progress 触发解锁下一关 | 前端结果页通过后未刷新关卡列表状态 |

---

*（下次更新请在此下方继续追加）*
