# iOS应用部署完整指南

## 📱 目录
1. [iOS开发环境配置](#ios开发环境配置)
2. [本地构建iOS应用](#本地构建ios应用)
3. [iOS应用签名与证书](#ios应用签名与证书)
4. [GitHub Actions iOS构建详解](#github-actions-ios构建详解)
5. [iOS应用分发](#ios应用分发)
6. [iOS常见问题](#ios常见问题)

---

## 🍎 iOS开发环境配置

### macOS系统要求
- macOS 12 (Monterey) 或更高版本
- Xcode 14.0 或更高版本
- iOS SDK 14.0 或更高版本
- CocoaPods (依赖管理工具)

### 安装Xcode

```bash
# 从Mac App Store安装Xcode
# 或使用命令行工具
xcode-select --install

# 安装完成后，同意许可证
sudo xcodebuild -license accept

# 安装CocoaPods
sudo gem install cocoapod
```

### 配置Flutter iOS环境

```bash
# 检查Flutter环境
flutter doctor

# 如果遇到iOS工具链问题，运行：
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### 修复常见iOS环境问题

```bash
# 清理Flutter缓存
flutter clean

# 更新iOS依赖
cd time_display_app/ios
pod install
cd ..

# 重新获取Flutter依赖
flutter pub get
```

---

## 🛠️ 本地构建iOS应用

### 方法1: 无签名构建 (开发测试)

```bash
cd time_display_app

# 无签名构建 (用于模拟器或越狱设备)
flutter build ios --release --no-codesign

# 输出位置
# build/ios/iphoneos/Runner.app
```

### 方法2: 模拟器构建

```bash
# 列出可用设备
flutter devices

# 为模拟器构建
flutter build ios --simulator

# 在模拟器中运行
flutter run -d "iPhone 14 Pro"
```

### 方法3: 真机构建 (需要证书)

```bash
# 1. 配置证书 (后面详细说明)
# 2. 构建应用
flutter build ios --release

# 3. 找到生成的.app文件
# build/ios/iphoneos/Runner.app

# 4. 创建IPA文件
mkdir -p build/ipa
cp -r build/ios/iphoneos/Runner.app build/ipa/Payload
cd build/ipa
zip -r ../Runner.ipa .
cd ../..
```

---

## 🔐 iOS应用签名与证书

### 开发者账号类型

**Apple Developer Program (付费)**
- 费用: $99/年
- 权限: App Store发布,测试设备安装
- 申请: https://developer.apple.com/programs/enroll/

**Apple ID免费账号**
- 费用: 免费
- 限制: 仅限模拟器，7天有效期
- 适合: 开发测试

### 证书配置步骤

#### 1. 创建App ID

```
1. 访问 https://developer.apple.com/account/
2. Certificates, Identifiers & Profiles
3. Identifiers → App IDs → 点击 "+"
4. 填写信息:
   - Description: Time Display App
   - Bundle ID: com.yourcompany.timeDisplay (显式)
   - Capabilities: 选择需要的功能
5. 注册并保存
```

#### 2. 创建证书

**开发证书 (Development):**
```
1. Certificates → All → 点击 "+"
2. 选择: iOS App Development
3. 创建CSR文件:
   - 打开"钥匙串访问"
   - 证书助理 → 从证书颁发机构请求证书
   - 保存为 CertificateSigningRequest.certSigningRequest
4. 上传CSR文件
5. 下载证书并双击安装
```

**发布证书 (Distribution):**
```
1. Certificates → All → 点击 "+"
2. 选择: iOS App Development 或 App Store and Ad Hoc
3. 同样上传CSR文件
4. 下载并安装
```

#### 3. 创建Provisioning Profile

```
1. Profiles → All → 点击 "+"
2. 选择类型: iOS App Development
3. 选择App ID
4. 选择证书
5. 选择测试设备 (UDID)
6. 命名并生成
7. 下载并安装到Xcode
```

### 在Xcode中配置签名

```bash
# 打开iOS项目
open time_display_app/ios/Runner.xcworkspace

# 在Xcode中:
# 1. 选择 Runner target
# 2. Signing & Capabilities 标签
# 3. 选择你的开发团队
# 4. Bundle Identifier 匹配你的App ID
# 5. 选择 Provisioning Profile
```

---

## ⚙️ GitHub Actions iOS构建详解

### 工作流文件结构

我们的GitHub Actions工作流包含两个独立的任务 (jobs):

```yaml
jobs:
  build-android-web:    # Android和Web构建
    runs-on: ubuntu-latest
    
  build-ios:            # iOS构建
    runs-on: macos-latest  # 必须使用macOS
```

### iOS构建工作流详解

#### 步骤1: 选择macOS运行环境

```yaml
- name: Build iOS (No Codesign)
  working-directory: time_display_app
  run: flutter build ios --release --no-codesign
```

**说明:**
- `macos-latest`: 使用最新的macOS环境
- 包含Xcode和iOS SDK
- 支持CocoaPods

#### 步骤2: 无签名构建

```yaml
- name: Build iOS (No Codesign)
  working-directory: time_display_app
  run: flutter build ios --release --no-codesign
```

**参数说明:**
- `--release`: 发布模式构建
- `--no-codesign`: 跳过代码签名
  - GitHub Actions中没有Apple开发者证书
  - 生成的.app文件可以用于手动签名

#### 步骤3: 创建IPA文件

```yaml
- name: Create iOS IPA
  working-directory: time_display_app
  run: |
    mkdir -p build/ipa
    cp -r build/ios/iphoneos/Runner.app build/ipa/Payload
    cd build/ipa
    zip -r ../Runner.ipa .
    cd ../..
```

**IPA文件结构:**
```
Runner.ipa
└── Payload/
    └── Runner.app/
        ├── Runner (可执行文件)
        ├── Info.plist
        ├── Frameworks/
        └── Resources/
```

#### 步骤4: 上传构建产物

```yaml
- name: Upload iOS Build
  uses: actions/upload-artifact@v4
  with:
    name: release-ios
    path: time_display_app/build/Runner.ipa
```

### 构建时间分析

```
iOS构建流程: ~15-25分钟

├── 环境设置: 2-3分钟
├── 依赖安装: 1-2分钟
├── 代码分析: 1-2分钟
├── 测试运行: 2-3分钟
├── iOS构建: 8-12分钟 (最耗时)
└── IPA创建: 1-2分钟
```

---

## 📲 iOS应用分发

### 分发方式对比

| 方式 | 证书要求 | 设备限制 | 有效期 | 适用场景 |
|-----|---------|---------|-------|---------|
| **App Store** | 发布证书 | 无限制 | 永久 | 公开发布 |
| **TestFlight** | 发布证书 | 10,000测试员 | 90天 | Beta测试 |
| **Ad Hoc** | 发布证书 | 100设备 | 1年 | 企业内测 |
| **开发版** | 开发证书 | 100设备 | 7天 | 开发测试 |
| **越狱安装** | 无签名 | 越狱设备 | 永久 | 个人使用 |

### 方法1: App Store发布

```bash
# 1. 使用Xcode上传
open time_display_app/ios/Runner.xcworkspace

# 在Xcode中:
# 1. 选择 Any iOS Device
# 2. Product → Archive
# 3. 等待Archive完成
# 4. 在Organizer中选择 Distribute App
# 5. 选择 App Store Connect
# 6. 上传应用

# 2. 使用命令行工具 (需要transporter)
xcodebuild -exportArchive \
  -archivePath build/ios/Runner.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist
```

### 方法2: TestFlight测试

```
1. 构建Archive (如上)
2. 在Organizer中选择 Distribute TestFlight
3. 上传到App Store Connect
4. 在App Store Connect中:
   - My Apps → 选择应用 → TestFlight
   - 添加测试员
   - 创建测试组
5. 测试员收到邀请邮件并安装TestFlight App
```

### 方法3: Ad Hoc分发

```bash
# 1. 创建Ad Hoc Provisioning Profile
# 2. 构建时指定Profile
flutter build ios --release \
  --export-options-plist=AdHocExportOptions.plist

# 3. 分发IPA文件
# - 通过邮件发送
# - 使用第三方平台 (如: TestApp, InstallOnAir)
# - 企业MDM服务器
```

### 方法4: 越狱设备安装 (无签名)

```bash
# 1. 下载GitHub Actions生成的IPA
# 2. 设备要求:
#    - 越狱的iOS设备
#    - 安装AppSync Unified插件

# 3. 安装方法:
# 方法A: 使用Filza (推荐)
# - 用Filza打开IPA文件
# - 点击安装
# - 信任开发者证书 (设置→通用→设备管理)

# 方法B: 使用AltDeploy
# - 连接设备到电脑
# - 使用AltDeploy工具安装IPA

# 方法C: 使用Sideloadly (Windows/Mac)
# - 下载Sideloadly
# - 连接设备并安装
# - 需要Apple ID (免费账号可签名7天)
```

### 方法5: 模拟器运行

```bash
# 1. 构建模拟器版本
flutter build ios --simulator

# 2. 查找生成的app
ls build/ios/iphoneos/

# 3. 在模拟器中运行
xcrun simctl install booted build/ios/iphoneos/Runner.app
xcrun simctl launch booted com.example.timeDisplayApp

# 4. 使用Xcode直接运行模拟器
open -a Simulator
flutter run -d "iPhone 14 Pro"
```

---

## 🔍 iOS常见问题

### 问题1: 构建失败 "No profiles for 'com.example.timeDisplayApp' were found"

**原因:** 缺少Provisioning Profile

**解决方案:**
```bash
# 1. 检查Bundle Identifier
grep 'PRODUCT_BUNDLE_IDENTIFIER' time_display_app/ios/Runner.xcodeproj/project.pbxproj

# 2. 修改为你的Bundle ID
# 在Xcode中: Runner → General → Bundle Identifier

# 3. 重新生成Provisioning Profile
# 访问 https://developer.apple.com/account/
```

### 问题2: "Codesign error: code signing is required"

**原因:** 需要代码签名

**解决方案:**
```bash
# 开发阶段使用无签名构建
flutter build ios --release --no-codesign

# 或者配置自动签名
# 在Xcode中: Runner → Signing & Capabilities
# ✅ Automatically manage signing
# 选择你的Team
```

### 问题3: CocoaPods依赖安装失败

**症状:** `pod install` 报错

**解决方案:**
```bash
# 1. 更新CocoaPods
sudo gem install cocoapods

# 2. 清理缓存
pod cache clean --all

# 3. 删除Pods目录
cd time_display_app/ios
rm -rf Pods Podfile.lock

# 4. 重新安装
pod install

# 5. 如果还有问题，更新repo
pod repo update
```

### 问题4: Xcode版本不兼容

**症状:** "The specified Xcode version is not available"

**解决方案:**
```bash
# 1. 检查Xcode版本
xcodebuild -version

# 2. 切换Xcode版本 (如果安装了多个)
sudo xcode-select --switch /Applications/Xcode14.app/Contents/Developer

# 3. 更新到最新Xcode
# 通过Mac App Store更新
```

### 问题5: 模拟器构建无法在真机运行

**原因:** 架构不匹配

**解决方案:**
```bash
# 模拟器版本和真机版本需要分别构建

# 真机版:
flutter build ios --release

# 模拟器版:
flutter build ios --simulator

# 通用版 (包含两种架构):
flutter build ios --release --no-codesign
lipo -create build/ios/iphoneos/Runner.app/Runner build/ios/iphonesimulator/Runner.app/Runner -output build/ios/Runner.app/Runner
```

### 问题6: GitHub Actions iOS构建超时

**症状:** iOS构建超过1小时

**解决方案:**
```yaml
# 在工作流中添加timeout
- name: Build iOS (No Codesign)
  working-directory: time_display_app
  run: flutter build ios --release --no-codesign
  timeout-minutes: 45

# 或优化构建时间:
# 1. 使用缓存
cache: true  # 已在flutter-action中配置

# 2. 跳过不必要的步骤
# 如果不需要测试，可以注释掉测试步骤
```

---

## 📋 iOS构建检查清单

### 开发前检查
- [ ] macOS系统版本 >= 12.0
- [ ] Xcode版本 >= 14.0
- [ ] Flutter SDK已安装iOS工具链
- [ ] `flutter doctor` 显示iOS工具链正常

### 本地构建检查
- [ ] `flutter pub get` 无错误
- [ ] `flutter analyze` 无警告
- [ ] `flutter test` 全部通过
- [ ] iOS依赖已安装 (`pod install`)

### 代码签名检查
- [ ] Apple Developer账号已激活
- [ ] App ID已创建
- [ ] 证书已安装到钥匙串
- [ ] Provisioning Profile已配置
- [ ] Bundle Identifier匹配App ID

### 构建产物检查
- [ ] .app文件生成成功
- [ ] IPA文件创建成功
- [ ] 文件大小合理 (< 50MB)
- [ ] 可以在模拟器中运行

### 分发前检查
- [ ] 应用图标正确
- [ ] 启动屏幕正常
- [ ] 版本号已更新
- [ ] 权限描述已添加
- [ ] 隐私政策已准备

---

## 🎯 快速命令参考

### iOS开发常用命令

```bash
# 环境检查
flutter doctor -v                    # 详细诊断
xcodebuild -version                  # Xcode版本
xcrun simctl list devices            # 列出模拟器

# 依赖管理
cd ios && pod install && cd ..       # 安装iOS依赖
pod update                           # 更新Pods

# 构建
flutter build ios --release          # 真机构建
flutter build ios --simulator        # 模拟器构建
flutter build ios --no-codesign      # 无签名构建

# 运行
flutter run                          # 自动选择设备
flutter run -d "iPhone 14 Pro"       # 指定模拟器
flutter run -d 00008020-001234567890 # 指定真机UDID

# 清理
flutter clean                       # 清理Flutter缓存
cd ios && rm -rf Pods Podfile.lock   # 清理iOS依赖
pod cache clean --all                # 清理Pods缓存
```

---

## 📚 相关资源

- [iOS开发官方文档](https://developer.apple.com/documentation/)
- [Flutter iOS构建指南](https://docs.flutter.dev/deployment/ios)
- [App Store审核指南](https://developer.apple.com/app-store/review/guidelines/)
- [TestFlight测试](https://developer.apple.com/testflight/)

---

**祝你iOS应用发布顺利！🎉**