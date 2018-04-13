

#import <Foundation/Foundation.h>

#import "UDPPacket.h"
#import "ServerResult.h"

@interface CommandUtil : NSObject

+ (NSData *)generateCMDStringWithObject:(UDPPacket *)packet;

+ (ServerResult *)pickUpDataFromCMD:(NSData *)cmd ToResult:(ServerResult *)result;

+ (NSData *)calculateCheckSum:(NSMutableData *)cmd WithTag:(int)tag;

+ (int8_t)readInt:(Byte)b;

+ (Byte)writeInt:(int8_t) value;

@end
