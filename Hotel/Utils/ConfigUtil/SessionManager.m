#import "SessionManager.h"
#import "GlobalMethod.h"
#import "MyGlobalData.h"
#import "Util.h"
#import <Protocol/Device.h>
#import <Protocol/CMDFF_ServerException.h>
#import <Protocol/CMD00_ConnectRequet.h>
#import <Protocol/CMD02_Login.h>
#import <Protocol/CMD01_ServerLoginPermit.h>
#import <Protocol/CMD03_ServerLoginRespond.h>
#import <Protocol/CMD04_GetAllDeviceList.h>
#import <Protocol/CMD05_ServerRespondAllDeviceList.h>
#import <Protocol/CMD0A_Register.h>
#import <Protocol/CMD11_ServerDelDeviceResult.h>
#import <Protocol/CMD24_QueryTimer.h>
#import <Protocol/CMD25_ServerQueryTimerResult.h>
#import <Protocol/NormalDevice.h>
#import <Protocol/SwitcherDevice.h>

#define TIMES 5
#define GAP 10
#define IsManual 2
#define ConnectHost @"connectHost"
#define ConnectPort @"connectPort"



@implementation SessionManager {
    
    CMDHelper *helper;

    NSTimer * connectTimer10;//连续发送多次连接服务器定时器
    NSTimer * timeoutTimer;  //连接超时
    NSUserDefaults * userDefault;
    NSTimer *timerIdle;
    
    NSDictionary *_errorDic;
    NSMutableData *_datas;
    
    ClientCommand *clientCommand;
}

static SessionManager* instance;

+(SessionManager*)shareSessionManager {
    if (nil == instance) {
        instance = [[SessionManager alloc]init];
    }
    return instance;
}

-(id)init {
    self = [super init];
    if (self) {
        _host = @"";
        _isConnected = NO;
        _isLogin  = NO;
        _userInfo = nil;
        _isBackground = NO;
        userDefault = [NSUserDefaults standardUserDefaults];
        helper = [CMDHelper shareInstance];
        helper.delegate = self;
        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect:) name:kSocketConnect object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close:) name:kSocketClose object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCMD:) name:kReceiveCMD object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(becomeActivity:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        
//        //根据语言加载错误列表
//        NSString *lan=[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"error_list" ofType:@"plist"inDirectory:nil forLocalization:lan];
//        if (plistPath==nil) {
//            plistPath=[[NSBundle mainBundle] pathForResource:@"error_list" ofType:@"plist"inDirectory:nil forLocalization:@"en"];
//        }
//        _errorDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return self;
}


#pragma mark- NSNotification Center
-(void)connect:(NSNotification*)notify {
    NSNumber* tag = notify.object;
    NSLog(@"连接connect socket TAG:%d",tag.intValue);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _isConnected = YES;
    [self cancelConnectTimer10s];
    [self cancelTimeoutTimer];
    
    CMD00_ConnectRequet *cmd00 = [[CMD00_ConnectRequet alloc] init];
    [self sendCmd:cmd00];
}

-(void)close:(NSNotification*)notify {
    NSNumber* tag = notify.object;
    NSLog(@"断掉close socket TAG:%d",tag.intValue);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _isConnected = NO;
    if (!_isHandClosed) {
        [self cancelAllTimer];
    }
}

- (BOOL)checkIsNet {
    return NO;
}
-(void)becomeActivity:(NSNotification*)obj{
    if ([self connected]) {
        return;
    }
    [GlobalMethod showProgressDialog:@"正在连接..."];
    _isBackground = NO;
    if (_isLogin == YES) {
        if ([helper isConnected]) {
            return;
        }
        [self startSession];
    }
}
-(void)enterBackGround:(NSNotification*)obj{
    [GlobalMethod closePressDialog];
    _isBackground = YES;
    [self cancelIdleTimer];
    [self closeSession:YES];
}



