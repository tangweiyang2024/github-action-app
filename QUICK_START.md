# 快速开始指南

## 5分钟快速部署流程

### 前置条件
- ✅ 已安装Flutter
- ✅ 已安装Git
- ✅ 拥有GitHub账号

---

### 方法1: 从零开始 (推荐新手)

#### 1. 创建GitHub仓库
```bash
# 访问 https://github.com/new
# 创建新仓库，命名为: flutter-time-display
```

#### 2. 上传代码
```bash
cd D:\study\github-action-app
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/flutter-time-display.git
git branch -M main
git push -u origin main
```

#### 3. 自动构建开始
- 推送完成后，访问仓库的 "Actions" 标签
- 看到 "Flutter Build" 工作流自动运行
- 等待构建完成 (约5-10分钟)

#### 4. 下载产物
- 构建完成后，在Actions页面点击成功的运行
- 在 "Artifacts" 部分下载:
  - `release-apk` - Android安装包
  - `release-web` - Web应用

---

### 方法2: 本地测试

```bash
# 1. 进入应用目录
cd time_display_app

# 2. 安装依赖
flutter pub get

# 3. 运行应用
flutter run

# 4. 构建Web版本
flutter build web --release
```

---

## 验证清单

- [ ] 代码已推送到GitHub
- [ ] GitHub Actions工作流运行成功
- [ ] 已下载Android APK
- [ ] 已下载Web构建产物
- [ ] 本地测试应用运行正常

---

## 下一步

查看 [完整操作流程指南](./DEPLOYMENT_GUIDE.md) 了解详细步骤和故障排除。