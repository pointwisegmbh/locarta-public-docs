# Locarta Android SDK

| Latest Version | Size | Release Date
| ------------- |  ------------- | ------------- 
| 1.0.3 | 172 kb |07/06/2016

## Setup
------

### Declare dependencies

To add the Locarta Sdk dependency, open a build.gradle of your project and update the repositories and dependencies blocks as follows:
``` gradle
     repositories {
     // ... other project repositories
     maven { url "http://repo.pointwise.co/nexus/content/repositories/pointwise" }
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
``` xml
    <application>
        // ... other content
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

This can be done wither via embed dialog:
``` java
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

Optional permissions that could  declared on the host application level:

| Permission Name | Plain English Name in App | Plain German Name in App
| ------------- | ------------- | ------------- 
|android.permission.RECEIVE_BOOT_COMPLETED| Run At Startup | Beim Anschalten Starten
|com.google.android.gms.permission.ACTIVITY_RECOGNITION| Activity Recognition | Aktivitätserkennung


### Proguard

We already configured proguard rules for the Locarta SDK. No addtional steps has to be done in the host application

### Performance impact

We expect a battery impact of roughly 2% (adjustable)

### 3rd party dependencies 

Since we ask you to integrate Locarta SDK as transitive @aar dependeny, we'd like to provide a list of 3rd party dependencies we use.

| Dependency | Version
| ------------- |  -------------
|com.google.android.gms:play-services-location | 9.2.0
|com.android.support:appcompat-v7 | 24.0.0
|com.google.code.gson:gson | 2.7
|com.squareup.retrofit:converter-gson | 2.0.0-beta2
|de.greenrobot:eventbus| 3.0.0
|com.google.dagger:dagger| 2.0
|ch.hsr:geohash| 1.0.13
|com.google.protobuf|2.6.1

------

