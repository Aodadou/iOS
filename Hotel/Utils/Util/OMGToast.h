//
//  OMGToast.h
//  ToastDemo
//
//  Created by David Huang on 13-5-11.
//  Copyright (c) 2013年 David Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DEFAULT_DISPLAY_DURATION 2.0f

@interface OMGToast : NSObject {
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}

+ (void)showWithText:(NSString *) text_;
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;


+ (void)showWithText3s:(NSString *)text_;
+ (void)showWithTextAlways:(NSString *)text_;

- (id)initWithText:(NSString *)text_;
- (void)dismissToast;
- (void)setDuration:(CGFloat) duration_;
- (void)showFromBottomOffset:(CGFloat) bottom_;

@end
