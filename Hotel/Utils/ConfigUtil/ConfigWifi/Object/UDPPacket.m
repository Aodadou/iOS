#import "UDPPacket.h"

@implementation UDPPacket
@synthesize prefix=_prefix,version=_version,serial=_serial,checkSum=_checkSum,code=_code;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableData *)getFixedByte
{
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendData:self.prefix];
    [data appendData:self.version];
    [data appendData:self.length];
    [data appendData:self.serial];
    [data appendData:self.checkSum];
    [data appendData:self.code];
    return data;
}

@end










//-----------------------------------
// 设备配置wifi参数
@implementation InitConnPacket
@synthesize ssid=_ssid, password=_password,serverName = _serverName,serverPort = _serverPort;

- (id)init
{
    self = [super init];
    if (self) {
        Byte h[] = {0xee,0xee};//11101110
        self.prefix = [[NSData alloc] initWithBytes:&h length:sizeof(h)];
        Byte ver = 0x00;
        self.version = [[NSData alloc] initWithBytes:&ver length:sizeof(ver)];
        Byte b_length = 0x0d;
        self.length = [[NSData alloc] initWithBytes:&b_length length:sizeof(b_length)];
        Byte b_serial[] = {0x00,0x00};
        self.serial = [[NSData alloc] initWithBytes:b_serial length:sizeof(b_serial)];
        Byte b_checkSum[] = {0x00,0x00,0x00,0x00};
        self.checkSum = [[NSData alloc] initWithBytes:&b_checkSum length:sizeof(b_checkSum)];
        Byte b_code = 0x00;
        self.code = [[NSData alloc] initWithBytes:&b_code length:sizeof(b_code)];
    }
    return self;
}

- (id)initWithSsid:(NSString *)ssid Password:(NSString *)pwd
{
    self = [self init];
    if (self) {
        _ssid = [ssid dataUsingEncoding:NSUTF8StringEncoding];
        _password = [pwd dataUsingEncoding:NSUTF8StringEncoding];
        _serverName = [SERVER_NAME  dataUsingEncoding:NSUTF8StringEncoding];//HOSTNAME//
        _serverPort = [self writeShort:SERVER_PORT];
        
//        _serverName = [@"192.168.1.117"  dataUsingEncoding:NSUTF8StringEncoding];//HOSTNAME//
//        _serverPort = [self writeShort:10226];
    }
    return self;
}

-(NSData*)writeShort:(UInt16)value
{
    Byte b0 = value & 0xff;  //与上11111111  取低八位
    Byte b1 = (value >> 8) & 0xff;//右移8位  取高八位
    Byte b[] =  {b0,b1};
    return [NSData dataWithBytes:&b length:sizeof(b)];
    
}
@end












//-----------------------------------
// 返回设备配置wifi参数结果
@implementation InitConnResult
@synthesize isSuc=_isSuc;

- (id)init
{
    self = [super init];
    if (self) {
        Byte h[] = {0xee,0xee};
        self.prefix = [[NSData alloc] initWithBytes:&h length:sizeof(h)];
        Byte ver = 0x00;
        self.version = [[NSData alloc] initWithBytes:&ver length:sizeof(ver)];
        Byte b_length = 0x0c;
        self.length = [[NSData alloc] initWithBytes:&b_length length:sizeof(b_length)];
        Byte b_serial[] = {0xcd,0xab};
        self.serial = [[NSData alloc] initWithBytes:b_serial length:sizeof(b_serial)];
        Byte b_checkSum[] = {0x00,0x00,0x00,0x00};
        self.checkSum = [[NSData alloc] initWithBytes:&b_checkSum length:sizeof(b_checkSum)];
        Byte b_code = 0x01;
        self.code = [[NSData alloc] initWithBytes:&b_code length:sizeof(b_code)];
    }
    return self;
}

- (id)initWithResult:(int)result
{
    self = [self init];
    if (self) {
        _isSuc = result;
    }
    return self;
}

@end
