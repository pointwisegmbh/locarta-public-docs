# Locarta Android SDK

| Latest Version | Size | Minimal Android API version | Release Date
| ------------- |  ------------- | -------------  | -------------
| 2.1.1 | 533.76 KB | 14 (4.0  Ice cream sandwich) | 10/03/2018

## Setup
------

### 1) Declare dependencies

Open the `app/build.gradle` file of your project and update the repository and dependency blocks as follows:
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
          // We recommend to set version as: 2.0.+
          compile ("co.locarta:locarta-sdk:$LOCARTA_SDK_VERSION$:pubProd@aar") {
              transitive = true;
          }
      }
```     

Where `$YOUR_USERNAME$` and `$YOUR_PASSWORD$` are the credentials to the nexus repository.
*They match with the credentials you got to get access to this documentation*.

`$LOCARTA_SDK_VERSION$` is the SDK version number you wish to use.
Sync `build.gradle`, rebuild your project and import `co.locarta.sdk.LocartaSDK` into your app.

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

### 3) Initialize SDK on App Start
**Please call the initialization method only in the application class.**

Also notice that the SDK already starts a new thread for the initialization. Hence there is no need to put the init method in a new thread.

Example:
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

The SDK will not start working until the user has opted in – this needs to be done only once per user. There are two ways to do it, depending on how the opt-in is gathered:

a) Implicit opt-in (if you've added Locarta info to your app's privacy policy):
```java
    // Put this code in your Application.onCreate() function, after LocartaSdk.initialize()
    if(!LocartaSdk.isAgreementAccepted(getContext())) {
        LocartaSdk.setAgreementAccepted(getContext(), true);
    }
```
a) Explicit opt-in (if you want to show a popup agreement dialog prompting users to opt in):
```java
    // Put this code somewhere in the main activities to show the dialog
    LocartaSdk.showAgreementDialog(getActivity());
```


If you want to check whether the user has opted in, call:
```java
    // The call returns true or false if user accepted terms or not
    LocartaSdk.isAgreementAccepted(getContext());        
```

You can also check whether user saw an agreement dialog:
```java
    // The call returns TermStatus enum
    LocartaSdk.getAgreementStatus(getContext());
```

### 5) User Opt-Out

If you need to turn off SDK manually and do not allow it to restart, you can use the following method:

```java
   LocartaSdk.setAgreementAccepted(getContext(), false);
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
|com.google.android.gms:play-services-location | 11.8.0
|com.google.android.gms:play-services-gcm | 11.8.0
|com.google.code.gson:gson | 2.8.1
|io.reactivex:rxjava | 1.3.1
|com.squareup.retrofit2:retrofit| 2.3.0
|com.squareup.retrofit2:converter-gson | 2.3.0
|com.google.dagger:dagger| 2.11
|ch.hsr:geohash| 1.0.13
|com.google.protobuf.nano:protobuf-javanano|3.1.0

#### Exclude dependencies

If you're using one of the libraries listed above and want to use the most recent version of it, you can force the build system to choose it rather than using the one built into the SDK. For example if you want to force using the recent Play Services library add the Locarta SDK's dependency like this:

```gradle
dependencies {
   compile ("co.locarta:locarta-sdk:$LOCARTA_SDK_VERSION$:pubProd@aar") {
       transitive = true;
       exclude group: "com.google.android.gms", module: "play-services-gcm"
       exclude group: "com.google.android.gms", module: "play-services-location"
   }

   compile "com.google.android.gms:play-services-gcm:$PLAY_SERVICES_VERSION$"
   compile "com.google.android.gms:play-services-location:$PLAY_SERVICES_VERSION$"
}  
```

Use the same way for others dependencies such as RxJava etc.

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



#### Robolectric

If you see the message: `Conflict with dependency 'com.google.protobuf:protobuf-java'. Resolved versions for app (3.1.0) and test app (2.6.1)`, then replace Robolectric dependency in `build.gradle` file with these lines:

```
testCompile("org.robolectric:robolectric:3.1.2") {
    exclude group: 'com.google.protobuf.nano', module: 'protobuf-javanano'
}
testCompile("org.robolectric:shadows-multidex:3.1") {
    exclude group: 'com.google.protobuf.nano', module: 'protobuf-javanano’
}
```