#pragma mark 接收指令
-(void)receiveCMD:(NSNotification*)obj {
   // 只要接受到指令就重新开启idle定时
    [self cancelIdleTimer];
    [self startIdleTimer];
    ServerCommand* cmd = [obj object];
    if (timeoutTimer != nil) {
        [timeoutTimer invalidate];
        timeoutTimer = nil;
    }
    if (cmd->CommandNo == [CMDFF_ServerException commandConst]) {
        [GlobalMethod closePressDialog];
        CMDFF_ServerException *cmdff = (CMDFF_ServerException*)cmd;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Combination_FF" object:nil];
        NSLog(@"%d",cmdff.code);
        NSDictionary * info;
        
        NSString *value = cmdff.info;
        
        //NSString *value = [NSString stringWithFormat:@"%@",[_errorDic objectForKey:[NSString stringWithFormat:@"%d",cmdff.code]]];
        info = [[NSDictionary alloc]initWithObjectsAndKeys:value,@"info", nil];
        
        if (cmdff.code == 6) {
            if (cmdff.info != nil) {
                info = [[NSDictionary alloc] initWithObjectsAndKeys:cmdff.info,@"info", nil];
            }else {
                info = [[NSDictionary alloc] initWithObjectsAndKeys:@"未知错误",@"info", nil];
            }
        }else if (cmdff.code == 107) {
            _currentDevice = nil;
            [userDefault setValue:@"" forKey:@"deviceId"];
            CMD04_GetAllDeviceList *cmd04 = [[CMD04_GetAllDeviceList alloc] init];
            [helper sendCMD:cmd04];
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Receive_FF" object:info];
        
    }
#pragma mark - cmd1
    if (cmd->CommandNo == [CMD01_ServerLoginPermit commandConst]) {
        CMD01_ServerLoginPermit* cmd01 = (CMD01_ServerLoginPermit*)cmd;
        if (cmd01.key == nil) {
            [self closeSession:YES];
            return;
        }
        if ([_mode isEqual:@"login"]) {
            //获取时区设置
            NSDate* currentDate = [NSDate date];
            NSTimeZone* zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate:currentDate];
            NSInteger timeZone = interval/60/60;
            NSLog(@"时区:%li",(long)timeZone);

            NSString *username = [NSString stringWithFormat:@"%@%%%@",[userDefault valueForKey:@"name"],APP_ID];
            
            CMD02_Login *cmd02 = [[CMD02_Login alloc] initWithUser:@"wifino999" Pass:HOTEL_DEFAULT_PWD Offset:(int)timeZone appid:[APP_ID intValue]];
            
            [helper sendCMD:cmd02];
        }
    }
    
    if (cmd->CommandNo == [CMD03_ServerLoginRespond commandConst]) {
      
        CMD03_ServerLoginRespond *cmd03 = (CMD03_ServerLoginRespond*)cmd;
        _userInfo = cmd03.info;
        _isHandClosed = NO;
        if (clientCommand != nil) {
            [helper sendCMD:clientCommand];
            clientCommand = nil;
        }
        if (_isLogin) {
            [GlobalMethod closePressDialog];
            return;
        }
        _isLogin  = YES;
        CMD04_GetAllDeviceList *cmd04 = [[CMD04_GetAllDeviceList alloc] init];
        [helper sendCMD:cmd04];
    }
    
#pragma mark - cmd5
    if(cmd->CommandNo == [CMD05_ServerRespondAllDeviceList commandConst]) {
        
        CMD05_ServerRespondAllDeviceList* cmd05 = (CMD05_ServerRespondAllDeviceList*)cmd;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(CommonDevice *d in cmd05.deviceList){
            [array addObject:d];
        }
        [MyGlobalData setDeviceList:nil];
        [MyGlobalData setDeviceList:array];
        
        [GlobalMethod closePressDialog];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getAllDevice" object:nil];
    }


//    if (cmd->CommandNo == [CMDFC_ServerNotifiOnline commandConst]) {
//        CMDFC_ServerNotifiOnline *cmdfc = (CMDFC_ServerNotifiOnline*)cmd;
//        for (DeviceStatus *d in  cmdfc.deviceList) {
//            if (_currentDevice != nil) {
//                if ([d.id isEqual:_currentDevice.id]) {
//                    [self checkIsNet];
//                }
//            }
//            for (int i = 0 ; i <  [MyGlobalData getDeviceList].count;i++) {
//                DeviceStatus *dd = [[MyGlobalData getDeviceList] objectAtIndex:i];
//                if ([d.id isEqual:dd.id]) {
//                    dd.online = d.online;
//                    //dd.devdata = d.devdata;
//                    dd.netinfo = d.netinfo;
//                    [[MyGlobalData getDeviceList] replaceObjectAtIndex:i withObject:dd];
//                    break;
//                }
//            }
//        }
//        //[[NSNotificationCenter defaultCenter] postNotificationName:@"notifyOnline" object:nil];
//    }
    
#pragma mark - cmd9
    if (cmd->CommandNo == [CMD09_ServerControlResult commandConst]) {
        CMD09_ServerControlResult * cmd09 = (CMD09_ServerControlResult*)cmd;
        NormalDevice * receiveDeviceStatus =(NormalDevice*) cmd09.device;
        // 收到09号指令后，将相应的设备列表更新成最新的状态
        NSMutableArray * deviceList = [MyGlobalData getDeviceList];
        NSInteger count = deviceList.count;
        for (int i = 0 ; i < count; i++) {
            //NormalDevice * tempDeviceStatus = [deviceList objectAtIndex:i];
//            if ([tempDeviceStatus.id isEqualToString:receiveDeviceStatus.id]) {
//                //tempDeviceStatus.devdata = receiveDeviceStatus.devdata;
//                tempDeviceStatus.online = receiveDeviceStatus.online;
//                [deviceList replaceObjectAtIndex:i withObject:tempDeviceStatus];
//                break;
//            }
        }
        [MyGlobalData setDeviceList:deviceList];
    }
    
#pragma mark - cmd11
    if (cmd->CommandNo == [CMD11_ServerDelDeviceResult commandConst]) {
        //CMD11_ServerDelDeviceResult *cmd11 = (CMD11_ServerDelDeviceResult*)cmd;
//        for (int i = 0; i < [MyGlobalData getDeviceList].count; i++) {
//            DeviceStatus *device = [[MyGlobalData getDeviceList] objectAtIndex:i];
//            if ([device.id isEqualToString:cmd11.status.id]) {
//                [[MyGlobalData getDeviceList] removeObject:device];
//                break;
//            }
//        }
    }


}

