

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject

+ (void)setSerial:(NSData *)data;
+ (NSData *)getSerial;

+ (void)setKey:(NSData *)data;
+ (NSData *)getKey;

@end
