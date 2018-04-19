
#import "ConfigVC.h"

// 一键配置
#define CONFIG_TIME_OUT 60
#import "ControlTcpSocket.h"
#import "Util.h"
#import "ConfigWifi.h"
#import "CMDFactory.h"


#import "Hotel-Swift.h"
#import "Bolloon.h"
#import "GlobalMethod.h"
#import "SessionManager.h"
#import "Reachability.h"
#import "MyGlobalData.h"
#import <Protocol/CMD03_ServerLoginRespond.h>
#import <Protocol/CMD04_GetAllDeviceList.h>
#import <Protocol/CMD0C_AddMasterDevice.h>
#import <Protocol/CMD0D_ServerAddMasterDeviceResult.h>
#import <Protocol/CMD16_QueryUserInfo.h>
#import <Protocol/CMD17_ServerQueryUserResult.h>
#import "Masonry.h"

#define TIMES 3
#define PASSWORD_KEY @"wifiPassword"
#define WIFINAME_KEY @"wifiName"

#define TEMP_TIME_OUT 10
#define CHECK_WIFI_TIME 0.5
#define ADD_DEVICE_TIME_OUT 30

@interface ConfigVC (){
//一键配置
    SmartConfig1 *smartConfig;
    CMDFactory *cmdFactory;
    ConfigWifi *configWifi;
    NSTimer *timerOut;                //一键配置接受不到数据没有代理成功或失败时的超时处理

    
    NSUserDefaults * userDefaults;
    NSTimer * addDeviceTimer;//配置成功后添加设备timer
    
    UIView *backView;
    UIView *navCoverView;
    UIView *coverView;
    int angle;
    BOOL isStop;
    NSTimer *lightTimer;
    SessionManager *sm;
    NSString *deviceName;
    NSString *macAddress;             //匹配到的Mac地址
    NSString *wifi_ssid;             //Wi-Fi名称
    id info;                          //Wi-Fi信息
    Reachability *reach;             //检测网络是否连通
    
}
@end

@implementation ConfigVC

#pragma mark- 一键配置
//一键配置
//###########################################################################
//第一步：一键配置，发送路由器信息给设备

- (void)onceConfig:(UIButton *)sender{
    if (sm.controlTcp != nil) {
        [sm.controlTcp closeSocket];
    }
    self.wifiImage.hidden = NO;
    macAddress = @"";
    deviceName = @"一键配置设备";
    [self cancelAllTimer];
    
    if ([sender.titleLabel.text isEqualToString:@"取消配置"]) {
        
        [self.btn_config setTitle:@"配置设备" forState:UIControlStateNormal];
        [self stopConfing];
        [sm closeSession:YES];
        
        isStop = YES;
        return;
    }else {
        [self.btn_config setTitle:@"取消配置" forState:UIControlStateNormal];
        [sm startSession];
        [self startConfig];
        [self startAnimation];
    }
    
}

- (void)startConfig {
    [smartConfig startConfig:self.tf_ssid.text wifiPas:self.tf_routerPwd.text];
    timerOut = [NSTimer scheduledTimerWithTimeInterval:CONFIG_TIME_OUT target:self selector:@selector(configFailed) userInfo:nil repeats:NO];
}
- (void)stopConfing{
    [smartConfig stopConfig];
}

