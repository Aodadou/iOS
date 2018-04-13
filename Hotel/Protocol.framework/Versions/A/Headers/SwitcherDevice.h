
#import <Foundation/Foundation.h>
#import "CommonDevice.h"
#import "Power.h"
@interface SwitcherDevice : CommonDevice


-(id)initWithId:(NSString*)id_ Pid:(NSString*)pid Name:(NSString*)name Place:(NSString*)place Online:(BOOL)online Power:(NSArray*)powers;

///power status
@property(nonatomic,strong) NSArray<Power *>* powerList;

///set power status of first way
-(void)setOneWayPower:(BOOL)on;

/// get power status of first way
-(BOOL)getOneWayPower;


@end
