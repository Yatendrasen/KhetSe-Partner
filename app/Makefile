.PHONY: run

PACKAGE=com.mstoreapp.admin1689959727800
BUILD_TYPE="APK"

# create a signed apk
sign:
	flutter pub run flutter_native_splash:create
	flutter pub run flutter_launcher_icons:main
	flutter pub run change_app_package_name:main ${PACKAGE}

	@if [ ${BUILD_TYPE} = "APPBUNDLE" ]; then\
        flutter build appbundle --target-platform android-arm,android-arm64,android-x64;\
    fi

	@if [ ${BUILD_TYPE} = "APK" ]; then\
        flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi;\
    fi

# monitor logs and filter by package name
log:
	adb logcat | grep `adb shell ps | grep ${PACKAGE} | cut -c10-15`

run: sign log
#run: sign install execute log
