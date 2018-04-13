
#import <Foundation/Foundation.h>
#import "SessionManager.h"

#define SERVER_NAME HOST
#define SERVER_PORT CF_PORT
@interface UDPPacket : NSObject{
    // 协议头
    NSData *_prefix;
    // 版本
    NSData *_version;
    // 长度
    NSData *_length;
    // 流水号
    NSData *_serial;
    // 校验和
    NSData *_checkSum;
    // 编码
    NSData *_code;
}

@property (nonatomic, strong) NSData *prefix;
@property (nonatomic, strong) NSData *version;
@property (nonatomic, strong) NSData *length;
@property (nonatomic, strong) NSData *serial;
@property (nonatomic, strong) NSData *checkSum;
@property (nonatomic, strong) NSData *code;

- (NSMutableData *)getFixedByte;

@end






// 设备配置wifi参数
@interface InitConnPacket : UDPPacket{
    // wifi名称
    NSData *_ssid;
    // wifi密码
    NSData *_password;
    //服务器名称
    NSData *_serverName;
    //服务器端口
    NSData *_serverPort;
}
@property (nonatomic, strong) NSData *ssid;
@property (nonatomic, strong) NSData *password;
@property (nonatomic, strong) NSData *serverName;
@property (nonatomic, strong) NSData *serverPort;
- (id)initWithSsid:(NSString *)ssid Password:(NSString *)pwd;

@end







// 返回设备配置wifi参数结果
@interface InitConnResult : UDPPacket
{
    int _isSuc;
}

@property (nonatomic, assign) int isSuc;

- (id)initWithResult:(int)result;

@end