//########################################################################SmartConfig代理
//第二步：发送成功之后，建立tcp连接，向设备发送服务器信息
- (void)configSuccess:(NSString *)mac host:(NSString *)host {
    macAddress  = mac;
    sm.controlTcp = [[ControlTcpSocket alloc]init];
    [sm.controlTcp startToConnectServer:host];
    sm.controlTcp.mode = 1;
    NSArray *hosts = [sm.host componentsSeparatedByString:@"."];
    Byte hots[] = {[hosts[0] integerValue],[hosts[1] integerValue],[hosts[2]integerValue],[hosts[3] integerValue]};
    NSData *hostData = [NSData dataWithBytes:&hots length:4];
    
    int len = (int)[hostData length] + 3;
    Byte lenByte[] = {len-3};
    NSData *lenData = [NSData dataWithBytes:&lenByte length:1];
    int low = 221;
    int high = 221 >> 8;
    Byte portByte[] = {low,high};
    NSData *portData = [NSData dataWithBytes:&portByte length:2];
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:lenData];
    [data appendData:hostData];
    [data appendData:portData];
    
    [sm.controlTcp sendData:data];
}
//###############################################################################
//第三步：发送服务器信息给设备后，接收通知
- (void)configSuccess:(NSNotification*)noti {
    //[GlobalMethod toast:@"设备同步成功"];
    [self.btn_config setTitle:@"配置设备" forState:UIControlStateNormal];
    NSString *status = [noti object];
    if ([status isEqualToString:@"1"]) {
        [self cancelAllTimer];
        [sm closeSession:YES];
        [sm startSession];
        [GlobalMethod showProgressDialog:@"正在添加"];
        addDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self
                                                        selector:@selector(sendCmdTimeOut) userInfo:nil repeats:NO];
    }else {
        [self configFailed];
    }
}

- (void)configFailed {
    NSLog(@"一键配置失败");
    [self sendCmdTimeOut];
    [smartConfig stopConfig];
}

