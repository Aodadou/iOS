
#import "MyUDPSocket.h"
#import "GlobalData.h"

#import "CommandUtil.h"

@implementation MyUDPSocket {

}
@synthesize ipAddress=_ipAddress, port=_port, socket=_socket;

- (id)init{
    self = [super init];
    if (self) {
        _ipAddress = nil;
        _port = 0;
        NSError *error = nil;
        _socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
        
        [_socket bindToPort:50000 error:&error];
        //[_socket receiveWithTimeout:-1 tag:0];
    }
    return self;
}

- (void)sendToUDPServer:(UDPPacket *)packet{
    if (_ipAddress == nil) {
        _ipAddress = @"192.168.1.100";//本地局域网
    }
    if (_port == 0) {
        _port = 50000;
    }
    
    NSData *data = [CommandUtil generateCMDStringWithObject:packet];
    
    Byte *byte = (Byte *)[data bytes];
    for (int i = 0; i < [data length]; i++) {
        NSLog(@"packet [%d] is: 0x%x", i , byte[i]);
    }
    
    [_socket receiveWithTimeout:-1 tag:0];//启动接收线程
    [_socket sendData:data toHost:_ipAddress port:_port withTimeout:10 tag:1];
}
//数据接收
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    
//     [_socket receiveWithTimeout:-1 tag:0];
    NSLog(@"host:%@, port:%d",host, port);
    if (![host isEqualToString:@"192.168.1.100"]) {
         [_socket receiveWithTimeout:-1 tag:0];
        return NO;
    }

    Byte *byte = (Byte *)[data bytes];
    for (int i = 0 ; i < [data length]; i++) {
        NSLog(@"packet:x[%d]:0x%x", i ,byte[i]);
    }
    if ([data length] < 12) {
        NSLog(@"invalid data");
        return NO;
       }
    // 存储流水号
    NSRange r = {4,2};
    NSData *serial = [data subdataWithRange:r];
    [GlobalData setSerial:serial];
    
    ServerResult *result = [[ServerResult alloc] init];
    result.CMDResponse = [self resolvetoResultIdentify:data];
    result = [CommandUtil pickUpDataFromCMD:data ToResult:result];
    [self sendResultToPoster:result];
    return YES;
}
 
// 对收到的数据进行类别的分类
- (ResultIdentify)resolvetoResultIdentify:(NSData *)cmd
{
    NSRange r = {10,1};
    NSData *sub = [cmd subdataWithRange:r];
    int type = *(int *)[sub bytes];
    if (1 == type) {
        return ResultWifiSetting;
    }
    return ResultNone;
}

// 将结果给NotificationPoster通知出去
- (void)sendResultToPoster:(ServerResult *)result
{
    if (result.CMDResponse == ResultWifiSetting) {
        [[NSNotificationCenter defaultCenter] postNotificationName:InitSetting object:result];
    }
}

// 验证数据包是否正确
- (BOOL)checkData:(NSData *)data
{
    Byte *byte = (Byte *)[data bytes];
    //    for (int i = 0 ; i < [data length]; i++) {
    //        NSLog(@"packet:x[%d]:0x%x", i ,byte[i])
    //        ;
    //    }
    // 将校验字节保存起来然后清零
    int sum = 0;    // 数据中带有的校验和
    for (int i = 6; i < 10; i++) {
        NSLog(@"receive:packet:x[%d]:0x%x", i ,byte[i]);
        sum += [CommandUtil readInt:byte[i]];
    }
    NSMutableData *temp = [NSMutableData dataWithData:data];
    NSRange r = {6,4};
    Byte b[] = {0x00,0x00,0x00,0x00};
    [temp replaceBytesInRange:r withBytes:b];
    
    // 计算校验和
    NSData *checkSum = [CommandUtil calculateCheckSum:temp WithTag:checkSum_receiveTag];
    Byte *rs = (Byte *)[checkSum bytes];
    for (int i = 0; i < 4; i++) {
        NSLog(@"calc:packet:x[%d]:0x%x", i ,rs[i]);
    }
    int check_sum = 0;  // 重新计算出的校验和
    for (int i = 0; i < [checkSum length]; i++) {
        check_sum += [CommandUtil readInt:rs[i]];
    }
    
    if (sum == check_sum) {
        return YES;
    }
    return NO;
}
-(void)closeSocket{
    if (!_socket) {
        [_socket close];
    }
}


@end
