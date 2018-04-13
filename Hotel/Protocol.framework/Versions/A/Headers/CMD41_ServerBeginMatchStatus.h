//
//  CMD41_ServerBeginMatchStatus.h
//  Protocol
//
//  Created by 吴杰平 on 2018/3/28.
//  Copyright © 2018年 fortune. All rights reserved.
//

#import <Protocol/Protocol.h>


@interface CMD41_ServerBeginMatchStatus : ServerCommand

@property (assign,nonatomic) Byte pairInfo;
@property (nonatomic,strong) NSString *sn;
@property (nonatomic,assign) Boolean success;

@end
