
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShakeDirection) {
    ShakeDirectionHorizontal,
    ShakeDirectionVertical
};

@interface UITextField (Shake)

- (void)shake;
- (void)shake:(int)times withDelta:(CGFloat)delta;
- (void)shake:(int)times withDelta:(CGFloat)delta completion:(void((^)()))handler;
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^)()))handler;
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection;
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection completion:(void((^)()))handler;

@end
