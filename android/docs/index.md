# Locarta Android SDK

| Latest Version | Size | Minimal Android API verison | Release Date
| ------------- |  ------------- | -------------  | -------------
| 1.3.0 | 457 KB | 7 (2.1  Eclair) | 31/10/2016

## Setup
------

### 1) Declare dependencies

Open the `build.gradle` file of your project and update the repository and dependency blocks as follows:
```gradle
     repositories {
        // ... other project repositories
        maven {
            url "http://nexus.locarta.co/content/repositories/android-sdk/"
            credentials {
               username = "$YOUR_USERNAME$"
               password = "$YOUR_PASSWORD$"
            }
        }
        // Repository will be provided separately
     }
     // ...
 	 dependencies {
        // ... other project dependencies
        // We recommend to set version as: 1.3.+
        compile ("co.locarta:locarta-sdk:$LOCARTA_SDK_VERSION$:pubProd@aar") {
            transitive = true;
        }
     }
```     

Where `$YOUR_USERNAME$` and `$YOUR_PASSWORD$` are the credentials to the nexus repository.
*They match with the credentials you got to get access to this documentation*.

`$LOCARTA_SDK_VERSION$` is the SDK version number you wish to use.
Sync `build.gradle`, rebuild your project and import `co.locarta.sdk.LocartaSDK` into your app.

We advise to use `https` in the repository url (e.g. `https://nexus.locarta.co/..., we intentinally keep http to avoid certain problems with specific java versions.)

### 2) Set Publisher Key

Add a `<meta-data>` tag to the `AndroidManifest.xml` of your project:
```xml
    <application>
        <!-- other content -->
        <meta-data
               android:name="co.locarta.sdk.pid"
               android:value="YOUR_PUBLISHER_ID" />        
    </application>
```
where `YOUR_PUBLISHER_ID` is your Locarta publisher id.

### 3) Initialise SDK on App Start

You need to initialise the Locarta SDK only once – on app start:
``` java
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

The SDK will not start working until the user has opted in – this needs to be done only once per user. There are two ways to do it, depending on how the opt-in is gathered:

a) Implicit opt-in (if you've added Locarta info to your app's privacy policy):
``` java
    // Put this code in your Application.onCreate() function, after LocartaSdk.initialize()
    if(!LocartaSDK.isAgreementAccepted(getContext())) {
        LocartaSDK.setAgreementAccepted(getContext(), true);
    }
``` 
a) Explicit opt-in (if you want to show a popup agreement dialog prompting users to opt in):
```java
    // Put this code somewhere in the main activities to show the dialog
    LocartaSdk.showAgreementDialog(getActivity());
```    
   

If you want to check whether the user has opted in, call:
``` java
    // The call returns true or false if user accepted terms or not
    LocartaSDK.isAgreementAccepted(getContext());        
```

You can also check whether user saw an agreement dialog:
``` java
    // The call returns TermStatus enum
    LocartaSDK.getAgreementStatus(getContext());
```

### 5) User Opt-Out

If you need to turn off SDK manually and do not allow it to restart, you can use the following method:

```java
   LocartaSDK.setAgreementAccepted(getContext(), false);
```

### 6) Push notifications

If you use Google Cloud Messaging to send push notifications to your application, please
call this method to split the SDK's notifications from yours:

```java
   // Returns *true* if push notification is addressed to SDK
   LocartaSdk.handleMessage(Bundle bundle);
```

Please ignore the push notifications addressed to the SDK in your receiver:

```java
public class AppGcmListenerService extends GcmListenerService {

    @Override
    public void onMessageReceived(String from, Bundle bundle) {
        if (!LocartaSdk.handleMessage(bundle)) { 
          // Normal push notification, your logic comes here
            Log.i("AppGcmListenerService", String.format("Received message from %s with data %s", from, bundle));
        } else {
          // just ignore this push notification, it is addressed to the SDK
        }
    }

}
```

## Integration Information

------

By default the host app __should not__ be setting any additional permissions in its manifest.

In case Target SDK Version >= 23 we rely on the fact that `Access Fine Location` / `Access Coarse Location` permisions are handeled by the host app (e.g. pop-out permission dialog is shown to the user).

The set of minimal permissions embedded in the Locarta SDK is:

| Permission Name | Plain English Name in App | Plain German Name in App
| ------------- | ------------- | -------------
|android.permission.INTERNET | Full network access | Zugriff auf alle Netzwerke
|android.permission.ACCESS_FINE_LOCATION| Precise location| Genauer Standort
|android.permission.ACCESS_COARSE_LOCATION| Approximate location| Ungefährer Standort
|android.permission.ACCESS_NETWORK_STATE | View network connections| Netzwerkverbindungen abrufen
|android.permission.ACCESS_WIFI_STATE | View wifi connections | WLAN-Verbindungen abrufen
|android.permission.CHANGE_WIFI_STATE | Connect and disconnect from Wi-Fi | WLAN-Verbindungen herstellen und trennen


### Proguard

Proguard rules are already configured for the Locarta SDK. No additional steps need to be taken in your application.

### Performance Impact

We expect a battery impact of roughly 2-3%.

Normally we use about 1MB/week of mobile data (depending on how long the phone is connected to wifi).

### 3rd-Party Dependencies

The Locarta SDK should be implemented as a transitive @aar dependency. These are the 3rd-party dependencies it uses:

| Dependency | Version
| ------------- |  -------------
|com.google.android.gms:play-services-location | 9.6.1
|com.google.android.gms:play-services-gcm | 9.6.1
|com.google.code.gson:gson | 2.7
|io.reactivex:rxjava | 1.1.8
|com.squareup.retrofit2:retrofit| 2.1.0
|com.squareup.retrofit2:converter-gson | 2.1.0
|de.greenrobot:eventbus| 3.0.0
|com.google.dagger:dagger| 2.0
|ch.hsr:geohash| 1.0.13
|com.google.protobuf|3.0.0

------

### Troubleshooting

#### Proguard

If you see the message: `Can't find referenced class from the SDK`, add these lines to your proguard configuration:

```
-dontwarn co.pointwise.proto.JournalProto$.**
-dontwarn com.google.common.base.Function
-dontwarn com.google.common.collect.Lists
-dontwarn com.google.common.io.BaseEncoding
```


#### Downgrading min SDK version to API v7

Technically the minimum API version for the SDK is already v7. However, it depends on Google Play Services, which requires minimum API v9.

If you get an error saying:
```
Manifest merger failed : uses-sdk:minSdkVersion 7 cannot be smaller than version 9 declared in library [com.google.android.gms:play-services-location:9.4.0] Suggestion: use tools:overrideLibrary="com.google.android.gms" to force usage
```

Then add this line to the manifest of your application:

```xml
<uses-sdk tools:overrideLibrary="com.google.android.gms, com.google.android.gms.base, com.google.android.gms.tasks, com.google.android.gms.gcm, com.google.android.gms.iid"/>
```
