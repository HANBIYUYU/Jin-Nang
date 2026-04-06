Flutter 开发规范指南 (V2)
本指南的核⼼⽬标是建⽴⼀套统⼀的代码语⾔，减少团队沟通成本，并确保项
⽬在⻓期维护中保持逻辑清晰。

1. 核⼼原则
   遵循 Effective Dart：⼀致性是代码可读性的基础。所有编码⻛格应优先
   参考 官⽅ Effective Dart 指南，这能让新成员更⽆缝地加⼊项⽬。
   单⼀职责原则 (SRP)：复杂的 Widget 难以调试。每个类和⽅法应该只专注
   处理⼀件事情，UI 层⾯应尽量保持“纯粹”，仅负责数据的呈现。
   多验证，少猜测：为了避免后期重构带来的⻛险，在引⼊重型第三⽅库或
   架构⽅案前，必须通过⼩规模 Demo 验证其性能边界。
   Figma 为唯⼀真相源：UI 开发应当是还原⽽⾮再创作。必须严格对⻬
   Figma Token，禁⽌在代码中随意硬编码颜⾊或数值。
2. 命名规范
   2.1 ⽂件与⽬录
   为了确保在不同操作系统下的兼容性，⽂件名统⼀使⽤ snake_case 。
   推荐： user_profile_screen.dart
   不建议： UserProfileScreen.dart
   2.2 类与枚举
   类名代表类型定义，应使⽤ PascalCase （⼤驼峰）。
   2.3 变量与⽅法
   为了与 Dart 核⼼库保持逻辑⼀致，变量与⽅法名使⽤ camelCase （⼩驼
   峰）。
   2.4 常量
   为了符合 Dart 官⽅推荐的现代审美并减少符号冗余，常量应统⼀使⽤
   lowerCamelCase 。
   推荐做法：
   推荐做法： static const double appSpacingMd = 16.0;
   不建议做法： static const double APP_SPACING_MD = 16.0;
3. 项⽬⽬录结构
   推荐使⽤基于功能 (Feature-first) 的结构。这种⽅式在业务膨胀时⽐技术分层
   更易于横向扩展和定位代码。
   lib/
   ├── core/ # 跨模块使⽤的基础设施
   │ ├── network/ # Dio 封装及拦截器
   │ ├── storage/ # 持久化存储
   │ └── utils/ # 纯函数⼯具
   ├── theme/ # 视觉系统 (与 Figma 映射)
   │ ├── app_colors.dart
   │ ├── app_spacing.dart
   │ └── app_theme.dart
   ├── widgets/ # 全局复⽤组件
   ├── features/ # 业务模块
   │ ├── auth/ # 认证模块
   │ │ ├── data/ # 数据源与 Repository
   │ │ ├── logic/ # 状态管理
   │ │ └── auth_screen.dart
   │ └── home/ # ⾸⻚模块
   └── main.dart
4. 代码质量与性能优化
   4.1 静态检查
   ⼯具优于记忆。必须配置 analysis_options.yaml 并引⼊
   flutter_lints 。
   需要注意：应当尽可能处理掉编译器给出的 Warning，保持控制台清洁。
   4.2 性能核⼼：Const
   为了最⼤化复⽤ Element 树并降低内存开销，凡是在编译期能确定的对
   象，推荐强制使⽤ const 关键字。
   4.3 渲染与列表优化
   缩⼩重绘范围：推荐合理拆分局部 Wid 避免在根部频繁调⽤
   缩⼩重绘范围：推荐合理拆分局部 Widget，避免在根部频繁调⽤
   setState 导致整⻚刷新。
   懒加载机制：⻓度不确定的列表必须使⽤ ListView.builder 或
   SliverList.builder 。
   ⻛险提示：禁⽌将潜在的⼤量列表项直接放⼊ Column 或
   ListView(children: []) 中，这会导致严重的内存溢出和滑动卡顿。
5. 状态管理规范
   ⽅案统⼀：为了降低维护成本，项⽬中应只保留⼀种全局状态管理⽅案
   （如 Riverpod 或 BLoC），不建议多套⽅案混⽤。
   逻辑解耦：UI 侧只负责监听状态和发送事件。复杂的业务计算和数据转换
   应当在逻辑层处理。
   解耦 BuildContext：不建议将 BuildContext 传递到逻辑层或⼯具类，
   以保持逻辑层的纯粹性和可测试性。
6. 设计系统实现 (Figma 1:1)
   6.1 Design Tokens
   颜⾊命名应与 Figma 定义完全对⻬，确保开发与设计的沟通语⾔⼀致。
   间距应严格遵循 4pt/8pt ⽹格系统，推荐使⽤预定义的常量，避免出现
   13.5 这种⾮标准数值。
   6.2 组件复⽤
   变体处理：推荐利⽤ Dart 枚举来表达 Figma 中的 Variant（如按钮的⼤
   ⼩、类型）。
   状态驱动：推荐使⽤ onPressed == null 作为按钮禁⽤的唯⼀判定标
   准，避免维护冗余的布尔变量。
7. 异常处理与监控
   全局捕获：需要使⽤ runZonedGuarded 捕获未处理的异步异常。
   线上监控：⽣产环境推荐接⼊ Sentry 或 Firebase Crashlytics，确保在线上
   出现崩溃时能第⼀时间定位。
   结果导向：底层⽅法推荐返回 对象 将错误信息结构化 ⽽不
   结果导向：底层⽅法推荐返回 Result<T> 对象，将错误信息结构化，⽽不
   是直接在各处抛出 Exception。
8. 国际化与资源
   字符串管理：为了⽀持多语⾔扩展，禁⽌在代码中硬编码⽤户可⻅的字符
   串，应统⼀定义在 ARB ⽂件中。
   强类型资源：推荐使⽤ flutter_gen 等⼯具⽣成资源引⽤类，通过
   Assets.images.logo.path 访问资源，避免拼写错误。
9. 路由管理
   路由⽅案：推荐使⽤ go_router 。它提供的声明式路由和深层链接⽀持能
   ⼤幅简化⻚⾯跳转逻辑。
10. Git 提交规范
    推荐遵循 Conventional Commits 规范，清晰的代码记录是项⽬最好的⽇志。
    feat : 新功能 / fix : 修复 Bug / refactor : 重构 / perf : 性能优化 /
    chore : 杂务
11. 状态机模板 (Dart 3)
    为了实现类型安全且⽆遗漏的状态分⽀处理，推荐利⽤ sealed class 配合模
    式匹配：
    sealed class UIState<T> {
    const UIState();
    }
    class UILoading<T> extends UIState<T> {
    const UILoading();
    }
    class UISuccess<T> extends UIState<T> {
    final T data;
    const UISuccess(this.data);
    }
    class UIError<T> extends UIState<T> {
    final String message;
    const UIError(this.message);
    }
    }
    // Widget 构建建议：使⽤ switch 确保分⽀全覆盖
    @override
    Widget build(BuildContext context) {
    return switch (state) {
    UILoading() => const LoadingView(),
    UISuccess(data: var d) => DataView(data: d),
    UIError(message: var m) => ErrorView(msg: m),
    };
    }
