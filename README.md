growthpush-cocos2dx for Cocos2d-x 3.0
===================

Growth Push SDK for Cocos2d-x

Growth Push is the easiest way to implement push notification and analyzes your notification for smart devices.
https://growthpush.com

How To Build Sample Project
1. Open XcodeProject
2. Click projectfile and move to "Build Phases"
3. Open toggle "Target Dependencies" and click "+".
4. Add "cocos2dx iOS", "cocos2dx-extensions iOS", "chipmunk iOS", "box2d iOS" and "CocosDension iOS" Files.
5. Open toggle "Link Binary With Libraries" and clieck "+"
6. Add "libbox2d iOS.a", "libchipmunk iOS.a", "libcocos2dx iOS.a", "libcocos2dx-extensions iOS.a" and "libCocosDension iOS.a".
7. Build.

Install
----------------
Common
----------------
1. Copy "Classes/GrowthPush" to "/path/to/your_project/Classes/"

iOS　→　(http://blog.growthpush.com/post/71159185584/ios-cocos2d-x)
----------------
1. Copy "GrowthPush.framework" library to "/path/to/your_project/proj.ios/Frameworks/"
2. Add "Security.framework" library to your Xcode project (and also SystemConfiguration.framework and MobileCoreServices.framework, if needed)
3. Add "/path/to/your_project/Classes/GrowthPush" to Xcode

Android　→　(http://blog.growthpush.com/post/74729590395/android-cocos2d-x)
----------------
1. Copy following jar files to "/path/to/your_project/proj.android/libs/"
      * android-support-v4.jar
      * google-play-services.jar
      * growthpush.jar
2. Copy "proj.android/src/com" to "/path/to/your_project/proj.android/src"
3. Edit your project's AndroidManifest.xml
      * Insert GrowthPush activity setting
      * Insert uses-permission setting
4. Add build path to your project's Android.mk
      * LOCAL_SRC_FILES := ../../Classes/GrowthPush/android/GrowthPush.cpp
      * LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes/GrowthPush

Example

AndroidManifest.xml

```
    <application android:label="@string/app_name"
        android:icon="@drawable/icon">

        <activity android:name="org.cocos2dx.cpp.AppActivity"
                  android:label="@string/app_name"
                  android:screenOrientation="portrait"
                  android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
                  android:configChanges="orientation"
                  android:launchMode="singleTask">
            <!-- Tell NativeActivity the name of our .so -->
            <meta-data android:name="android.app.lib_name"
                       android:value="cocos2dcpp" />
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
        <activity android:name="com.growthpush.view.AlertActivity" 
                  android:configChanges="orientation|keyboardHidden"
                  android:launchMode="singleInstance"
                  android:theme="@android:style/Theme.Translucent" />

        <receiver android:name="com.growthpush.cocos2dx.Cocos2dxBroadcastReceiver" android:permission="com.google.android.c2dm.permission.SEND" >
                <intent-filter>
                        <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                        <action android:name="com.google.android.c2dm.intent.REGISTRATION" />
                        <category android:name="jp.example.sample" />
                </intent-filter>
        </receiver>
    </application>

    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.GET_ACCOUNTS" />
    <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <permission android:name="jp.example.sample.permission.C2D_MESSAGE" android:protectionLevel="signature" />
    <uses-permission android:name="jp.example.sample.permission.C2D_MESSAGE" />
```

Cocos2d-x usage
----------------

```
#include "GrowthPush.h"

USING_NS_GROWTHPUSH;

GrowthPush::initialize(YOUR_APP_ID, "YOUR_APP_SECRET", YOUR_APP_ENV, YOUR_DEBUG_FLAG);

GrowthPush::registerDeviceToken();  // iOS only
GrowthPush::registerDeviceToken("YOUR_SENDER_ID");  // if you need Android

GrowthPush::setDeviceTags();

GrowthPush::trackEvent("EventName");
GrowthPush::trackEvent("EventName", "EventValue");

GrowthPush::setTag("TagName");
GrowthPush::setTag("TagName", "TagValue");

GrowthPush::clearBadge();

GrowthPush::launchWithNotification(this, gp_remote_notification_selector(AppDelegate::CALLBACK_FUNCTION));

// for C++11 (in the future)
//GrowthPush::launchWithNotification(CC_CALLBACK_1(AppDelegate::CALLBACK_FUNCTION, this));
//GrowthPush::launchWithNotification(std::bind(&AppDelegate::CALLBACK_FUNCTION, this, std::placeholders::_1));
//GrowthPush::launchWithNotification([](ValueMap json) {
//    // do something.
//});
```

Example

```
bool AppDelegate::applicationDidFinishLaunching() {
    ... (code) ...
    
    // run
    pDirector->runWithScene(pScene);

    int appID = YOUR_APP_ID;
    const char *secrect = "YOUR_APP_SECRET";
    GPEnvironment environment = GPEnvironmentDevelopment;
    bool debug = true;
    const char *senderID = "YOUR_SENDER_ID";
    
    GrowthPush::initialize(appID, secrect, environment, debug);
    GrowthPush::registerDeviceToken(senderID);
    GrowthPush::setDeviceTags();
    GrowthPush::trackEvent("Event");
    GrowthPush::trackEvent("Event", "Value");
    GrowthPush::setTag("Tag");
    GrowthPush::setTag("Tag", "Value");
    GrowthPush::clearBadge();
    
    GrowthPush::launchWithNotification(this, gp_remote_notification_selector(AppDelegate::didReceiveRemoteNotification));
    
    ... (code) ...
}

void AppDelegate::didReceiveRemoteNotification(Value json) {
    // ex.) {"aps":{"badge":1,"sound":"default","alert":"Message"},"growthpush":{"notificationId":1234}}
    CCLOG("%s", json.getDescription().c_str());
    auto growthpush = json.asValueMap()["growthpush"].asValueMap();
    int notificationId = growthpush["notificationId"].asInt();
    GrowthPush::trackEvent(StringUtils::format("Launch via push notification %d", notificationId));
}
```
