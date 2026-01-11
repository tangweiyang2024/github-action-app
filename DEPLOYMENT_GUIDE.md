# Flutter时间展示应用 - 完整操作流程指南

## 📋 目录
1. [环境准备](#环境准备)
2. [本地开发与测试](#本地开发与测试)
3. [Git仓库配置](#git仓库配置)
4. [GitHub Actions自动化部署](#github-actions自动化部署)
5. [产物下载与部署](#产物下载与部署)
6. [常见问题解决](#常见问题解决)

---

## 🔧 环境准备

### 1. 安装Flutter SDK

**Windows:**
```bash
# 下载Flutter SDK
# 访问 https://docs.flutter.dev/get-started/install/windows
# 下载并解压到指定目录，如 C:\flutter

# 添加环境变量
# 将 C:\flutter\bin 添加到PATH

# 验证安装
flutter --version
flutter doctor
```

**macOS:**
```bash
# 使用Homebrew安装
brew install --cask flutter

# 验证安装
flutter --version
flutter doctor
```

**Linux:**
```bash
# 下载并解压Flutter SDK
cd ~/development
wget https://storage.flutter-io.cn/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz
tar xf flutter_linux_3.16.5-stable.tar.xz

# 添加环境变量到 ~/.bashrc
export PATH="$PATH:$HOME/development/flutter/bin"

# 验证安装
flutter --version
flutter doctor
```

### 2. 安装开发工具

- **IDE推荐**: VS Code + Flutter插件 或 Android Studio
- **Git**: 最新版本
- **浏览器**: Chrome (用于Web开发和测试)

### 3. 平台特定配置

**Android开发:**
```bash
# 安装Android Studio
# 配置Android SDK
# 接受许可证
flutter doctor --android-licenses
```

---

## 💻 本地开发与测试

### 步骤1: 获取项目代码

```bash
# 如果是克隆远程仓库
git clone <your-repository-url>
cd github-action-app

# 或者使用本地已有项目
cd D:\study\github-action-app
```

### 步骤2: 进入应用目录

```bash
cd time_display_app
```

### 步骤3: 安装依赖

```bash
flutter pub get
```

### 步骤4: 代码分析

```bash
# 检查代码质量和潜在问题
flutter analyze
```

**预期输出:**
```
Analyzing time_display_app...
No issues found!
```

### 步骤5: 运行测试

```bash
flutter test
```

**预期输出:**
```
00:00 +0: Time display app smoke test
00:00 +1: All tests passed!
```

### 步骤6: 本地运行应用

**在Chrome浏览器中运行:**
```bash
flutter run -d chrome
```

**在Android模拟器/设备上运行:**
```bash
# 查看可用设备
flutter devices

# 运行应用
flutter run
```

**在桌面平台运行 (Windows/macOS/Linux):**
```bash
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

### 步骤7: 本地构建

**构建Web版本:**
```bash
flutter build web --release
```

**构建Android APK:**
```bash
flutter build apk --release
```

**构建iOS应用 (需要macOS):**
```bash
flutter build ios --release
```

---

## 🚀 Git仓库配置

### 步骤1: 初始化Git仓库 (如果未初始化)

```bash
cd D:\study\github-action-app
git init
```

### 步骤2: 创建 .gitignore 文件

如果项目根目录还没有 .gitignore，创建一个：

```bash
# 在项目根目录创建 .gitignore
cat > .gitignore << EOL
# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# VS Code
.vscode/
EOL
```

### 步骤3: 添加文件到Git

```bash
git add .
```

### 步骤4: 查看状态

```bash
git status
```

### 步骤5: 提交更改

```bash
git commit -m "Initial commit: Flutter time display app with GitHub Actions"
```

### 步骤6: 创建GitHub仓库

**方法A: 通过GitHub网页创建**
1. 访问 https://github.com/new
2. 输入仓库名称 (如: `flutter-time-display-app`)
3. 选择Public或Private
4. 不要初始化README (我们已有本地代码)
5. 点击"Create repository"

**方法B: 使用GitHub CLI (如果已安装gh)**
```bash
gh repo create flutter-time-display-app --public --source=. --remote=origin --push
```

### 步骤7: 连接本地仓库到GitHub

```bash
# 添加远程仓库 (替换为你的仓库URL)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# 或者使用SSH
git remote add origin git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git

# 验证远程仓库
git remote -v
```

### 步骤8: 推送到GitHub

```bash
# 推送到main分支
git branch -M main
git push -u origin main

# 或者推送到master分支
git branch -M master
git push -u origin master
```

### 步骤9: 验证推送成功

访问你的GitHub仓库页面，确认：
- 所有文件已上传
- `.github/workflows/flutter-build.yml` 文件存在
- `time_display_app/` 目录存在

---

## ⚙️ GitHub Actions自动化部署

### 步骤1: 理解工作流程

GitHub Actions工作流位于 `.github/workflows/flutter-build.yml`，包含以下步骤：

1. **代码检出**: 获取最新代码
2. **环境设置**: 配置Flutter SDK
3. **依赖安装**: 安装项目依赖
4. **代码分析**: 运行 `flutter analyze`
5. **测试执行**: 运行 `flutter test`
6. **APK构建**: 构建Android发布版本
7. **Web构建**: 构建Web发布版本
8. **产物上传**: 上传构建产物

### 步骤2: 触发工作流

**自动触发条件:**
- 代码推送到 `main` 或 `master` 分支
- 创建Pull Request到 `main` 或 `master` 分支

**手动触发:**
1. 访问GitHub仓库页面
2. 点击 "Actions" 标签
3. 选择 "Flutter Build" 工作流
4. 点击 "Run workflow" 按钮
5. 选择分支并点击运行

### 步骤3: 监控工作流运行

**查看运行状态:**
```bash
# 使用GitHub CLI
gh run list

# 查看最新运行
gh run view

# 查看特定运行
gh run view RUN_ID
```

**通过网页查看:**
1. 访问仓库的 "Actions" 标签
2. 点击最近的工作流运行
3. 查看每个步骤的详细日志

### 步骤4: 工作流文件详解

```yaml
name: Flutter Build                    # 工作流名称

on:                                    # 触发条件
  push:
    branches: [ main, master ]         # 推送到这些分支时触发
  pull_request:
    branches: [ main, master ]         # PR到这些分支时触发

jobs:                                  # 定义任务
  build:                               # 任务名称
    runs-on: ubuntu-latest             # 运行环境
    
    steps:                             # 任务步骤
    - uses: actions/checkout@v4       # 1. 检出代码
    
    - name: Setup Flutter              # 2. 设置Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.5'
        channel: 'stable'
        cache: true                    # 启用缓存加速
    
    - name: Install dependencies       # 3. 安装依赖
      working-directory: time_display_app
      run: flutter pub get
    
    - name: Analyze code               # 4. 代码分析
      working-directory: time_display_app
      run: flutter analyze
    
    - name: Run tests                  # 5. 运行测试
      working-directory: time_display_app
      run: flutter test
    
    - name: Build APK                  # 6. 构建APK
      working-directory: time_display_app
      run: flutter build apk --release
    
    - name: Build Web App              # 7. 构建Web
      working-directory: time_display_app
      run: flutter build web --release
    
    - name: Upload APK                 # 8. 上传APK
      uses: actions/upload-artifact@v4
      with:
        name: release-apk
        path: time_display_app/build/app/outputs/flutter-apk/app-release.apk
    
    - name: Upload Web Build           # 9. 上传Web
      uses: actions/upload-artifact@v4
      with:
        name: release-web
        path: time_display_app/build/web
```

---

## 📦 产物下载与部署

### 步骤1: 查看构建产物

**通过网页:**
1. 访问仓库的 "Actions" 标签
2. 点击成功的工作流运行
3. 滚动到页面底部的 "Artifacts" 部分
4. 可看到两个产物:
   - `release-apk`: Android安装包
   - `release-web`: Web应用包

**通过GitHub CLI:**
```bash
# 列出工作流运行的产物
gh run view RUN_ID --log

# 下载特定产物
gh run download RUN_ID -n release-apk
gh run download RUN_ID -n release-web
```

### 步骤2: 下载Android APK

**方法A: 通过网页下载**
1. 在Artifacts部分找到 `release-apk`
2. 点击下载按钮
3. 解压下载的ZIP文件
4. 获取 `app-release.apk` 文件

**方法B: 使用命令行**
```bash
# 下载最新的APK产物
gh run download --name release-apk

# 或指定特定运行
gh run download RUN_ID --name release-apk
```

### 步骤3: 部署Android APK

**安装到设备:**
```bash
# 通过USB安装
adb install app-release.apk

# 卸载旧版本后安装
adb install -r app-release.apk
```

**分发APK:**
- 直接分享APK文件
- 上传到Google Play Store
- 使用第三方分发平台 (如: GitHub Releases)

### 步骤4: 部署Web应用

**方法A: 本地测试**
```bash
# 解压release-web产物
unzip release-web.zip

# 使用Python启动本地服务器
cd release-web
python -m http.server 8000

# 访问 http://localhost:8000
```

**方法B: 部署到静态网站托管**

**GitHub Pages:**
```bash
# 1. 创建gh-pages分支
git checkout --orphan gh-pages
git clean -fdx

# 2. 复制Web构建产物
cp -r time_display_app/build/web/* .

# 3. 提交并推送
git add .
git commit -m "Deploy web app"
git push origin gh-pages

# 4. 在GitHub仓库设置中启用GitHub Pages
# Settings > Pages > Source: gh-pages branch
```

**Netlify:**
1. 访问 https://netlify.com
2. 拖放 `release-web` 文件夹到部署区域
3. 获得部署URL

**Vercel:**
```bash
# 安装Vercel CLI
npm install -g vercel

# 部署
cd release-web
vercel --prod
```

**Firebase Hosting:**
```bash
# 安装Firebase CLI
npm install -g firebase-tools

# 初始化项目
firebase init hosting

# 部署
firebase deploy --only hosting
```

### 步骤5: 创建GitHub Release (可选)

```bash
# 使用GitHub CLI创建Release
gh release create v1.0.0 \
  --title "Time Display App v1.0.0" \
  --notes "First release of Flutter Time Display App"

# 为Release添加文件
gh release upload v1.0.0 app-release.apk
```

---

## 🔍 常见问题解决

### 问题1: Flutter环境未配置

**症状:**
```
flutter: command not found
```

**解决方案:**
```bash
# 确认Flutter已添加到PATH
echo $PATH

# 手动添加 (临时)
export PATH="$PATH:/path/to/flutter/bin"

# 永久添加 (编辑 ~/.bashrc 或 ~/.zshrc)
echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### 问题2: GitHub Actions工作流失败

**症状:** Actions标签显示红色❌

**解决方案:**
1. 点击失败的工作流查看详细日志
2. 常见原因:
   - 依赖安装失败: 检查 `pubspec.yaml`
   - 测试失败: 检查测试代码
   - 构建失败: 检查平台配置

### 问题3: 构建产物下载失败

**症状:** Artifacts无法下载或下载后文件损坏

**解决方案:**
```bash
# 使用GitHub CLI重新下载
gh run download RUN_ID --name release-apk

# 验证APK文件
aapt dump badging app-release.apk
```

### 问题4: 本地Web构建失败

**症状:** `flutter build web` 报错

**解决方案:**
```bash
# 清除构建缓存
flutter clean

# 重新获取依赖
flutter pub get

# 重新构建
flutter build web --release
```

### 问题5: Git推送失败

**症状:** `git push` 被拒绝

**解决方案:**
```bash
# 拉取远程更新
git pull origin main --rebase

# 解决冲突后推送
git push origin main

# 或强制推送 (谨慎使用)
git push origin main --force
```

---

## 📝 快速参考命令

### 本地开发
```bash
cd time_display_app
flutter pub get          # 安装依赖
flutter run              # 运行应用
flutter test             # 运行测试
flutter analyze          # 代码分析
flutter build web        # 构建Web
flutter build apk        # 构建APK
```

### Git操作
```bash
git status               # 查看状态
git add .                # 添加更改
git commit -m "msg"      # 提交
git push origin main     # 推送
```

### GitHub操作
```bash
gh run list              # 查看工作流
gh run download          # 下载产物
gh release create        # 创建Release
```

---

## 🎯 完整工作流程总结

1. **开发阶段**
   - 在本地修改代码
   - 运行 `flutter analyze` 和 `flutter test`
   - 使用 `flutter run` 本地测试

2. **提交阶段**
   - `git add .`
   - `git commit -m "描述"`
   - `git push origin main`

3. **自动构建阶段**
   - GitHub Actions自动触发
   - 运行测试和分析
   - 构建APK和Web版本
   - 上传构建产物

4. **部署阶段**
   - 下载构建产物
   - 安装APK到设备
   - 部署Web到服务器

---

## 📞 获取帮助

- **Flutter文档**: https://docs.flutter.dev/
- **GitHub Actions文档**: https://docs.github.com/en/actions
- **项目Issues**: 在仓库创建Issue报告问题

---

**祝你使用愉快！🎉**