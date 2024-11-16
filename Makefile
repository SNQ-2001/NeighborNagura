# Makefile

# ターゲット: ディレクトリがない場合に作成
Builds:
	mkdir -p UnityProject/Builds

# ターゲット: iOS.zipを解凍してBuildsディレクトリに配置
unzip-ios: iOS.zip | Builds
	unzip -o iOS.zip -d UnityProject/Builds
	find UnityProject/Builds -name "__MACOSX" -type d -exec rm -r {} +

# デフォルトターゲット: unzip-iosを実行
.PHONY: setup
setup: unzip-ios