
#import <UIKit/UIKit.h>
#import "SmartConfig1.h"

@interface ConfigVC : UIViewController<UITextFieldDelegate,SmartConfigDelegate,UIAlertViewDelegate>

@property(strong,nonatomic) NSString *groupId;
@property(strong,nonatomic) NSString *placeName;
@property(strong,nonatomic) NSString *scanValue;
@property(assign,nonatomic) BOOL isAirControl;
@property(strong,nonatomic) NSString *deviceName;

@property (strong, nonatomic) UITextField *tf_ssid;
@property (strong, nonatomic) UITextField *tf_routerPwd;
@property (strong, nonatomic)  UIButton *btn_config;

@property (strong, nonatomic)  UIImageView *img_ssidBack;
@property (strong, nonatomic)  UIImageView *img_pwdBack;
@property (strong, nonatomic)  UIButton *btn_showPwd;
@property (strong, nonatomic)  UIImageView *fastLight;
@property (strong, nonatomic)  UIImageView *wifiImage;



@property (strong, nonatomic) UIButton *btn_cancelConfig;




@end