#pragma mark- TimerOut
- (void)cancelIdleTimer {
    if (timerIdle != nil) {
        [timerIdle invalidate];
        timerIdle = nil;
    }
}

-(void) cancelConnectTimer10s{
    if (connectTimer10 != nil ) {
        [connectTimer10 invalidate];
        connectTimer10 = nil;
    }
}

-(void) cancelTimeoutTimer{
    if (timeoutTimer != nil){
        [timeoutTimer invalidate];
        timeoutTimer = nil;
    }
}

-(void)cancelAllTimer {
    [self cancelConnectTimer10s];
    [self cancelTimeoutTimer];
    [self cancelIdleTimer];
}

-(void) connectTimeOut{
    [self cancelConnectTimer10s];
    [self cancelTimeoutTimer];
    [GlobalMethod closePressDialog];
    [GlobalMethod toast:@"网络异常,请检查网络连接!"];
}

- (void)idleTimerOut {
    [self cancelIdleTimer];
    [GlobalMethod closePressDialog];
    [self closeSession:NO];
    [Util toast:@"网络异常,请检查网络!"];
}

//app每隔30s接受到一次空得心跳指令
- (void)startIdleTimer {
    if (timerIdle == nil) {
        timerIdle = [NSTimer scheduledTimerWithTimeInterval:65 target:self selector:@selector(idleTimerOut) userInfo:nil repeats:NO];
    }
}


#pragma mark 网络会话相关
-(void)startSession {
    if (![self connected]) {
        [self closeSession:YES];
        
        _host = [userDefault valueForKey:@"Host"];
        if ([_host isEqual:@""] || _host == nil) {
            _host = HOST;
        }
        NSLog(@"startconnect.......");
        [CMDHelper setupConnectionWithIp:_host Port:PORT withTimeOut:30];
        [self cancelConnectTimer10s];
        connectTimer10 = [NSTimer scheduledTimerWithTimeInterval:GAP target:self selector:@selector(reconnect) userInfo:nil repeats:YES];
        
        timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(connectTimeOut) userInfo:nil repeats:NO];
    }
}
-(void)reconnect{
    if (![self connected]) {
        [helper connect];
    }
}

-(void)closeSession:(BOOL)sendAction {
    _isHandClosed = sendAction;
    //当手动关闭连接时，不提示网络断开
    if (sendAction) {
        [self cancelConnectTimer10s];
        [self cancelAllTimer];
        [self closeSocket];
    }
}

-(void)closeSocket{
    [helper closeWithTag:IsManual];
    _isConnected = NO;
}



-(BOOL)connected {
    _isConnected = [helper isConnected];
    return _isConnected;
}

-(void)sendCmd:(ClientCommand * )cmd{
    NSLog(@"发送指令");
    if (![self connected]) {
        if (_isLogin) {
            [Util toast:@"网络异常,请检查网络!"];
            [GlobalMethod closePressDialog];
        }
        clientCommand = cmd;
        return;
    }
    [helper sendCMD:cmd];
}

+ (void)setSM{
    instance = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CommonDevice *)CMDHelper:(CMDHelper *)helper parseDeviceWithSn:(NSString *)sn Type:(int)type State:(NSString *)state{
    
    if (type == 0x01) {
        
    }else if(type == 0x03 || type == 0x02){
        return [[SwitcherDevice alloc] init];
    }else if(type == 0x09){
        
    }else if (type == 0x0F){
        
    }else if(type == 0x14){
        
    }else if (type == 35){
        
    }else if(type == 41){
        
    }else if (type == 193){
        
    }
    
    return [[CommonDevice alloc] init];
}

@end
