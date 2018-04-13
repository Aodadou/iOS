#import "CommandUtil.h"

#import "Util.h"
#import "GlobalData.h"

@implementation CommandUtil

+ (NSData *)generateCMDStringWithObject:(UDPPacket *)packet
{
    // 设置流水号,如果没有接收到流水号，则流水号为0000
    if (nil != [GlobalData getSerial]) {
        packet.serial = [GlobalData getSerial];
    }
    // 设备配置wifi参数
    if ([packet isKindOfClass:[InitConnPacket class]]) {
        InitConnPacket *temp = (InitConnPacket *)packet;
        
        //计算出数据的完整长度
        Byte length = 0x0e;  //长度14
        
        int l = [self readInt:length];
        l = (int)(l + [temp.ssid length] + [temp.password length]+[temp.serverName length]+[temp.serverPort length]);
        length = [self writeInt:l];
        temp.length = [[NSData alloc] initWithBytes:&length length:sizeof(length)];
        
        //组包
        Byte len_ssid = [self writeInt:[temp.ssid length]];
        Byte len_password = [self writeInt:[temp.password length]];
        Byte len_server = [self writeInt:[temp.serverName length]];
        
        NSMutableData *data;// = [[NSMutableData alloc] init];
        data = [temp getFixedByte];
        [data appendBytes:&len_ssid length:sizeof(len_ssid)];
        [data appendData:temp.ssid];
        [data appendBytes:&len_password length:sizeof(len_password)];
        [data appendData:temp.password];
        [data appendBytes:&len_server length:sizeof(len_server)];
        [data appendData:temp.serverName];
        [data appendData:temp.serverPort];
        // 返回带有校验和的data
        return [self generateDataWithCheckSum:data];
        
    // 发送初始化设备wifi参数结果
    } else if ([packet isKindOfClass:[InitConnResult class]]) {
        InitConnResult *temp = (InitConnResult *)packet;
        // 组包
        NSMutableData *data;//= [[NSMutableData alloc] init];
        data = [temp getFixedByte];
        Byte result = [self writeInt:temp.isSuc];
        [data appendBytes:&result length:sizeof(result)];
        return [self generateDataWithCheckSum:data];
    }
    return nil;
}

+(int8_t)readInt:(Byte)b {
    return b & 0xff;     //取低八位
}

+(Byte)writeInt:(int8_t) value {
    return value;
}

// 从收到的数据中提取出所需的内容
+ (ServerResult *)pickUpDataFromCMD:(NSData *)cmd ToResult:(ServerResult *)result
{
    NSRange r = {11, 1};
    NSData *sub = [cmd subdataWithRange:r];
    if (result.CMDResponse == ResultWifiSetting) {
        int b = *(int *)[sub bytes];
        result.isInitSucc = b;
        return result;
    }
    return nil;
}

// 得到带有校验和的命令
+ (NSMutableData *)generateDataWithCheckSum:(NSMutableData *)cmd
{
    // 得到校验和
    NSData *checkSum = [self calculateCheckSum:cmd WithTag:checkSum_sendTag];
    // 设置校验和
    NSRange r = {6,4};
    [cmd replaceBytesInRange:r withBytes:[checkSum bytes]];
    
    return cmd;
}

// 生成校验和
+ (NSData *)calculateCheckSum:(NSMutableData *)cmd WithTag:(int)tag
{
    Byte *byte = (Byte *)[cmd bytes];
    int sum1 = 0, sum2 = 0, sum3 = 0, sum4 = 0;
    for (int i = 0; i < [cmd length]; i += 4) {
        sum1 += [CommandUtil readInt:byte[i]];
    }
    for (int i = 1; i < [cmd length]; i += 4) {
        sum2 += [CommandUtil readInt:byte[i]];
    }
    for (int i = 2; i < [cmd length]; i += 4) {
        sum3 += [CommandUtil readInt:byte[i]];
    }
    for (int i = 3; i < [cmd length]; i += 4) {
        sum4 += [CommandUtil readInt:byte[i]];
    }
    // 去掉进位
    sum1 = sum1 & 255;
    sum2 = sum2 & 255;
    sum3 = sum3 & 255;
    sum4 = sum4 & 255;
    
    // 如果key存在先得到key
    Byte key[] = {0x00,0x00,0x00,0x00};
    if (nil != [GlobalData getKey]) {
//        key = [GlobalData getKey];
        
    }
    // 数据再运算
    sum1 = sum1 + [CommandUtil readInt:byte[5]] + [CommandUtil readInt:key[0]];
    sum2 = sum2 + [CommandUtil readInt:byte[5]] + [CommandUtil readInt:key[1]] + sum1;
    sum3 = sum3 + [CommandUtil readInt:byte[5]] + [CommandUtil readInt:key[2]] + sum2;
    sum4 = sum4 + [CommandUtil readInt:byte[5]] + [CommandUtil readInt:key[3]] + sum3;
    
    // 再次去掉进位
    sum1 = sum1 & 255;
    sum2 = sum2 & 255;
    sum3 = sum3 & 255;
    sum4 = sum4 & 255;
    
    // 拼装数据
    Byte sumOne = [CommandUtil writeInt:sum1];
    Byte sumTwo = [CommandUtil writeInt:sum2];
    Byte sumThree = [CommandUtil writeInt:sum3];
    Byte sumFour = [CommandUtil writeInt:sum4];
    NSMutableData *result = [[NSMutableData alloc] init];
    [result appendBytes:&sumOne length:sizeof(sumOne)];
    [result appendBytes:&sumTwo length:sizeof(sumTwo)];
    [result appendBytes:&sumThree length:sizeof(sumThree)];
    [result appendBytes:&sumFour length:sizeof(sumFour)];
    
    return [NSData dataWithData:result];
}

@end
