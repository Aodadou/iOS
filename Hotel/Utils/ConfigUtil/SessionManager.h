#import <Protocol/UserInfo.h>
#import <Protocol/ClientCommand.h>
#import <Protocol/CMDHelper.h>
#import <Protocol/CMD09_ServerControlResult.h>
#import "ControlTcpSocket.h"

#define GAP_TIMER 2
#define MAX_RETRY_TIMES 5;
#define HARD_VERSION  0x02

#define HOST @"112.74.205.249"//正式服务器
#define APP_ID @"0"
#define PORT 10227
#define APP_VERSION @"10000"

#define HOTEL_DEFAULT_PWD @"123"


@interface SessionManager : NSObject<CMDHelperDelegate>

@property(nonatomic,strong) NSString *host;
@property(nonatomic,strong) NSString* mode;
@property(nonatomic,strong) UserInfo *userInfo;
@property(nonatomic,strong) Device *currentDevice;//当前操作设备
@property(nonatomic,assign) BOOL isLogin;//是否登陆
@property(nonatomic,assign) BOOL isBackground;//程序是否后台运行
@property(nonatomic,assign) BOOL isHandClosed;//是否手动关闭
@property(nonatomic,assign,readonly) BOOL isConnected;//是否连接到服务器

@property(nonatomic,strong) ControlTcpSocket *controlTcp;

+(SessionManager*)shareSessionManager;

-(void)startSession;

-(void)closeSession:(BOOL)sendAction;

-(void)sendCmd:(ClientCommand * )cmd;

-(BOOL)checkIsNet;

-(BOOL)connected;

+(void)setSM;

@end
