
#import "GlobalData.h"


NSData *serial;
NSData *key;

@implementation GlobalData

+ (void)setSerial:(NSData *)data
{
    Byte *b = (Byte *)[data bytes];
    for (int i = 0 ; i < [data length]; i++) {
        NSLog(@"serial:%x", b[i]);
    }
    serial = data;
}

+ (NSData *)getSerial
{
    return serial;
}

+ (void)setKey:(NSData *)data
{
    key = data;
}

+ (NSData *)getKey
{
    return key;
}

@end