#pragma mark - 视图周期
//##############################################################
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCMD:) name:kReceiveCMD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAllDevice:) name:@"getAllDevice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFF:) name:@"Receive_FF" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configSuccess:) name:CONFIG_STATUS object:nil];
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"配置设备";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = MainBackColor;
    UILabel *lb_ssid = [[UILabel alloc] init];
    lb_ssid.text = @"路由器名称";
    UILabel *lb_pws = [[UILabel alloc] init];
    lb_pws.text = @"路由器密码";
    lb_ssid.textColor = TFColor;
    lb_pws.textColor = TFColor;
    self.tf_routerPwd = [[UITextField alloc] init];
    self.tf_ssid = [[UITextField alloc] init];
    self.img_pwdBack = [[UIImageView alloc] init];
    self.img_ssidBack = [[UIImageView alloc] init];
    self.btn_showPwd = [[UIButton alloc] init];
    self.btn_config = [[UIButton alloc] init];
    self.wifiImage = [[UIImageView alloc] init];
    self.fastLight = [[UIImageView alloc] init];

    [self.view addSubview:lb_ssid];
    [self.view addSubview:lb_pws];
    [self.view addSubview:self.img_ssidBack];
    [self.view addSubview:self.img_pwdBack];
    [self.view addSubview:self.tf_routerPwd];
    [self.view addSubview:self.tf_ssid];
    [self.view addSubview:self.btn_showPwd];
    [self.view addSubview:self.btn_config];
    [self.view addSubview:self.wifiImage];
    [self.view addSubview:self.fastLight];
    
    
    self.img_ssidBack.image = ImageWithContentFile(@"/配置设备输入框.png");
    self.img_pwdBack.image = ImageWithContentFile(@"/配置设备输入框.png");
    self.wifiImage.image = ImageWithContentFile(@"/WIFI配置.png");
    [self.btn_showPwd setBackImageForStatusWithNormal:@"记住密码按钮.png" highLight:@"记住密码按钮按下.png"];
    [self.btn_config setBackImageForStatusWithNormal:@"登陆按钮.png" highLight:@"登陆按钮按下.png"];
    self.fastLight.image = ImageWithContentFile(@"/快闪灯.png");
    self.fastLight.hidden = YES;
    [self.btn_config setTitle:@"配置设备" forState:UIControlStateNormal];
    [self.btn_config setTintColor:[UIColor whiteColor]];
    [self.tf_ssid setTextColor: TFColor];
    [self.tf_routerPwd setTextColor:TFColor];
    self.tf_routerPwd.secureTextEntry = YES;
    [self.btn_config addTarget:self action:@selector(config:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_showPwd addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];

    
    [lb_ssid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).with.multipliedBy(555 / 750.0);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(15);
        make.centerX.equalTo(self.view);
    }];
    [_img_ssidBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(lb_ssid);
        make.height.equalTo(lb_ssid.mas_width).with.multipliedBy(115 / 555.0);
        make.centerX.equalTo(self.view);
        make.top.equalTo(lb_ssid.mas_bottom).offset(15);
    }];
    [_tf_ssid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.left.equalTo(_img_ssidBack.mas_left).offset(10);
        make.right.equalTo(_img_ssidBack.mas_right).offset(-10);
        make.center.equalTo(_img_ssidBack);
    }];
    [lb_pws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(lb_ssid.mas_width);
        make.height.equalTo(lb_ssid.mas_height);
        make.left.equalTo(lb_ssid.mas_left);
        make.top.equalTo(_img_ssidBack.mas_bottom).offset(15);
    }];
    [_img_pwdBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(lb_ssid);
        make.height.equalTo(_img_ssidBack);
        make.centerX.equalTo(self.view);
        make.top.equalTo(lb_pws.mas_bottom).offset(15);
    }];
    [_btn_showPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_img_pwdBack).with.multipliedBy(2.0 / 3);
        make.width.equalTo(_btn_showPwd.mas_height);
        make.right.equalTo(_img_pwdBack.mas_right).offset(-10);
        make.centerY.equalTo(_img_pwdBack);
    }];
    [_tf_routerPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.left.equalTo(_img_pwdBack.mas_left).offset(10);
        make.right.equalTo(_btn_showPwd.mas_left).offset(10);
        make.centerY.equalTo(_img_pwdBack);
    }];
    [_btn_config mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(lb_ssid);
        make.height.equalTo(_img_ssidBack);
        make.centerX.equalTo(self.view);
        make.top.equalTo(_img_pwdBack.mas_bottom).offset(40);
    }];
    [_wifiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_btn_config).with.multipliedBy(0.25);
        make.height.equalTo(_wifiImage.mas_width).multipliedBy(78 / 59.0);
        make.top.equalTo(_btn_config.mas_bottom).offset(29);
        make.centerX.equalTo(_btn_config);
    }];
    [_fastLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wifiImage);
        make.width.equalTo(_wifiImage.mas_width);
        make.height.equalTo(_wifiImage.mas_width);
        make.centerX.equalTo(_btn_config);
    }];
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftItem;
    CGRect leftBarItemRect = CGRectMake(0, 20, 44, 44);
    UIButton *leftBarItem = [[UIButton alloc] initWithFrame:leftBarItemRect];
    leftBarItem.backgroundColor = [UIColor clearColor];
    [leftBarItem setTitle:@"" forState:(UIControlStateNormal)];
    [leftBarItem setImage:[UIImage imageNamed:@"返回按钮"] forState:(UIControlStateNormal)];
    [leftBarItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftBarItem.tag = 999;
    [[UIApplication sharedApplication].keyWindow addSubview:leftBarItem];
    
    NSString * wifiname =[self.tf_routerPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (wifiname.length <= 0) {
        self.btn_showPwd.hidden = true;
    }else{
        self.btn_showPwd.hidden = false;
    }
    userDefaults = [NSUserDefaults standardUserDefaults];
    info = [GlobalMethod getNetworkInfo];
    wifi_ssid = [info objectForKey:@"SSID"];
    self.tf_ssid.text = wifi_ssid;
    if (self.tf_ssid.text){
        self.tf_routerPwd.text = [userDefaults valueForKey:self.tf_ssid.text];
    }
    self.tf_routerPwd.delegate = self;
    self.tf_ssid.delegate = self;
    sm = [SessionManager shareSessionManager];
    [sm closeSession:YES];
    
    configWifi = [[ConfigWifi alloc]init];
    cmdFactory  = [CMDFactory getInstance];
    smartConfig  = [SmartConfig1 getInstance];
    smartConfig.delegate = self;

    //reachablity 的使用，看网络是否属于连接状态
    NSLog(@"开启网络检测");
    reach = [Reachability reachabilityWithHostname:HOST];//HOST
    NSLog(@"-- current status: %d", reach.currentReachabilityStatus);
    

    
    if([[UIScreen mainScreen] bounds].size.height == 480){
        self.fastLight.hidden = YES;
    }
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    backView = [[UIView alloc] init];
    backView.frame = UIScreen.mainScreen.bounds;
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self.view addSubview:backView];
    
    navCoverView = [[UIView alloc] init];
    navCoverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    navCoverView.backgroundColor = [UIColor blackColor];
    navCoverView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:navCoverView];
    
    
