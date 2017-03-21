This sample project demonstrates how to use Corona's preference APIs to read, write, and delete an app's custom settings to/from local storage. These settings will persist after the app exits, to be read the next time the app starts up.

The "Save" button will save the current widget settings to storage.

The "Restore" button will load the last saved widget settings from storage.

The "Reset" button will delete the app's preferences from storage and then reset the widgets back to their default settings.

RELATED DOCUMENTATION
[system.getPreference()](https://docs.coronalabs.com/api/library/system/getPreference.html)
[system.setPreferences()](https://docs.coronalabs.com/api/library/system/setPreferences.html)
[system.deletePreferences()](https://docs.coronalabs.com/api/library/system/deletePreferences.html)
