

#import <Foundation/Foundation.h>

@interface ThreeDES : NSObject
//加密,key为byte数组的NSData
+ (NSString*)encrypt:(NSString*)plainText withKey:(NSData*)key;
//解密,key为byte数组的NSData
+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSData*)key;
//16进制字符串转成NSData
+ (NSData*)HexStringToNSData:(NSString*) hexString;
//NSData转成16进制
+ (NSString*)NSDataToHexString:(NSData*) data;
+ (NSString*)encryptWithDefautKey:(NSString*)plainText;
- (NSString*)sha1:(NSString*) hexString;

+(NSString *)deEncryptWithDefautKey:(NSString *)encryptText;
@end
