

#import "SmartConfig1.h"
static SmartConfig1 *instance;
@implementation SmartConfig1

+ (SmartConfig1 *)getInstance {
    if (instance == nil) {
        instance = [[SmartConfig1 alloc] init];
    }
    return instance;
}
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)initUdpSocket {
    _sersocket =  [[AsyncUdpSocket alloc] initWithDelegate:self];
     [_sersocket enableBroadcast:YES error:nil];
    NSError  *error;
    
    [_sersocket bindToPort:50001 error:&error];//50001
    NSLog(@"Error:%@",error);
    [_sersocket receiveWithTimeout:-1 tag:0];
}
- (void)startConfig:(NSString*)wifiName wifiPas:(NSString*)password  {
    _wifiName = wifiName;
    wifiPas = password;
    communication = [OneShotConfig getInstance];
    macAddress = nil;
    isStopConfig = NO;
    [self closeSocket];
    [self initUdpSocket];
    [NSThread detachNewThreadSelector:@selector(configWIFI) toTarget:self withObject:nil];
    
}
- (void)configWIFI {
    @autoreleasepool {
        while (!isStopConfig) {
            int status = [communication startConfig:_wifiName  pwd:wifiPas];
            NSLog(@"status:%d",status);
            if (status == -1) {
                [self stopConfig];
                if ([self.delegate respondsToSelector:@selector(configFailed)]) {
                    [self.delegate configFailed];
                }
                return;
            }
            [NSThread sleepForTimeInterval:0.1];
        }
    }
}
- (void)stopConfig {
    isStopConfig = YES;
    [self closeSocket];
    [communication stopConfig];
   
}

- (void)closeSocket {
    if (_sersocket != nil) {
        [_sersocket close];
        _sersocket = nil;
    }

}


//下面是发送的相关回调函数
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    [sock receiveWithTimeout:-1 tag:0];
    if ([host hasPrefix:@"::"] || [host hasPrefix:@"ee"]) {
        return YES;
    }
    int prex = [[host substringWithRange:NSMakeRange(0,3)] intValue];
    if (prex >= 256 || prex < 1) {
        return YES;
    }
    NSInteger len = [data length];
    if (len != 25 && len != 33) {
        return YES;
    }
    Byte *bytes = (Byte*)[data bytes];
    if (bytes[0] != 0xEE
        || bytes[1] != 0xEE
        || bytes[2] != 0x00
        || bytes[21] != 0x53
        || bytes[22] != 0x52) {
        //return YES;
    }
    NSString *hexStr = @"";
    for (int i =11 ; i < 17; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    hexStr = [hexStr uppercaseString];
    macAddress = hexStr;
    ip = host;
    [self stopConfig];
    if ([self.delegate respondsToSelector:@selector(configSuccess:host:)]) {
        [self.delegate configSuccess:macAddress host:ip];
    }
    return YES;
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotSendDataWithTag----");
    
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotReceiveDataWithTag----");
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"didSendDataWithTag----");
}
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"onUdpSocketDidClose----");
}


@end
