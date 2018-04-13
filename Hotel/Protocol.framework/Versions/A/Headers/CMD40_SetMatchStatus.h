//
//  CMD40_SetMatchStatus.h
//  Protocol
//
//  Created by 吴杰平 on 2018/3/28.
//  Copyright © 2018年 fortune. All rights reserved.
//

#import "ClientCommand.h"

@interface CMD40_SetMatchStatus : ClientCommand<APPCommandProto>

@property (nonatomic,assign) Byte pairInfo;
@property (nonatomic,strong) NSString *sn;

@end
