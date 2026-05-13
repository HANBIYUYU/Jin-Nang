# 锦囊开发进度日记

> 每次更新后追加，格式：`序号. 日期 时间 — 内容`

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

*（下次更新请在此下方继续追加）*