//    if([[UIScreen mainScreen] bounds].size.height == 480){
//        CGRect frame = self.fastLight.frame;
//        frame.origin.y = SCREEN_HEIGHT / 2;
//
//        self.fastLight.transform = CGAffineTransformMakeTranslation(0, -150);
//        self.fastLight.hidden = NO;
//
//    }
    
    
    
    for(UIView *v in [UIApplication sharedApplication].keyWindow.subviews){
        if (v.tag == 999){
            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:v];
        }
    }
    
    [self firstStep];
    angle = 0;
    
    CGRect frame = self.fastLight.frame;
    frame.origin.y += 0.5;
    frame.origin.x -= 0.5;
    self.fastLight.hidden = NO;
    coverView = [[UIView alloc] init];
    coverView.frame = frame;
    coverView.backgroundColor = [UIColor grayColor];
    coverView.layer.cornerRadius = frame.size.width / 2;
    coverView.alpha = 0.5;
    [self.view addSubview:coverView];
    
    [lightTimer invalidate];
    lightTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startLight) userInfo:nil repeats:true];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(backView){
        [backView removeFromSuperview];
        backView = nil;
        [navCoverView removeFromSuperview];
        navCoverView = nil;
    }
    
    for(UIView *view in self.view.subviews){
        [view.layer removeAllAnimations];
    }
    
    for(UIView *v in [UIApplication sharedApplication].keyWindow.subviews){
        if (v.tag == 999){
            [v removeFromSuperview];
        }
    }
    
    sm.controlTcp.mode = 0;
    if (![sm isConnected]) {
        [sm startSession];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self cancelAllTimer];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//保持到用户配置文件中去
-(void)saveDataToUserDefaults {
    if (self.tf_ssid.text.length > 0) {
        [userDefaults setObject:self.tf_routerPwd.text forKey:self.tf_ssid.text];
    }
    [userDefaults synchronize];
}


- (void)dealloc{
    NSLog(@"配置界面销毁了");
}

#pragma mark- 响应事件
- (void)config:(id)sender {
    
    NSString * name =[self.tf_ssid.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (name.length <=0) {
        [GlobalMethod toast:@"请连接至有效Wifi"];
        return;
    }
    [self saveDataToUserDefaults];
    //开始旋转动画
    
    [self onceConfig:sender];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}





- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPassword:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 10){
        [self.tf_routerPwd setSecureTextEntry:YES];
        
        NSString *p = [[NSBundle mainBundle] resourcePath];
        NSString *path = [p stringByAppendingString:@"/记住密码按钮.png"];
        
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        btn.tag = 11;
    }else{
        [self.tf_routerPwd setSecureTextEntry:NO];
        
        NSString *p = [[NSBundle mainBundle] resourcePath];
        NSString *path = [p stringByAppendingString:@"/记住密码按钮按下.png"];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        btn.tag = 10;
    }
}



