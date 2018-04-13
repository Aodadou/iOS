//
//  GCDTimer.m
//  GCDTimer
//
//  Created by WJP on 16/8/15.
//  Copyright © 2016年 WJP. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer(){
    
}


@end


@implementation GCDTimer


- (id)init{
    self = [super init];
    if (self) {
        self.timerContainer = [[NSMutableDictionary alloc] init];
    }
    return self;
}

static GCDTimer *dao;
+ (GCDTimer *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dao = [[GCDTimer alloc] init];
        
    });
    return dao;
}


- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                         timerInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                                repeat:(BOOL)repeats
                                action:(dispatch_block_t)action
{
    if (nil == timerName) {
        return;
    }
    if (nil == queue) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (nil == timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerContainer setObject:timer forKey:timerName];
    }
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW,interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        action();
        
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
    });
    
}


- (void)cancelTimerWithName:(NSString *)timerName{
    
    NSLog(@"取消GCD定时器:%@",timerName);
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (nil == timer) {
        NSLog(@"GCD定时器:%@不存在",timerName);
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
    
}

- (void)doSomeThing{
    
}

@end
