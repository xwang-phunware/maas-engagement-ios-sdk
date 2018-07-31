//
//  NSObject.m

//
//  Created on 3/17/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "NSObject+GcdHelper.h"

@implementation NSObject (GcdHelper)

+ (void)runAsyncTaskInBackground:(void (^)())backgroundTask
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), backgroundTask);
}

+ (void)runSyncTaskInBackground:(void (^)())backgroundTask
{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), backgroundTask);
}

+ (void)runAsyncTaskInForeground:(void (^)())foregroundTask
{
    dispatch_async(dispatch_get_main_queue(), foregroundTask);
}

+ (void)runSyncTaskInForeground:(void (^)())foregroundTask
{
    dispatch_sync(dispatch_get_main_queue(), foregroundTask);
}

+ (void)runAsyncUsingQueue:(dispatch_queue_t)queue andTask:(void (^)())task
{
    dispatch_async(queue, task);
}

+ (void)runSyncUsingQueue:(dispatch_queue_t)queue andTask:(void (^)())task
{
    dispatch_sync(queue, task);
}

+ (void)runAsyncUsingQueue:(dispatch_queue_t)queue withDelay:(int)delayInSeconds andTask:(void (^)())task
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), queue, ^{
        task();
    });
}

@end
