跨平台 App（Flutter）Figma 设计交付规范
写这份规范，是为了让Figma和Flutter之间的协作更加顺畅。
核⼼原则是「要像 Widget ⼀样思考」
设计师在绘制界⾯时，请把每⼀个元素都当作⼀个可复⽤、有状态、有参数的 Widget 来对待。
Figma 中的 Components + Auto Layout + Variables/Styles 是⽬前与 Flutter 协作最顺畅的基础。

1. 基准画板与布局核⼼（Auto Layout）
   为了让 App 在不同屏幕尺⼨上都能正常适配，设计师需要放弃绝对定位和随意设定尺⼨的做法。
   应该这样做：
   基准画板推荐使⽤ 375 × 812（iPhone 14/15 逻辑分辨率）或 360 × 800（Android 常⽤基
   准）。
   所有间距（Margin / Padding）必须遵循 4pt 基准⽹格，优先使⽤ 8 的倍数（8、16、24、
   32……）。前端代码中也会建⽴统⼀的 Spacing 规范，避免出现 13px、17px 这类⾮标准间距。
   ⻚⾯中的按钮、列表、卡⽚以及整个⻚⾯⾻架，都应该使⽤ Figma 的 Auto Layout 进⾏包裹，
   并正确设置 Constraints（例如左右拉伸、居中），⽅便前端判断何时使⽤ Expanded 或 Align
   组件。
   例外情况： 纯装饰性图形、插画或背景等⾮交互元素内部可以不强制使⽤ Auto Layout，但其所在
   的⽗容器必须使⽤。
   不建议的做法：
   在画板上凭感觉⾃由拖拽核⼼元素；
   使⽤⾮整数的坐标或尺⼨（例如 Width: 103.4px）。
   Figma 的 Auto Layout 参数（排布⽅向、Gap、Padding）与 Flutter 的 Row、Column、Padding
   属性基本⼀⼀对应，使⽤正确能⼤幅减少前端适配⼯作。
2. 建⽴ Design Tokens 并与 Flutter 主题对⻬
   为了⽀持深⾊模式等特性，需要相对严格的变量映射。
   应该这样做：
   将颜⾊、字体排版、阴影等注册为 Figma 的预设，并使⽤语义化命名（例如 primary/500、
   headlineLarge）。
   Styles（样式）适⽤于所有 Figma 版本，⽤于管理基础颜⾊、字体、阴影。
   Variables（局部变量）强烈推荐使⽤（需专业版），便于管理⽀持 Light / Dark 模式的 Design
   Tokens。
   不建议的做法：
   在设计稿中直接⼿填零散的 HEX ⾊值（例如 #58CC02）；
   凭感觉⾃⾏设置阴影。
   Flutter前端不会将样式写死在代码中，⽽是会把 Figma 中的配置同步到 Flutter 的全局主题，⽐
   如：
   Color Styles / Variables → Flutter ColorScheme / AppColors
   Text Styles → Flutter TextTheme（建议对⻬ Material Design 命名）
   Effect Styles（阴影）→ Flutter BoxShadow
3. 组件化设计（Component-First）与 Variants
   在早期开发阶段，我们主要关注基础 UI/UX，暂不涉及复杂动画。但为了保证交互完整性，设计稿
   中需要体现组件的各种状态。
   应该这样做： 所有交互元素（按钮、输⼊框、卡⽚等）都必须创建为 Component（⺟版组件），并
   使⽤ Variants 构建状态：
   类型（Type）：Primary / Secondary / Outlined
   状态（State）：Default / Focused（输⼊框获焦态） / Pressed（按压态） / Disabled（禁⽤
   态）
   注意：移动端为触屏操作，不存在 Hover 态，普通按钮保留 Default / Pressed / Disabled
   即可。
   尺⼨（Size）：Small / Medium / Large
   不建议的做法： 在⻚⾯中直接复制粘贴按钮。所有样式修改都应在 Design System 的⺟版组件中进
   ⾏。
4. 细节标注与极限边界考量
   前端开发需要清晰准确的信息来实现设计意图。请使⽤ Figma 的 Dev Mode 暴露必要的属性。
   需要标注的内容：
   ⽂本：标明最⼤⾏数（Max Lines），以及溢出时的处理⽅式（截断显⽰省略号，或⾃动缩⼩字
   号）。
   图⽚：标明缩放裁切模式（Fit 模式），例如 contain（包含）、cover（覆盖裁切）、fill（拉
   伸）。
   边缘⻚⾯：必须提供空状态（Empty State）、加载态（Loading）和错误/⽹络异常态（Error）
   的设计稿。
5. 素材规范
   原则是⽮量图优先。
   素材的提供⽅式会直接影响 App 的包体积和不同分辨率下的显⽰效果。
   图标：
   系统级⼩图标优先使⽤ SVG 等web常⽤⽮量格式，具体情况下可以问ai。
   单⾊图标：请合并路径并进⾏轮廓化操作。
   多⾊或品牌图标：保留图层结构，直接导出。
   真实图⽚：
   对于⽆法⽮量化的照⽚或复杂运营图，请按 1x、2x、3x 倍率同时导出 PNG，放⼊
   assets/images/ ⽬录，当然最好不要I出现这种png图⽚。
6. 物理边界 —— 始终考虑 Safe Area
   移动端界⾯并⾮完美矩形，存在刘海、挖孔、底部的导航bar与2安卓三⼤⾦刚键等元素。
   应该这样做：
   在底层画板上预留系统级的刘海遮挡区和底部 Home Indicator 遮挡区。
   所有核⼼交互按钮（例如“继续”按钮）必须放置在安全区域（Safe Area）内部。
   前端会在最外层统⼀使⽤ Flutter 的 SafeArea 组件进⾏处理。
   交付清单（Handoff Checklist）
   设计师在最终交付或通知前端查看前，请按以下内容进⾏⾃查：
   ⻚⾯核⼼元素是否使⽤了 Auto Layout（纯装饰插画除外）？间距是否遵循 4pt/8pt ⽹格？
   颜⾊和字体是否全部绑定了 Styles 或 Variables？是否存在游离的 HEX ⾊值？
   交互按钮是否已封装为 Component？是否移除了 Hover 态，并提供了 Default / Pressed /
   Disabled 等 Variants？
   图标是否放在 24×24 Frame 内导出为 SVG（单⾊与多⾊处理是否正确）？图⽚是否标注了 Fit
   模式？
   关键内容是否避开了系统刘海和底部横条？
   是否提供了深⾊模式、空状态、加载态的独⽴设计？
   ⻚⾯间的跳转关系是否已通过 Prototype 连线或流程图说明清楚？
