
# CoronaSDK Sample Code

These samples have been adapted for cross-platform deployment in the following ways:

* Automatic content scaling for multiple screen dimensions, using an optional "config.lua" file with either "letterbox" or "zoomEven" scaling modes specified.

* Sound files in both .caf and .mp3 formats, which are the preferred event sound formats for iOS and Android, respectively.

* Android device permissions added to build.settings where appropriate (for example, Android requires specific permissions for GPS, Internet access, or using the camera).


For production purposes, you may want to use higher-resolution assets for the iPad and other large-screen devices, but sharing assets between the iPhone and Android phones generally works well.


For more information on the "config.lua" and "build.settings" files, and how to deploy your Corona content to multiple devices, see the following guides:

* [Project Configuration guide](http://docs.coronalabs.com/guide/basics/configSettings/) 
* [Project Build Settings](http://docs.coronalabs.com/guide/distribution/buildSettings/)


All sample code is offered under the open-source MIT License, the same license used by the Lua language itself.