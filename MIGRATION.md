# PWEngagement Migration Guide
## Upgrade from 3.3.x to 3.4.x

#### General
This release adds support for new release of Core and removes location and push notification permission prompting

#### Upgrade Steps
1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.4.x'`, then run `pod update` in the Terminal to update the framework. This will include the latest version of PWCore 3.5.x.

2. To grant push notification permission we recommend following [Apple's best practices](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/SupportingNotificationsinYourApp.html). If permission is not granted the app will not receive push notifications.

3. To grant location permission we recommend following [Apple's best practices](https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services/requesting_always_authorization?language=objc) . To function as designed, PWEngagement needs the user to “Always Allow” location in order to properly search for Geofences activity in the background.  If “Only when in use” or “Don’t allow” is chosen, the app will not monitor for regions. Therefore it will not receive geofence notifications or range on beacons.

## Upgrade from 3.2.x to 3.3.x

#### General
This release adds support for new release of Core

#### Upgrade Steps
1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.3.x'`, then run `pod update` in the Terminal to update the framework. This will include the latest version of PWCore 3.3.x.
