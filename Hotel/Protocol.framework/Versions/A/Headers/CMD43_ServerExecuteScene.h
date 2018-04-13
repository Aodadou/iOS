//
//  CMD43_ServerExecuteScene.h
//  Protocol
//
//  Created by 吴杰平 on 2018/3/28.
//  Copyright © 2018年 fortune. All rights reserved.
//

#import <Protocol/Protocol.h>
#import "ServerCommand.h"

@interface CMD43_ServerExecuteScene : ServerCommand<APPCommandProto>

@property (nonatomic,strong) NSString *sceneId;

@end
