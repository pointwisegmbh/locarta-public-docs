# Locarta Unity SDK


| Latest Version | Size | Min Unity version | Release Date | MD5 checksum
| ------------- |  ------------- | -------------  | -------------  | -------------
| 1.3.2 | 6.3M | 5.x | 06/12/2016 |  294fc6e39924097e59252b774c7f1057

The Locarta SDK can be integrated through a Unity plugin.

We currently support v5.x or higher of the Unity Framework.

To get started you will need (to be provided separately):
*  Publisher ID
*  Credentials to download the plugin  


## Setup
-------

### 1) Download and install plugin

Download the archive:

```
https://static.locarta.co/locarta-sdk-unity/locarta-sdk-unity-1.3.2.zip
```

When prompted for authentication, use the credentials mentioned above.

Once downloaded, unzip the contents to the folder `./Assets/Plugins/Android`

For example:

```sh
# works from the project root if ./Assets/Plugins/Android foder already exists
unzip locarta-sdk-unity-1.3.2.zip -d ./Assets/Plugins/Android
```


### 2) Set publisher key

Add a file named `locarta.properties` to the `./Assets/Plugins/Android/assets` folder.

Set the file contents to the following:

```
pid=<YOUR PUBLISHER ID>
```


### 3) Set up Android manifest

Add a file named `AndroidManifest.xml` to the `./Assets/Plugins/Android` folder.

Set the file contents to the following:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest
    xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.unity3d.player"
	android:installLocation="preferExternal"
    android:versionCode="1"
    android:versionName="1.0">
    <supports-screens
        android:smallScreens="true"
        android:normalScreens="true"
        android:largeScreens="true"
        android:xlargeScreens="true"
        android:anyDensity="true"/>

    <application
		android:theme="@style/UnityThemeSelector"
		android:icon="@drawable/app_icon"
        android:label="@string/app_name"
        android:name="co.locarta.sdk.LocartaSdkApplication"
        android:debuggable="true">
        <activity android:name="com.unity3d.player.UnityPlayerActivity"
                  android:label="@string/app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
            <meta-data android:name="unityplayer.UnityActivity" android:value="true" />
        </activity>
    </application>
</manifest>
```

If some other 3rd party Android library requires you to have a custom Android application class, then please create a new [library project](https://developer.android.com/studio/projects/index.html#LibraryProjects) which contains both libraries, and add a custom application class and initialize the SDK there with the following code:

```java
// Add this line to the header of your file
import co.locarta.sdk.LocartaSdk;

public class SdkDemoApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        // Initialise SDK on App creation
        LocartaSdk.initialize(getApplicationContext());
    }
}
```

### 4) Obtain User Opt-In

Users must opt in to Locarta's market research programme for the SDK to start working. This can be done either:

a) Via an API call (if your application has its own agreement dialog or compliant privacy policy):

```cs
// Accepting SDK agreements
AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");

AndroidJavaClass locartaSdk = new AndroidJavaClass("co.locarta.sdk.LocartaSdk");
locartaSdk.CallStatic("setAgreementAccepted", activity, true);
```

b) Via the default Locarta agreement dialog:

```cs
AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");

AndroidJavaClass locartaSdk = new AndroidJavaClass("co.locarta.sdk.LocartaSdk");
if (!locartaSdk.CallStatic<bool> ("isAgreementAccepted", activity)) {
      activity.Call ("runOnUiThread", new AndroidJavaRunnable (() => {
          locartaSdk.CallStatic<AndroidJavaObject> ("showAgreementDialog", activity);
      }));
}
```

### 5) User Opt-Out

If you need to turn off SDK manually and do not allow it to restart, you can use the following method:

```cs
AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");

AndroidJavaClass locartaSdk = new AndroidJavaClass("co.locarta.sdk.LocartaSdk");
locartaSdk.CallStatic("setAgreementAccepted", activity, false);
```

### 6) Push notifications

If you use Google Cloud Messaging to send push notifications to your application, please
call a special method to split the SDK's notifications from yours. You need to call that method in a place
where you are listening for incoming notifications. You can use this code:

```cs
// var message = "sample"; // assuming this is a received message, according
// to default GCM implementation this can be taken from android.os.Bundle
// class in broadcast receiver by a key "default", i.e. bundle.getString("default", null)
using (var bundle = new AndroidJavaObject ("android.os.Bundle")) {
    bundle.Call ("putString", "default", message);
    using (var sdk = new AndroidJavaClass ("co.locarta.sdk.LocartaSdk")) {
        if (!sdk.CallStatic<bool> ("handleMessage", bundle)) {
            // handle your push notification
        } else {
            // do nothing, the notification belongs to the SDK
        }
    }
}
```


## Integration Information

------

In case Target SDK Version >= 23 we rely on the fact that `Access Fine Location` / `Access Coarse Location` permisions are handeled by the host app (e.g. pop-out permission dialog is shown to the user).

The set of minimal permissions embedded in the Locarta SDK is:

| Permission Name | Plain English Name in App | Plain German Name in App
| ------------- | ------------- | -------------
|android.permission.INTERNET | Full network access | Zugriff auf alle Netzwerke
|android.permission.ACCESS_COARSE_LOCATION| Approximate location| Ungefährer Standort
|android.permission.ACCESS_FINE_LOCATION| Precise location| Genauer Standort
|android.permission.ACCESS_NETWORK_STATE | View network connections| Netzwerkverbindungen abrufen
|android.permission.ACCESS_WIFI_STATE | View wifi connections | WLAN-Verbindungen abrufen
|android.permission.CHANGE_WIFI_STATE | Connect and disconnect from Wi-Fi | WLAN-Verbindungen herstellen und trennen



### Performance Impact

We expect a battery impact of roughly 2-3%.

Normally we use about 1MB/week of mobile data (depending on how long the phone is connected to wifi).
