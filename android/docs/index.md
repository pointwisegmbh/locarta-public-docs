# Locarta Android SDK

| Latest Version | Size | Minimal Android API verison | Release Date
| ------------- |  ------------- | -------------  | ------------- 
| 143.be90ae4 | 400 KB| 9 (2.3  Gingerbeard) |03/08/2016

## Setup
------

### Declare dependencies

To add the Locarta Sdk dependency open `build.gradle` file of your project and update the repositories and dependencies blocks as follows:
```gradle
     repositories {
     // ... other project repositories
     maven { url "https://repo.pointwise.co/nexus/content/repositories/pointwise" }
     // Repository will be provided separately 
     }
     // ...
 	 dependencies {
        // ... other project dependencies
        compile ("co.locarta.sdk:<LocartaSdkVersion>:pubProd@aar") {
            transitive = true;
        }
     }
```     

where "LocartaSdkVersion" is actual Locarta SDK version
Sync build.gradle, rebuild your project and import `co.locarta.sdk.LocartaSDK` into your app.


### Set Publisher Key

Add <meta-data> tag to AndroidManifest.xml of your project
```xml
    <application>
        <!-- other content -->
        <meta-data android:name="co.locarta.sdk.pid" android:value="<YOUR PUBLISHER KEY>"/>        
    </application>
```
where PublisherKey is your Publisher Key.

#### Initialise SDK

You need to initialise Locarta SDK only once on the startup
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

### User opt-in

User has to opt-in into marketing research program for the SDK to start working.

This can be done either via embed dialog:
```java
    // Put this code somewhere in the main activities
    LocartaSdk.showAgreementDialog(this);
```    
Or it can be done via API call if a host application has own accept dialog or compliant terms and conditions:
``` java
    LocartaSDK.setTermsAccepted(true);
```    
    
If you want to check the status of accepted terms, call:
``` java
    // The call returns true or false if user accepted terms or not
    LocartaSDK.getTermsAccepted();        
```

If you want to stop SDK for whatever reason:
```java
   LocartaSdk.stop(context);
```

## Integration information 

------

By default the host app __should not__ be setting any additional permissions in it's manifest.

The set of minimal permissions embedded in the Locarta SDK:

| Permission Name | Plain English Name in App | Plain German Name in App
| ------------- | ------------- | ------------- 
|android.permission.INTERNET | Full Network Access | Zugriff auf alle Netzwerke
|android.permission.ACCESS_COARSE_LOCATION| Approximate Location| Ungefährer Standort 
|android.permission.ACCESS_FINE_LOCATION| Precise Location| Genauer Standort 
|android.permission.ACCESS_NETWORK_STATE | View Network Connections| Netzwerkverbindungen abrufen
|android.permission.ACCESS_WIFI_STATE | View Wifi Connections | WLAN-Verbindungen abrufen


### Proguard

We already configured proguard rules for the Locarta SDK. No addtional steps has to be done in the host application

### Performance impact

We expect a battery impact of roughly 2% (adjustable).

Normally we use about 1MB/week of mobile data, but this also depends on how often you connect to wifi.

### 3rd party dependencies 

Since we ask you to integrate Locarta SDK as transitive @aar dependeny, we'd like to provide a list of 3rd party dependencies we use.

| Dependency | Version
| ------------- |  -------------
|com.google.android.gms:play-services-location | 9.4.0
|com.google.android.gms:play-services-gcm | 9.4.0
|com.android.support:appcompat-v7 | 24.1.1
|com.google.code.gson:gson | 2.7
|com.squareup.retrofit2:retrofit| 2.1.0
|com.squareup.retrofit2:converter-gson | 2.1.0
|de.greenrobot:eventbus| 3.0.0
|com.google.dagger:dagger| 2.0
|ch.hsr:geohash| 1.0.13
|com.google.protobuf|2.6.1

------

### Troubleshooting

#### Proguard 

If you see the message: _Can't find referenced class from the SDK  

Add these lines to your proguard configuration: 

```
-dontwarn co.pointwise.proto.JournalProto$.**
-dontwarn com.google.common.base.Function
-dontwarn com.google.common.collect.Lists
```


#### Downgrading min. skd version to API v7.

Technically SDK minimum version is 7 already.

But it depends on Google Play services with minimum version 9. 

If you get an error saying: 
```
Manifest merger failed : uses-sdk:minSdkVersion 7 cannot be smaller than version 9 declared in library [com.google.android.gms:play-services-location:9.4.0] Suggestion: use tools:overrideLibrary="com.google.android.gms" to force usage
```

Than add this line to the manifest of your applicaiton: 

```xml
<uses-sdk tools:overrideLibrary="com.google.android.gms, com.google.android.gms.base, com.google.android.gms.tasks, com.google.android.gms.gcm, com.google.android.gms.iid"/>
```


