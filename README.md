# Flutter时间展示应用 - GitHub Actions自动化部署

这是一个使用Flutter开发的实时时钟应用，配备完整的GitHub Actions CI/CD自动化构建流程。

## 📖 文档导航

- **[🚀 快速开始](./QUICK_START.md)** - 5分钟快速部署指南
- **[📋 详细操作流程](./DEPLOYMENT_GUIDE.md)** - 完整的部署和运维指南
- **[📱 应用说明](./time_display_app/README.md)** - Flutter应用功能说明

## 🎯 项目概述

- **应用名称**: 时间展示应用
- **开发框架**: Flutter 3.16.5
- **CI/CD**: GitHub Actions自动化构建
- **支持平台**: Android, iOS, Web

## ✨ 主要功能

- 🕐 **实时时钟**: 每秒自动更新当前时间
- 📅 **日期显示**: 完整显示星期、月份和日期
- 🎨 **现代UI**: Material Design 3设计风格
- 📱 **跨平台**: 支持Android、iOS和Web
- 🔄 **自动构建**: GitHub Actions自动化打包部署

## 🚀 快速开始

### 方法1: 立即部署 (推荐)

```bash
# 1. 创建GitHub仓库
# 访问 https://github.com/new 创建仓库

# 2. 推送代码到GitHub
cd D:\study\github-action-app
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main

# 3. 自动构建开始
# 访问仓库的 "Actions" 标签查看构建进度

# 4. 下载构建产物
# 构建完成后在Actions页面下载APK和Web文件
```

### 方法2: 本地运行

```bash
# 1. 进入应用目录
cd time_display_app

# 2. 安装依赖
flutter pub get

# 3. 运行应用
flutter run
```

## ⚙️ GitHub Actions自动化流程

项目配置了GitHub Actions工作流，自动执行以下任务：

✅ **环境检查** - 验证Flutter安装  
✅ **代码分析** - 运行 `flutter analyze`  
✅ **测试执行** - 运行 `flutter test`  
✅ **APK构建** - 构建Android安装包  
✅ **Web构建** - 构建Web应用  
✅ **产物上传** - 上传构建产物  

### 触发条件

- 推送代码到 `main` 或 `master` 分支
- 创建Pull Request到 `main` 或 `master` 分支

### 下载构建产物

每次成功构建后，可以下载：
- **release-apk**: Android APK安装文件
- **release-web**: Web应用包

访问路径: **Actions** → 选择工作流运行 → **Artifacts** 部分

## 🏗️ 本地构建

### Android APK

```bash
cd time_display_app
flutter build apk --release
```

输出位置: `build/app/outputs/flutter-apk/app-release.apk`

### Web应用

```bash
cd time_display_app
flutter build web --release
```

输出位置: `build/web/` 目录

### iOS应用

```bash
cd time_display_app
flutter build ios --release
```

## 📁 项目结构

```
github-action-app/
├── .github/
│   └── workflows/
│       └── flutter-build.yml    # GitHub Actions工作流配置
├── time_display_app/             # Flutter应用目录
│   ├── lib/
│   │   └── main.dart            # 主应用代码
│   ├── android/                 # Android配置
│   ├── ios/                     # iOS配置
│   ├── web/                     # Web配置
│   └── pubspec.yaml             # 依赖配置
├── README.md                    # 项目说明文件
├── QUICK_START.md              # 快速开始指南
└── DEPLOYMENT_GUIDE.md         # 详细操作流程指南
```

## 📋 环境要求

- **Flutter**: 3.16.5 或更高版本
- **Dart**: 3.2.3 或更高版本
- **开发工具**: Android Studio 或 VS Code (安装Flutter插件)

## 📚 相关文档

- [Flutter官方文档](https://docs.flutter.dev/)
- [GitHub Actions文档](https://docs.github.com/en/actions)
- [Dart语言指南](https://dart.dev/guides)

## 📄 许可证

本项目采用MIT许可证开源。

---

## 💡 获取帮助

如果遇到问题，请：
1. 查看 [详细操作流程指南](./DEPLOYMENT_GUIDE.md)
2. 检查GitHub Actions工作流日志
3. 在仓库创建Issue报告问题