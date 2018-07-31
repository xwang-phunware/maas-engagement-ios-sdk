//
//  NSObject.h

//
//  Created on 3/17/15.
//  Copyright (c) 2016 Phunware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Category used to help swizzle dispatched blocks to the background or foreground so that in test cases they are not dispatched but executed inline and in the same thread.
 */
@interface NSObject (GcdHelper)

/**
 * Executes a task asynchronously in a background thread.
 * @param backgroundTask The task to be executed.
 */
+ (void)runAsyncTaskInBackground:(void (^)())backgroundTask;

/**
 * Executes a task synchronously in a background thread.
 * @param backgroundTask The task to be executed.
 */
+ (void)runSyncTaskInBackground:(void (^)())backgroundTask;

/**
 * Executes a task asynchronously in the main thread.
 * @param foregroundTask The task to be executed.
 */
+ (void)runAsyncTaskInForeground:(void (^)())foregroundTask;

/**
 * Executes a task synchronously in the main thread.
 * @param foregroundTask The task to be executed.
 */
+ (void)runSyncTaskInForeground:(void (^)())foregroundTask;

/**
 * Executes a task asynchronously in the dispatch queue specified.
 * @param queue The queue where the task will be executed.
 * @param task The task to be executed.
 */
+ (void)runAsyncUsingQueue:(dispatch_queue_t)queue andTask:(void (^)())task;

/**
 * Executes a task synchronously in the dispatch queue specified.
 * @param queue The queue where the task will be executed.
 * @param task The task to be executed.
 */
+ (void)runSyncUsingQueue:(dispatch_queue_t)queue andTask:(void (^)())task;

/**
 * Executes a task synchronously in the dispatch queue specified after a delay.
 * @param queue The queue where the task will be executed.
 * @param delayInSeconds The delay in seconds.
 * @param task The task to be executed.
 */
+ (void)runAsyncUsingQueue:(dispatch_queue_t)queue withDelay:(int)delayInSeconds andTask:(void (^)())task;

@end
