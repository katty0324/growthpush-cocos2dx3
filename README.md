Growth Push SDK for Cocos2d-x 3.x
===================

![Growth Push](https://growthpush.com/) is the easiest way to implement push notification and analyzes your notification for smart devices.

## Build sample project

```bash
git clone https://github.com/SIROK/growthpush-cocos2dx3.git
cd ./growthpush-cocos2dx3/ ; git submodule update --init --recursive
cd ./submodules/cocos2d-x/ ; ./download-deps.py
cd ../../ ; open sample/proj.ios_mac/sample.xcodeproj
```

## Install

### iOS

1. Copy Classes/GrowthPush to /path/to/your_project/Classes/
1. Copy growthpush-ios/GrowthPush.framework to /path/to/your_project/proj.ios/Frameworks/
1. Add Classes/GrowthPush and GrowthPush.framework to Xcode project.

### Android

1. Copy following jar files to /path/to/your_project/proj.android/libs/
  - android-support-v4.jar
  - google-play-services.jar
  - growthpush.jar
1. Copy proj.android/* to /path/to/your_project/proj.android/
1. Edit AndroidManifest.xml
1. Edit Android.mk
1. Pass Context to GrowthPushJNI

How to edit AndroidManifest.xml.

```xml
<application android:label="@string/app_name"
    android:icon="@drawable/icon">
    <!-- ... -->
    <activity android:name="com.growthpush.view.AlertActivity" 
              android:configChanges="orientation|keyboardHidden"
              android:launchMode="singleInstance"
              android:theme="@android:style/Theme.Translucent" />

    <receiver android:name="com.growthpush.cocos2dx.Cocos2dxBroadcastReceiver" android:permission="com.google.android.c2dm.permission.SEND" >
            <intent-filter>
                    <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                    <action android:name="com.google.android.c2dm.intent.REGISTRATION" />
                    <category android:name="YOUR_PACKAGE_NAME" />
            </intent-filter>
    </receiver>
</application>

<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.GET_ACCOUNTS" />
<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<permission android:name="YOUR_PACKAGE_NAME.permission.C2D_MESSAGE" android:protectionLevel="signature" />
<uses-permission android:name="YOUR_PACKAGE_NAME.permission.C2D_MESSAGE" />
```

How to edit Android.mk.

```bash
LOCAL_SRC_FILES := ../../Classes/GrowthPush/android/GrowthPush.cpp 
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../cocos2d/cocos/ \
                    $(LOCAL_PATH)/../../cocos2d/cocos/base/ \
                    $(LOCAL_PATH)/../../cocos2d/external/ \
                    $(LOCAL_PATH)/../../Classes/GrowthPush 
```

How to pass Context to GrowthPushJNI.

```java
public class AppActivity extends Cocos2dxActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GrowthPushJNI.setContext(getApplicationContext());
  }
}
```

Easier way is adding GrowthPushCocos2dxActivity instead of AppActivity to AndroidManifest.xml as LAUNCHER

```
<activity android:name="com.growthpush.cocos2dx.GrowthPushCocos2dxActivity" ... >
  ...
  <intent-filter>
    <action android:name="android.intent.action.MAIN" />
    <category android:name="android.intent.category.LAUNCHER" />
  </intent-filter>
</activity>
```

## Tracking events and setting tags.


```cpp
bool AppDelegate::applicationDidFinishLaunching() {
    // ...
    GrowthPush::initialize(YOUR_APP_ID, "YOUR_APP_SECRET", GPEnvironmentDevelopment, true);
    GrowthPush::registerDeviceToken("YOUR_SENDER_ID");
    GrowthPush::trackEvent("Launch");
    GrowthPush::setDeviceTags();
    GrowthPush::clearBadge();
    // ...
    return YES;
}
```

## How to track "Launch via push notification xxx"

1. Add GPAppDelegateIntercepter+GrowthPushCocos2dx.h and GPAppDelegateIntercepter+GrowthPushCocos2dx.m to your Xcode project
1. Disable ARC for GPAppDelegateIntercepter+GrowthPushCocos2dx.m by adding "-fno-objc-arc" flag. 
1. Add growthpush-launch-via-push-notification.jar to libs directory in your Andorid project
1. Change BroadcastReceiver to LaunchViaPushNotificationBroadcastReceiver

  ```java
   <receiver
       android:name="com.growthpush.LaunchViaPushNotificationBroadcastReceiver"
       android:permission="com.google.android.c2dm.permission.SEND" >
       <intent-filter>
           <action android:name="com.google.android.c2dm.intent.RECEIVE" />
           <action android:name="com.google.android.c2dm.intent.REGISTRATION" />

           <category android:name="com.growthpush.sample" />
       </intent-filter>
   </receiver>
   ```
