# Locarta Unity SDK 


| Latest Version | Size | Min Unity version | Release Date
| ------------- |  ------------- | -------------  | ------------- 
| 1.1.1 | 5.7M | 5.x | 25/08/2016|

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
# will become active 31.08.2016
https://static.locarta.co/locarta-sdk-unity/locarta-sdk-unity-1.1.1.zip
```

When prompted for authentication, use the credentials mentioned above.

Once downloaded, unzip the contents to the folder `./Assets/Plugins/Android`

For example:

```sh
# works from the project root if ./Assets/Plugins/Android foder already exists
unzip locarta-sdk-unity-1.1.1.zip -d ./Assets/Plugins/Android
``` 


### 2) Set publisher key

Add a file named `locarta.properties` to the `./Assets/Plugins/Android/assets` folder.

Set the file contents to the following:

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

Users must opt in to Locarta's market research programme for the SDK to start working. This can be done either:

a) Via an API call (if your application has its own agreement dialog or compliant privacy policy):

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



