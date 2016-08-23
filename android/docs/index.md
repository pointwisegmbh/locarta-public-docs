# Locarta Android SDK

| Latest Version | Size | Minimal Android API verison | Release Date
| ------------- |  ------------- | -------------  | ------------- 
| 1.0.5 | 415 KB| 7 (2.1  Eclair) |23/08/2016

## Setup
------

### 1) Declare dependencies

Open the `build.gradle` file of your project and update the repository and dependency blocks as follows:
```gradle
     repositories {
        // ... other project repositories
        maven { 
            url "https://repo.pointwise.co/nexus/content/repositories/pointwise"
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
        compile ("co.locarta:locarta-sdk:$LOCARTA_SDK_VERSION$:pubRelease@aar") {
            transitive = true;
        }
     }
```     

where `$LOCARTA_SDK_VERSION$` is the SDK version number you wish to use.
Sync `build.gradle`, rebuild your project and import `co.locarta.sdk.LocartaSDK` into your app.


### 2) Set Publisher Key

Add a `<meta-data>` tag to the `AndroidManifest.xml` of your project:
```xml
    <application>
        <!-- other content -->
        <meta-data 
               android:name="co.locarta.sdk.pid" 
               android:value="YOUR_PUBLISHER_KEY" />        
    </application>
```
where `YOUR_PUBLISHER_KEY` is your Locarta publisher key.

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

User must opt in to Locarta's market research programme for the SDK to start working. This can be done either:

a) Via the default Locarta agreement dialog:
```java
    // Put this code somewhere in the main activities
    LocartaSdk.showAgreementDialog(this);
```    
b) Via an API call (if your application has own agreement dialog or compliant terms and conditions):
``` java
    LocartaSDK.setTermsAccepted(true);
```    
    
If you want to check whether the user has opted in, call:
``` java
    // The call returns true or false if user accepted terms or not
    LocartaSDK.getTermsAccepted();        
```

If you want to stop SDK for some reason:
```java
   LocartaSdk.stop(context);
```

## Integration Information 

------

By default the host app __should not__ be setting any additional permissions in its manifest.

The set of minimal permissions embedded in the Locarta SDK is:

| Permission Name | Plain English Name in App | Plain German Name in App
| ------------- | ------------- | ------------- 
|android.permission.INTERNET | Full Network Access | Zugriff auf alle Netzwerke
|android.permission.ACCESS_COARSE_LOCATION| Approximate Location| Ungefährer Standort 
|android.permission.ACCESS_FINE_LOCATION| Precise Location| Genauer Standort 
|android.permission.ACCESS_NETWORK_STATE | View Network Connections| Netzwerkverbindungen abrufen
|android.permission.ACCESS_WIFI_STATE | View Wifi Connections | WLAN-Verbindungen abrufen


### Proguard

Proguard rules are already configured for the Locarta SDK. No additional steps need to be taken in your application.

### Performance Impact

We expect a battery impact of roughly 2-3%.

Normally we use about 1MB/week of mobile data (depending on how long the phone is connected to wifi).

### 3rd-Party Dependencies 

The Locarta SDK should be implemented as a transitive @aar dependency. These are the 3rd-party dependencies it uses:

| Dependency | Version
| ------------- |  -------------
|com.google.android.gms:play-services-location | 9.4.0
|com.google.android.gms:play-services-gcm | 9.4.0
|com.google.code.gson:gson | 2.7
|com.squareup.retrofit2:retrofit| 2.1.0
|com.squareup.retrofit2:converter-gson | 2.1.0
|de.greenrobot:eventbus| 3.0.0
|com.google.dagger:dagger| 2.0
|ch.hsr:geohash| 1.0.13
|com.google.protobuf|3.0.0-beta-3
|org.apache.commons:commons-io|1.3.2
|io.protostuff:protostuff-json|1.3.5

------

### Troubleshooting

#### Proguard 

If you see the message: `Can't find referenced class from the SDK`, add these lines to your proguard configuration: 

```
-dontwarn co.pointwise.proto.JournalProto$.**
-dontwarn com.google.common.base.Function
-dontwarn com.google.common.collect.Lists
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