-(void)tfReturn{
    [self.tf_ssid resignFirstResponder];
    [self.tf_routerPwd resignFirstResponder];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self tfReturn];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == self.tf_routerPwd){
        self.btn_showPwd.hidden = false;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == self.tf_routerPwd){
        NSString * wifiname =[self.tf_routerPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (wifiname.length <= 0) {
            self.btn_showPwd.hidden = true;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self tfReturn];
    return true;
}

#pragma mark- NSNotificationCenter通知

-(void)receiveCMD:(NSNotification*)obj{
    ServerCommand * cmd = [obj object];
    if (cmd->CommandNo == [CMD03_ServerLoginRespond commandConst]) {
        [self cancelAddDeviceTimer];
        CMD03_ServerLoginRespond * cmd03 = (CMD03_ServerLoginRespond*)cmd;
        if (cmd03.result) {
            
            //NSArray *arr = [self.scanValue componentsSeparatedByString:@"-"];
            //NSString *snPwd = arr[1];
            if (macAddress == nil || [macAddress isEqualToString:@""]) {
                return;
            }
            
            
            NSString *subMac;
            if ([macAddress length] == 12){
                subMac = [macAddress substringFromIndex:9];
            }else{
                subMac = [macAddress substringFromIndex:11];
            }
            
            NSLog(@"您所添加的设备mac:%@",macAddress);
            
            NSString *trueDname = [NSString stringWithFormat:@"%@-%@",deviceName,subMac];
            
            int devType;
            if (macAddress.length == 12) {
                devType = 0;
            }else{
                devType = (int)[[macAddress substringToIndex:2] integerValue];
            }

            CMD0C_AddMasterDevice * cmd0c = [[CMD0C_AddMasterDevice alloc] initWithPass:HOTEL_DEFAULT_PWD Mac:macAddress Name:trueDname Place:@"" DeviceType:devType];
            [sm sendCmd:cmd0c];
            
        }
    }
    if (cmd->CommandNo == [CMD0D_ServerAddMasterDeviceResult commandConst]) {
        [self cancelAddDeviceTimer];
        CMD0D_ServerAddMasterDeviceResult * cmd0d = (CMD0D_ServerAddMasterDeviceResult*)cmd;
        [self.btn_config setTitle:@"配置设备" forState:(UIControlStateNormal)];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        [self cancelAllTimer];
        isStop = YES;
        macAddress = nil;
        
        [GlobalMethod closePressDialog];
        if (cmd0d.result == YES) {

            [GlobalMethod toast:@"添加成功"];
            
            [self.navigationController popToRootViewControllerAnimated:true];
            
        }else{
            [GlobalMethod toast:@"设备添加失败"];
        }
        
    }

    
}

-(void)receiveAllDevice:(NSNotification*)obj{
    [self cancelAddDeviceTimer];
    [GlobalMethod closePressDialog];
}

-(void)receiveFF:(NSNotification *)obj{
    [self.btn_config setTitle:@"配置设备" forState:(UIControlStateNormal)];
    self.btn_config.enabled = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    isStop = YES;
    [self cancelAllTimer];
    [GlobalMethod closePressDialog];
    NSString * infoFF = [obj.object objectForKey:@"info"];
    
    if ([infoFF containsString:@"设备已被添加过"]){
        [GlobalMethod toast3s:[NSString stringWithFormat:@"设备已被添加过\nSN:%@",macAddress]];
        [userDefaults setValue:@"true" forKey:@"tabIsReturnTo1"];
        [userDefaults synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:true];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefresh" object:nil];
        macAddress = nil;
    }else{
        [GlobalMethod toast:infoFF];
    }
    
}

-(void)becomeActive:(NSNotificationCenter*)obj{
    info = [GlobalMethod getNetworkInfo];
}
-(void)enterBackGround:(NSNotificationCenter*)obj{
    [self tfReturn];
}


#pragma mark- 定时响应

-(void)sendCmdTimeOut{
    macAddress = nil;
    [self.btn_config setTitle:@"配置设备" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self cancelAllTimer];
    [GlobalMethod closePressDialog];
    isStop = YES;
    [GlobalMethod toast:@"信号被外星人劫持了\n1.请检查Wifi密码是否输入正确\n2.若密码正确请把设备恢复出厂设置重新配置"];
}

-(void)cancelAddDeviceTimer{
    if(addDeviceTimer){
        [addDeviceTimer invalidate];
        addDeviceTimer = nil;
    }
}

-(void)cancelConfigTimer{
    if (timerOut) {
        [timerOut invalidate];
        timerOut = nil;
    }
}

-(void)cancelAllTimer{
    
    [self cancelAddDeviceTimer];
    
    [self cancelConfigTimer];
}




#pragma mark- 配置导航和动画
/**配置动画##############################################################*/
-(void) startAnimation{
    self.wifiImage.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.wifiImage.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation{
    if(!isStop){
        angle += 10;
        [self startAnimation];
    }else{
        self.wifiImage.transform = CGAffineTransformMakeRotation(0);
        isStop = NO;
    }
}

-(void)startLight{
    if(coverView.alpha == 0.5){
        [UIView animateWithDuration:0.2 animations:^{
            coverView.alpha = 0;
        }];
        
    }else if(coverView.alpha == 0){
        [UIView animateWithDuration:0.2 animations:^{
            coverView.alpha = 0.5;
        }];
    }
}

-(void)endLight{
    [lightTimer invalidate];
    [coverView removeFromSuperview];
}


/**进入界面的导航##############################################################*/
-(void)firstStep{
    [self.view bringSubviewToFront:self.fastLight];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, self.fastLight.frame.origin.y + self.fastLight.frame.size.height, SCREEN_WIDTH, 80);
    label.numberOfLines = 0;
    label.text = @"长按设备按钮即可让指示灯处于快速模式\n并确保手机处于wifi连接模式";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.tag = 500;
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    
    CGFloat buttonWidth = self.btn_config.frame.size.width * 0.6;
    CGFloat buttnHeight = self.btn_config.frame.size.height - 10;
    CGFloat buttonX = (SCREEN_WIDTH - buttonWidth) / 2;
    CGFloat buttonY = label.frame.origin.y + label.frame.size.height;
    if([[UIScreen mainScreen] bounds].size.height == 480){
        buttonY = SCREEN_HEIGHT - 2 * buttnHeight;
    }else if([[UIScreen mainScreen] bounds].size.height == 568){
        buttonY = SCREEN_HEIGHT - buttnHeight - 5;
    }
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake( buttonX, buttonY, buttonWidth, buttnHeight);
    [button setBackgroundImage:[UIImage imageNamed:@"已连接已快闪按钮.png"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(sureFastLight) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"已连接已快闪" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = 501;
    
    CGFloat bolloonWidth = 115;
    CGFloat bolloonHeight = 100;
    CGFloat bolloonX = SCREEN_WIDTH / 2;
    CGFloat bolloonY = self.fastLight.frame.origin.y - 100;
    CGRect upRect = CGRectMake(bolloonX, bolloonY, bolloonWidth, bolloonHeight);
    Bolloon *bolloon = [[Bolloon alloc] initWithString:@"指示灯快闪" frame:upRect is:YES];
    bolloon.tag = 502;
    [self.view addSubview:bolloon];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    
}

- (void)sureFastLight{
    for(UIView *view in self.view.subviews){
        if(view.tag == 500 || view.tag == 502 || view.tag == 501){
            [view removeFromSuperview];
        }
    }
    self.fastLight.hidden = YES;
    [self.fastLight removeFromSuperview];
    [self endLight];
    [self secondStep];
    //count++;
}

-(void)secondStep{
    
    [self.view bringSubviewToFront:self.img_pwdBack];
    [self.view bringSubviewToFront:self.tf_routerPwd];
    [self.view bringSubviewToFront:self.btn_showPwd];
    CGRect upRect = CGRectMake(self.view.frame.size.width / 2, self.img_pwdBack.frame.origin.y - 100, 115, 100);
    Bolloon *bolloon = [[Bolloon alloc] initWithString:@"输入路由器密码" frame:upRect is:YES];
    bolloon.tag = 503;
    [self.view addSubview:bolloon];
    
    
    
    CGFloat buttonWidth = self.btn_config.frame.size.width * 0.6;
    CGFloat buttnHeight = self.btn_config.frame.size.height - 10;
    CGFloat buttonX = (SCREEN_WIDTH - buttonWidth) / 2;
    CGFloat buttonY = self.btn_config.frame.origin.y + self.btn_config.frame.size.height + 30;
    CGRect btnNextFrame = CGRectMake(buttonX, buttonY, buttonWidth, buttnHeight);
    UIButton *btnNext = [[UIButton alloc] init];
    btnNext.frame = btnNextFrame;
    [btnNext setBackgroundImage:[UIImage imageNamed:@"已连接已快闪按钮.png"] forState:UIControlStateNormal];
    btnNext.backgroundColor = [UIColor clearColor];
    [btnNext addTarget:self action:@selector(sureInputPwd) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnNext.tag = 504;
    
    [self.view addSubview:btnNext];
}

- (void)sureInputPwd{
    
    for(UIView *view in self.view.subviews){
        if(view.tag == 503 || view.tag == 504){
            [view removeFromSuperview];
        }
    }
    

    [self overStep];

    
}

- (void)thirdStep{
    [self.view bringSubviewToFront:backView];
    CGFloat iphoneH = SCREEN_HEIGHT * 0.55;
    CGFloat iphoneW = iphoneH * 0.542;
    CGFloat iphoneX = (SCREEN_WIDTH - iphoneW) / 2 + (iphoneW * 0.123) / 2;
    
    CGFloat iphoneY = 30;
    
    if([[UIScreen mainScreen] bounds].size.height == 480){
        iphoneY = 65;
    }
    CGRect iphoneFrame = CGRectMake(iphoneX, iphoneY, iphoneW, iphoneH);
    UIImageView *img_iphone = [[UIImageView alloc] initWithFrame:iphoneFrame];
    
    NSString *p = [[NSBundle mainBundle] resourcePath];
    NSString *path = [p stringByAppendingString:@"/ios多一步图.png"];
    
    img_iphone.image = [UIImage imageWithContentsOfFile:path];
    img_iphone.tag = 505;
    [self.view addSubview:img_iphone];
    
    CGFloat labelY = img_iphone.frame.origin.y + img_iphone.frame.size.height + SCREEN_HEIGHT * (150/1134);
    CGFloat labelH = 70;
    CGFloat labelW = SCREEN_WIDTH;
    CGFloat labelX = 0;
    CGRect labelRect = CGRectMake(labelX, labelY, labelW, labelH);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 3;
    label.textColor = [UIColor whiteColor];
    label.text = @"返回手机系统“设置” “WiFi”选项\n选择“wifino1”并连接，返回本APP\n选择“下一步”";
    label.tag = 506;
    [self.view addSubview:label];
    
    CGFloat buttonWidth = self.btn_config.frame.size.width * 0.6;
    CGFloat buttnHeight = self.btn_config.frame.size.height - 10;
    CGFloat buttonX = (SCREEN_WIDTH - buttonWidth) / 2;
    CGFloat buttonY = label.frame.origin.y + label.frame.size.height + 20;//SCREEN_HEIGHT - 2 * buttnHeight;//
    CGRect btnNextFrame = CGRectMake(buttonX, buttonY, buttonWidth, buttnHeight);
    UIButton *btnNext = [[UIButton alloc] init];
    btnNext.frame = btnNextFrame;
    [btnNext setBackgroundImage:[UIImage imageNamed:@"已连接已快闪按钮.png"] forState:UIControlStateNormal];
    btnNext.backgroundColor = [UIColor clearColor];
    [btnNext addTarget:self action:@selector(overStep) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnNext.tag = 507;
    [self.view addSubview:btnNext];
}

-(void)overStep{
    [self.tf_routerPwd resignFirstResponder];
    
    for(UIView *view in self.view.subviews){
        if(view.tag == 505 || view.tag == 506 || view.tag == 507){
            [view removeFromSuperview];
        }
        [backView removeFromSuperview];
        [navCoverView removeFromSuperview];
    }
    
    self.wifiImage.hidden = NO;
    
    CGFloat labelY = self.wifiImage.frame.origin.y + self.wifiImage.frame.size.height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY + 10, SCREEN_WIDTH, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.tf_routerPwd.textColor;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"设备指示灯由慢闪变成常亮即配置成功";
    [self.view addSubview:label];
    
}
/**以上是进入界面的导航##############################################################*/



@end
