# 本地构建指南

## 📱 Android 本地构建

### 🔧 Android 环境要求

#### 必需组件
1. **Android Studio** (包含Android SDK)
   - 下载: https://developer.android.com/studio
   - 安装时勾选 "Android SDK", "Android SDK Platform-Tools"

2. **Java Development Kit (JDK)**
   - JDK 8 或 JDK 11 (推荐JDK 11)
   - Android Studio自带JDK

3. **Android SDK 组件**
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android SDK Platform (Android 13.0/API 33 或更高)

### 🛠️ 环境配置

#### 1. 设置环境变量

**Windows:**
```bash
# 设置 ANDROID_HOME
setx ANDROID_HOME "C:\Users\YourUsername\AppData\Local\Android\Sdk"

# 设置 PATH
setx PATH "%PATH%;%ANDROID_HOME%\platform-tools"
setx PATH "%PATH%;%ANDROID_HOME%\cmdline-tools\latest\bin"
```

**macOS/Linux:**
```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export ANDROID_HOME=$HOME/Library/Android/sdk  # macOS
export ANDROID_HOME=$HOME/Android/Sdk          # Linux
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
```

#### 2. 验证安装

```bash
flutter doctor -v
```

应该看到：
```
✓ Android toolchain - develop for Android devices
    ✓ Android SDK at /path/to/Android/Sdk
    ✓ Platform android-33, build-tools 33.0.0
    ✓ Java binary at: /path/to/java
```

### 📦 构建Android APK

#### 方法1: Release APK (推荐)

```bash
cd time_display_app
flutter build apk --release
```

**输出位置:**
```
build/app/outputs/flutter-apk/app-release.apk
```

**特点:**
- 优化后的代码，体积更小
- 性能更好
- 适合发布和日常使用

#### 方法2: Debug APK

```bash
flutter build apk --debug
```

**输出位置:**
```
build/app/outputs/flutter-apk/app-debug.apk
```

**特点:**
- 包含调试信息
- 体积较大
- 性能较慢
- 仅用于测试

#### 方法3: 分架构APK

```bash
# 为特定架构构建 (体积更小)
flutter build apk --release --split-per-abi
```

**输出多个APK:**
```
app-armeabi-v7a-release.apk    # 32位ARM设备
app-arm64-v8a-release.apk      # 64位ARM设备  
app-x86_64-release.apk         # x86设备 (模拟器)
```

### 🎯 APK安装

#### 通过USB安装
```bash
# 启用USB调试后
adb install build/app/outputs/flutter-apk/app-release.apk

# 替换已安装的版本
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

#### 直接安装
1. 将APK文件复制到手机
2. 在文件管理器中点击APK文件
3. 允许安装未知来源应用
4. 点击安装

### ⚙️ 构建配置

#### 修改应用信息

**编辑 `android/app/src/main/AndroidManifest.xml`:**
```xml
<manifest>
    <application
        android:label="Smart Clock"          # 应用名称
        android:icon="@mipmap/ic_launcher">  # 应用图标
    </application>
</manifest>
```

**编辑 `android/app/build.gradle`:**
```gradle
android {
    defaultConfig {
        applicationId "com.example.smartclock"  # 应用包名
        minSdkVersion 21                       # 最低SDK版本
        targetSdkVersion 33                    # 目标SDK版本
        versionCode 1                          # 版本号
        versionName "1.0.0"                    # 版本名称
    }
}
```

#### 签名配置 (发布到应用商店)

**创建签名密钥:**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**配置签名:**
```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 🚀 构建优化

#### 减小APK体积

```bash
# 压缩资源
flutter build apk --release --split-per-abi

# 启用代码压缩和混淆
android/app/build.gradle:
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

#### 加速构建

```bash
# 使用更多线程
flutter build apk --release --verbose

# 跳过某些检查 (仅用于开发)
flutter build apk --release --no-sound-null-safety
```

### 📊 构建输出示例

```bash
$ flutter build apk --release

