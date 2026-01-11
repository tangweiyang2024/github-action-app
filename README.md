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

## GitHub Actions Workflow

The project includes a GitHub Actions workflow that automatically:

✅ Validates Flutter installation  
✅ Runs code analysis (`flutter analyze`)  
✅ Executes tests (`flutter test`)  
✅ Builds Android APK  
✅ Builds Web application  
✅ Uploads build artifacts  

### Workflow Triggers

- Push to `main` or `master` branch
- Pull requests to `main` or `master` branch

### Accessing Build Artifacts

After each successful workflow run, you can download:
- **release-apk**: Android APK file
- **release-web**: Web application bundle

Navigate to: **Actions** → Select a workflow run → **Artifacts** section

## Building Locally

### Android APK

```bash
cd time_display_app
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Web App

```bash
cd time_display_app
flutter build web --release
```

Output: `build/web/` directory

### iOS App

```bash
cd time_display_app
flutter build ios --release
```

## Project Structure

```
github-action-app/
├── .github/
│   └── workflows/
│       └── flutter-build.yml    # GitHub Actions workflow
├── time_display_app/             # Flutter application
│   ├── lib/
│   │   └── main.dart            # Main app code
│   ├── android/                 # Android configuration
│   ├── ios/                     # iOS configuration
│   ├── web/                     # Web configuration
│   └── pubspec.yaml             # Dependencies
└── README.md                    # This file
```

## Requirements

- **Flutter**: 3.16.5 or higher
- **Dart**: 3.2.3 or higher
- **Android Studio** / **VS Code** (with Flutter extension)

## License

This project is open source and available under the MIT License.