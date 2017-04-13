//
//  PubUtils.h

//
//  Created on 3/31/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PubUtils : NSObject

/**
 Get an object from user defaults by key
 @return The object in user defaults
 @param key The key of object you want to fetch from user defaults
 */
+ (id)getUserDefaultsFor:(NSString*)key;

/**
 Set object to user defaults for specified key
 @param key The key 
 @param value The object
 */
+ (void)setUserDefaultsWithValue:(NSObject*)value for:(NSString*)key;

/**
 Toast a message on the current view
 @param message The string message want to be shown
 */
+ (void)toast:(NSString*)message;

/**
 Toast a message on the current view
 @param message The string message want to be shown
 @param detail The detail string message want to be shown
 */
+ (void)toast:(NSString*)message detail:(NSString*)detail;

/**
 Show loading indicator on the current view
 */
+ (void)showLoading;

/**
 Dismiss loading indicator on the current view
 */
+ (void)dismissLoading;

/**
 Display something on current view
 @param title The message title
 @param content The string message want to be shown
 */
+ (void)displayTitle:(NSString*)title content:(id)content;

/**
 Display a error message on current view
 @param message The string message want to be shown
 */
+ (void)displayError:(NSError*)error;

/**
 Display a warning message on current view
 @param message The string message want to be shown
 */
+ (void)displayWarning:(NSString*)message;


@end