Running Gradle task 'assembleRelease'...
Running Gradle task 'assembleRelease'... Done
✓ Built build/app/outputs/flutter-apk/app-release.apk (13.2MB).
```

### 🔍 常见问题

#### 1. SDK版本问题
```
Error: Failed to find SDK version
```
**解决方案:**
```bash
# 在Android Studio中安装所需的SDK版本
# Tools -> SDK Manager -> SDK Platforms
```

#### 2. Gradle下载慢
```bash
# 配置国内镜像
android/build.gradle:
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
    }
}
```

#### 3. 构建失败
```bash
# 清理构建缓存
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
flutter build apk --release
```

#### 4. 签名问题
```
Failed to read key
```
**解决方案:**
- 确认keystore文件路径正确
- 检查密码是否正确
- 验证alias名称匹配

---

## 🌐 Web 本地构建

### 📦 构建Web应用

```bash
cd time_display_app
flutter build web --release
```

**输出位置:**
```
build/web/
```

### 🧪 本地测试Web应用

```bash
# 启动本地服务器
flutter run -d chrome --release

# 或使用其他服务器
cd build/web
python -m http.server 8000
# 访问 http://localhost:8000
```

### 📤 Web部署

#### 1. GitHub Pages
```bash
# 安装gh-cli
# 登录并部署
gh repo clone your-repo
cd your-repo/time_display_app
flutter build web --release
mkdir gh-pages && cp -r build/web/* gh-pages/
git checkout --orphan gh-pages
git add .
git commit -m "Deploy web app"
git push origin gh-pages
```

#### 2. Netlify
```bash
# 拖拽部署
# 直接将 build/web 文件夹拖到 Netlify

# 或使用CLI
npm install -g netlify-cli
netlify deploy --prod --dir=build/web
```

#### 3. Vercel
```bash
npm install -g vercel
cd build/web
vercel --prod
```

#### 4. Firebase Hosting
```bash
npm install -g firebase-tools
firebase init hosting
# 设置: build/web 作为公共目录
firebase deploy
```

---

## 🍎 iOS 本地构建

### 🔧 iOS 环境要求

1. **macOS 系统** (必需)
2. **Xcode** (14.0 或更高)
3. **CocoaPods**
4. **iOS SDK** (14.0 或更高)

### 📦 构建iOS应用

#### 1. 安装依赖

```bash
cd time_display_app/ios
pod install
cd ..
```

#### 2. 构建应用

```bash
# 无签名构建 (开发测试)
flutter build ios --release --no-codesign

# 正式构建 (需要签名)
flutter build ios --release
```

#### 3. 创建IPA文件

```bash
# 无签名构建后创建IPA
mkdir -p build/ipa
cp -r build/ios/iphoneos/Runner.app build/ipa/Payload
cd build/ipa
zip -r ../Runner.ipa .
```

### 📱 iOS安装

#### 模拟器测试
```bash
open -a Simulator
flutter run
```

#### 真机安装
- 需要Apple Developer账号
- 需要代码签名证书
- 通过Xcode安装或使用TestFlight

---

## 🖥️ 桌面平台构建

### Windows

```bash
flutter build windows --release
```

### macOS

```bash
flutter build macos --release
```

### Linux

```bash
flutter build linux --release
```

---

## 📋 构建检查清单

### 构建前检查 ✅
- [ ] `flutter doctor` 显示无错误
- [ ] `flutter pub get` 已执行
- [ ] `flutter analyze` 无问题
- [ ] `flutter test` 测试通过
- [ ] 应用版本号已更新
- [ ] 应用图标已设置
- [ ] 应用名称已确认

### 构建后检查 ✅
- [ ] APK文件生成成功
- [ ] 文件大小合理 (通常 < 50MB)
- [ ] 在模拟器/真机上测试运行
- [ ] 主要功能正常工作
- [ ] 无明显性能问题
- [ ] 应用名称和图标正确

### 发布前检查 ✅
- [ ] 版本号已更新
- [ ] 签名配置正确 (如需发布)
- [ ] 权限声明完整
- [ ] 隐私政策准备 (如需)
- [ ] 应用描述准备
- [ ] 截图和演示视频准备

---

## 🚀 快速构建命令

### Android
```bash
# 快速构建
flutter build apk --release

# 查看输出
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

### Web
```bash
# 快速构建
flutter build web --release

# 查看输出
ls -lh build/web/
```

### iOS
```bash
# 快速构建
flutter build ios --release --no-codesign

# 查看输出
ls -lh build/ios/iphoneos/Runner.app
```

---

## 📞 获取帮助

### 构建失败时
1. 运行 `flutter doctor` 检查环境
2. 执行 `flutter clean` 清理缓存
3. 检查错误日志信息
4. 参考官方文档

### 性能问题
1. 使用 `--verbose` 查看详细日志
2. 检查系统资源使用
3. 关闭不必要的应用
4. 增加系统内存分配

祝您构建顺利！🎉