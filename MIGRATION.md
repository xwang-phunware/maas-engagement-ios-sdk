# PWEngagement Migration Guide

## Upgrade from 3.x to 4.0.0

#### General

PWEngagement v4.0.0 is rewriten by swift and many APIs are changed to be more swiftable. 

#### Upgrade Steps

1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '4.0.0'`, then run `pod update` in the Terminal to update the framework.

2. Check out the [migration guide](https://github.com/phunware/maas-core-ios-sdk/blob/master/MIGRATION.md) for PWCore 4.0.0 upgrade.

3. You may need to make changes in **AppDelegate.swift**.
	
	* Configure SDK in **application(_: willFinishLaunchingWithOptions:)** method. 
	
	````
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		...
		PWEngagement.configure(with: appId, accessKey: accessKey, signatureKey: signatureKey)
		...
	}
	````
	
	* Update ANPS token in the **application(_:didRegisterForRemoteNotificationsWithDeviceToken:)** method. 

	````
	PWEngagement.apnsToken = deviceToken
	````
	
	* Handle incoming remote notification in the **application(_: didReceiveRemoteNotification: fetchCompletionHandler)** method. 

	````
	PWEngagement.retrieveMessage(with: userInfo) { (message, error) in
		// You may add code here to do what you want
		
   		completionHandler(.newData)
    }
	````
	
	* [Request user notification authorization](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter), we recomment doing it from **application(_: willFinishLaunchingWithOptions:)** method. 

	> It's not required, you can just keep what you done with `UNUserNotificationCenter` to handle the user notificaiton.
	
	````
	UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else {
                return
            }
            
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus != .authorized {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        }
        
   // Handle incoming notifications and notification-related actions.
   UNUserNotificationCenter.current().delegate = self
	````
	
	* Handle user notification from **UNUserNotificationCenterDelegate**'s callback methods. 

	> Message deep linking or show incoming message when the app is running in the foreground.
	
	````
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        PWEngagement.retrieveMessage(with: notification.request.content.userInfo) { [weak self] (message, error) in
            // TODO... show the notification when app is running in the foreground.
            
            // Complete the handler by poping a alert or something
            completionHandler(.alert)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let userInfo = response.notification.request.content.userInfo as? [String : Any] else {
            return
        }
        
        PWEngagement.retrieveMessage(with: userInfo) { [weak self] (message, error) in
            // TODO... deep linking implementation
        }
        completionHandler()
    }
	````
	
#### General Questions

How to subscribe message/geofence events?
> Two options:
> 
> 1) Implement **EngagementDelegate** methods to receive events.
> 
> 2) Listen notification by the following names which are defined in Engagement.swift:
> 
> ```
> public extension NSNotification.Name {
    /// Enter a geofence
    static let EnteredGeofence = NSNotification.Name("EnteredGeofence")
    /// Exit a geofence
    static let ExitedGeofence = NSNotification.Name("ExitedGeofence")
    /// Start monitoring geofences
    static let StartedMonitoringGeofences = NSNotification.Name("StartedMonitoringGeofences")
    /// Stop monitoring geofences
    static let StoppedMonitoringGeofences = NSNotification.Name("StoppedMonitoringGeofences")
    /// Added geofences
    static let AddedGeofences = NSNotification.Name("AddedGeofences")
    /// Deleted geofences
    static let DeletedGeofences = NSNotification.Name("DeletedGeofences")
    /// Received a message
    static let ReceivedMessage = NSNotification.Name("ReceivedMessage")
    /// Read a message
    static let ReadMessage = NSNotification.Name("ReadMessage")
    /// Deleted a messgage
    static let DeletedMessage = NSNotification.Name("DeletedMessage")
    /// Whenever error occurred
    static let EngagementError = NSNotification.Name("EngagementError")
}
> ```

How to get all geofences?
> Call **PWEngagement.geofences**

How to get all messsages?
> Call **PWEngagement.messages**

How to get a message by message identifier?
> Two options:
> 
> 1) Call **PWEngagement.message(for:)** for saved message
> 
> 2) Call **PWEngagement.retrieveMessage(with:completion:)** for incoming message

How to mark a message as read?
> Call **PWEngagement.read(messageId)**

How to delete a message?
> Call **PWEngagement.delete(messageId)**

## Upgrade from 3.6.x to 3.7.x

#### General

This release includes PWCore 3.8.x which contains new automatic screen view analytic events and simplified analytic event creation.

#### Upgrade Steps

1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.7.x'`, then run `pod update` in the Terminal to update the framework.

2. Check out the [migration guide](https://github.com/phunware/maas-core-ios-sdk/blob/master/MIGRATION.md) for PWCore 3.8.x on updating to the new analytics API.

## Upgrade from 3.5.x to 3.6.x

#### General
This release adds support for When-In-Use location permission.

#### Upgrade Steps
1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.6.x'`, then run `pod update` in the Terminal to update the framework.

## Upgrade from 3.4.x to 3.5.x

#### General

The iOS deployment target of PWEngagement is now 10.0 instead of 9.0. To be compatible with PWEngagement, an application must have a minimum iOS deployment target of 10.0 as well.

#### Upgrade Steps

1. Update your applicable Xcode project settings to a minimum iOS deployment target of 10.0 or greater.

2. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.5.x'`, update your iOS platform to 10.0 or greater, then run `pod update` in the Terminal to update the framework.

## Upgrade from 3.3.x to 3.4.x

#### General
This release adds support for new release of Core and removes location and push notification permission prompting

#### Upgrade Steps
1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.4.x'`, then run `pod update` in the Terminal to update the framework. This will include the latest version of PWCore 3.6.x.

2. To grant push notification permission we recommend following [Apple's best practices](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/SupportingNotificationsinYourApp.html). If permission is not granted the app will not receive push notifications.

3. To grant location permission we recommend following [Apple's best practices](https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services/requesting_always_authorization?language=objc) . To function as designed, PWEngagement needs the user to “Always Allow” location in order to properly search for Geofences activity in the background.  If “Only when in use” or “Don’t allow” is chosen, the app will not monitor for regions. Therefore it will not receive geofence notifications or range on beacons.

## Upgrade from 3.2.x to 3.3.x

#### General
This release adds support for new release of Core

#### Upgrade Steps
1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.3.x'`, then run `pod update` in the Terminal to update the framework. This will include the latest version of PWCore 3.3.x.
