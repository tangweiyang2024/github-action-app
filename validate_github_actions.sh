#!/bin/bash

# GitHub Actions iOS构建配置验证脚本

echo "🔍 验证GitHub Actions配置..."
echo ""

# 检查工作流文件
echo "1️⃣ 检查GitHub Actions工作流文件..."
if [ -f ".github/workflows/flutter-build.yml" ]; then
    echo "✅ 工作流文件存在"
    
    # 检查是否包含iOS构建
    if grep -q "build-ios:" ".github/workflows/flutter-build.yml"; then
        echo "✅ iOS构建任务已配置"
    else
        echo "❌ iOS构建任务未找到"
    fi
    
    # 检查macOS运行器
    if grep -q "runs-on: macos-latest" ".github/workflows/flutter-build.yml"; then
        echo "✅ macOS运行器已配置"
    else
        echo "❌ macOS运行器未配置"
    fi
    
    # 检查无签名构建
    if grep -q "no-codesign" ".github/workflows/flutter-build.yml"; then
        echo "✅ 无签名构建已配置"
    else
        echo "❌ 无签名构建未配置"
    fi
    
    # 检查IPA创建
    if grep -q "Create iOS IPA" ".github/workflows/flutter-build.yml"; then
        echo "✅ IPA创建步骤已配置"
    else
        echo "❌ IPA创建步骤未找到"
    fi
    
    # 检查iOS产物上传
    if grep -q "release-ios" ".github/workflows/flutter-build.yml"; then
        echo "✅ iOS产物上传已配置"
    else
        echo "❌ iOS产物上传未配置"
    fi
else
    echo "❌ 工作流文件不存在"
fi

echo ""

# 检查Flutter项目
echo "2️⃣ 检查Flutter项目配置..."
if [ -f "time_display_app/pubspec.yaml" ]; then
    echo "✅ Flutter项目配置文件存在"
    
    # 检查项目名称
    if grep -q "time_display_app" "time_display_app/pubspec.yaml"; then
        echo "✅ 项目名称正确"
    fi
else
    echo "❌ Flutter项目配置文件不存在"
fi

# 检查iOS项目
echo "3️⃣ 检查iOS项目配置..."
if [ -d "time_display_app/ios" ]; then
    echo "✅ iOS目录存在"
    
    if [ -f "time_display_app/ios/Runner.xcodeproj/project.pbxproj" ]; then
        echo "✅ Xcode项目文件存在"
    fi
    
    if [ -f "time_display_app/ios/Runner.xcworkspace/contents.xcworkspacedata" ]; then
        echo "✅ Xcode工作空间存在"
    fi
    
    if [ -f "time_display_app/ios/Podfile" ]; then
        echo "✅ CocoaPods配置存在"
    fi
else
    echo "❌ iOS目录不存在"
fi

echo ""

# 检查文档
echo "4️⃣ 检查文档文件..."
if [ -f "IOS_DEPLOYMENT_GUIDE.md" ]; then
    echo "✅ iOS部署指南存在"
else
    echo "❌ iOS部署指南不存在"
fi

echo ""
echo "🎉 验证完成！"
echo ""
echo "📝 下一步操作:"
echo "1. 提交更改: git add . && git commit -m 'Add iOS build support'"
echo "2. 推送到GitHub: git push origin main"
echo "3. 观察GitHub Actions构建: 访问仓库的Actions标签"
echo "4. 下载iOS构建产物: 在成功的Actions运行中下载release-ios"