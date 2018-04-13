
#import <Foundation/Foundation.h>
//#import <Protocol/DeviceStatus.h>
#import <Protocol/GroupInfo.h>
@interface MyGlobalData : NSObject
+(NSMutableArray*)getDeviceList;
+(void)setDeviceList:(NSMutableArray*)list;

+(NSMutableArray*)getGroupList;
+(void)setGroupList:(NSMutableArray*)list;

+(NSMutableArray*)getTimerList;
+(void)setTimerList:(NSMutableArray*)list;

+(NSMutableDictionary*)getTimerDictronary;
+(void)setTimerDictronary:(NSMutableDictionary*)dic;

//+(DeviceStatus*)getSelectedDeviceStatus;
//+(void)setSelectedDeviceStatus:(DeviceStatus*)device;

+(GroupInfo*)getSelectedGroupInfo;
+(void)setSelectedGroupInfo:(GroupInfo*)groupInfo;

+(int)getOperateType;
+(void)setOperateType:(int)type;

+(int)getOperateModel;
+(void)setOperateModel:(int)model;

+(BOOL)getIsManual;//判断是否手动控制主界面的设备开关
+(void)setIsManual:(BOOL)manual;
+(BOOL)getIsGroupManual;//判断是否手动控制主界面的组开关
+(void)setIsGroupManual:(BOOL)manual;
@end
