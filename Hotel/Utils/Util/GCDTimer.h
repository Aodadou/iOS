//
//  GCDTimer.h
//  GCDTimer
//
//  Created by WJP on 16/8/15.
//  Copyright © 2016年 WJP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTimer : NSObject

@property (nonatomic,strong) NSMutableDictionary *timerContainer;

+ (GCDTimer *)shareManager;

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                         timerInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                                repeat:(BOOL)repeats
                                action:(dispatch_block_t)action;


- (void)cancelTimerWithName:(NSString *)timerName;

- (id)init;

@end
