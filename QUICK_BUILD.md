# 本地构建快速指南

## 🚀 立即开始本地构建

### 📱 构建Android APK

由于当前环境Android SDK配置不完整，推荐以下解决方案：

#### 方案1: 使用GitHub Actions (推荐)

```bash
# 1. 提交代码到GitHub
git add .
git commit -m "Ready for Android build"
git push origin main

# 2. 等待GitHub Actions自动构建完成
# 3. 在GitHub页面下载APK:
#    仓库 -> Actions -> Flutter Build -> Artifacts -> release-apk
```

#### 方案2: 配置完整Android环境

```bash
# 1. 安装Android Studio
#    下载: https://developer.android.com/studio

# 2. 在Android Studio中安装SDK
#    Tools -> SDK Manager -> 安装以下组件:
#    - Android SDK Build-Tools
#    - Android SDK Platform-Tools  
#    - Android SDK Platform 13.0+ (API 33+)

# 3. 配置环境变量
setx ANDROID_HOME "C:\Users\YourName\AppData\Local\Android\Sdk"
setx PATH "%PATH%;%ANDROID_HOME%\platform-tools"
setx PATH "%PATH%;%ANDROID_HOME%\cmdline-tools\latest\bin"

# 4. 验证安装
flutter doctor -v

# 5. 构建APK
cd time_display_app
flutter build apk --release

# 6. 找到APK文件
# 输出位置: build/app/outputs/flutter-apk/app-release.apk
```

### 🌐 构建Web应用 (当前可用)

```bash
# 1. 进入应用目录
cd time_display_app

# 2. 构建Web应用
flutter build web --release

# 3. 本地测试
cd build/web
python -m http.server 8000
# 浏览器访问: http://localhost:8000

# 4. 构建文件位置
# 输出目录: build/web/
# 主要文件: index.html, main.dart.js, assets/
```

### 🍎 构建iOS应用 (需要macOS)

```bash
# 仅在macOS系统上可用
cd time_display_app
flutter build ios --release --no-codesign

# 输出位置: build/ios/iphoneos/Runner.app
```

---

## 📦 构建产物使用

### Android APK安装

#### 通过USB安装
```bash
# 启用开发者选项和USB调试后
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### 直接安装
1. 将APK复制到手机
2. 在文件管理器中点击APK
3. 允许安装未知来源应用
4. 点击安装

### Web应用部署

#### 本地测试
```bash
# 方法1: 使用Python
cd build/web && python -m http.server 8000

# 方法2: 使用Node.js
npx http-server build/web

# 方法3: 使用PHP
php -S localhost:8000 -t build/web
```

#### 部署到服务器
```bash
# 1. Netlify (最简单)
# 直接将 build/web 文件夹拖到 https://netlify.com/drop

# 2. GitHub Pages
gh repo clone your-repo
cd your-repo
git checkout --orphan gh-pages
cp -r time_display_app/build/web/* .
git add .
git commit -m "Deploy web app"
git push origin gh-pages

# 3. Vercel
npm install -g vercel
cd time_display_app/build/web
vercel --prod
```

---

## ⚡ 快速构建命令参考

### 当前环境可用

```bash
# ✅ Web构建 (立即可用)
flutter build web --release

# ✅ 代码检查
flutter analyze

# ✅ 运行测试
flutter test

# ✅ 本地运行Web
flutter run -d chrome
```

### 需要完整Android环境

```bash
# ⚠️ Android构建 (需要配置Android SDK)
flutter build apk --release

# ⚠️ 调试版本
flutter build apk --debug

# ⚠️ 分架构构建 (体积更小)
flutter build apk --release --split-per-abi
```

### 需要macOS环境

```bash
# ⚠️ iOS构建 (需要macOS)
flutter build ios --release --no-codesign
```

---

## 🔧 环境问题解决

### Android SDK问题

当前环境显示:
```
✗ Android toolchain - develop for Android devices
  ✗ ANDROID_HOME = C:\Android\sdk
    but Android SDK not found at this location
```

#### 解决方案:

**选项1: 使用Android Studio (推荐)**
```bash
1. 下载Android Studio: https://developer.android.com/studio
2. 安装时选择完整安装
3. 在Android Studio中: Tools -> SDK Manager
4. 安装Android 13.0+ (API 33+)
5. 重新打开命令行，运行: flutter doctor
```

**选项2: 使用GitHub Actions**
```bash
# 无需本地Android环境
# 推送代码后自动构建APK
git push origin main
```

### Web构建成功 ✅

当前Web构建已成功完成:
```bash
✓ Built build/web/
  - index.html (1.9K)
  - main.dart.js (2.1M) 
  - flutter.js (15K)
  - assets/ (图标和资源)
```

---

## 📊 构建时间参考

基于当前环境的构建时间:

| 平台 | 构建时间 | 状态 | 方法 |
|-----|---------|------|------|
| **Web** | ~20秒 | ✅ 可用 | `flutter build web --release` |
| **Android** | ~3-5分钟 | ⚠️ 需配置 | 需要完整Android SDK |
| **iOS** | ~5-8分钟 | ⚠️ 需macOS | 需要macOS + Xcode |

---

## 🎯 推荐构建流程

### 当前最快方案

```bash
# 1. 开发和测试 (当前可用)
flutter run -d chrome          # 本地Web测试
flutter build web --release    # 构建Web版本

# 2. 获取Android APK
git push origin main           # 推送到GitHub
# 等待GitHub Actions构建完成
# 在GitHub页面下载APK

# 3. 部署Web应用
cd build/web
python -m http.server 8000     # 本地测试
# 或部署到 Netlify/Vercel/GitHub Pages
```

---

## 💡 构建技巧

### 加速构建
```bash
# Web构建优化
flutter build web --release --web-renderer canvaskit

# 减少构建时间
flutter build web --release --no-tree-shake-icons
```

### 构建验证
```bash
# 构建前检查
flutter analyze     # 代码分析
flutter test        # 运行测试
flutter doctor -v   # 环境检查

# 构建后验证
ls -lh build/web/   # 检查输出文件
```

### 清理缓存
```bash
# 清理Flutter缓存
flutter clean

# 清理并重新获取依赖
flutter pub get

# 清理构建文件
rm -rf build/
```

---

## 📞 获取构建产物

### GitHub Actions (推荐Android)

```bash
# 1. 推送代码
git push origin main

# 2. 访问GitHub页面
# https://github.com/YOUR_USERNAME/YOUR_REPO/actions

# 3. 等待构建完成 (~5-10分钟)

# 4. 下载产物
# Actions -> Flutter Build -> 最新成功运行 -> Artifacts
# - release-apk: Android安装包
# - release-web: Web应用
# - release-ios: iOS应用
```

### 本地Web构建

```bash
# 立即可用
flutter build web --release

# 输出文件就在这里:
# time_display_app/build/web/
```

---

**总结**: 
- ✅ **Web构建**: 当前环境完全支持，立即可用
- ⚠️ **Android构建**: 需要配置Android SDK或使用GitHub Actions
- ⚠️ **iOS构建**: 需要macOS环境

**推荐方案**: 使用GitHub Actions自动构建所有平台，本地主要进行开发和Web测试！🚀