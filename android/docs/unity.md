# Locarta Unity SDK 


| Latest Version | Size | Unity version | Release Date
| ------------- |  ------------- | -------------  | ------------- 
| 1.1.1 | 5.7M | >= 5 | 25/08/2016|

Locarta SDK is distributed as Unity plugin. 

At the moment we support Unity Framework version more or equal 5.x

To get started you need 2 things (they are provided separately):

*  Publisher ID

*  Credentials to download the plugin  


## Setup
-------

### 1) Download and install plugin

Download the archive:

```
# will become active 31.08.2016
https://static.locarta.co/locarta-sdk-unity/locarta-sdk-unity-1.1.1.zip
```

You will be prompted with Basic Authentication (use credentials for downloading)

Unzip the contents of the folder `./Assets/Plugins/Android`

For example:

```sh
# works from the project root if ./Assets/Plugins/Android foder already exists
unzip locarta-sdk-unity-1.1.1.zip -d ./Assets/Plugins/Android
``` 


### 2) Set publisher key

Add file  named `locarta.properties` to `./Assets/Plugins/Android/assets` folder.

The file should look like:

```
pid=<YOUR PUBLISHER ID>
```


### 3) Initialise SDK on App Start

```cs
public class MainScene : MonoBehaviour {

	// Use the method for the initialisation	
	void Start () {
    		// Get context
	   		AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
    		AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");

    		// Initialize SDK
			AndroidJavaClass locartaSdk = new AndroidJavaClass("co.locarta.sdk.LocartaSdk");
			locartaSdk.CallStatic("initialize", activity);
		}
	}	
```


### 4) Obtain User Opt-In


User must opt in to Locarta's market research programme for the SDK to start working. This can be done either:

a) Via an API call (if your application has own agreement dialog or compliant terms and conditions):

```cs
// Accepting SDK agreements 
AndroidJavaClass locartaSdk = new AndroidJavaClass("co.locarta.sdk.LocartaSdk");
locartaSdk.CallStatic("setAgreementAccepted", context, true);
```

b) Via the default Locarta agreement dialog:

```cs
if (!locartaSdk.CallStatic<bool> ("isAgreementAccepted", activity)) {
      activity.Call ("runOnUiThread", new AndroidJavaRunnable (() => { 
          locartaSdk.CallStatic<AndroidJavaObject> ("showAgreementDialog", activity);
      }));
  }
```



