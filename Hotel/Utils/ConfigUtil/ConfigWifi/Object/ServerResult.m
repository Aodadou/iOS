//
//  ServerResult.m
//  UDPServer_Client
//
//  Created by gabo on 13-9-11.
//  Copyright (c) 2013年 Enterprise. All rights reserved.
//

#import "ServerResult.h"

@implementation ServerResult
@synthesize CMDResponse=_CMDResponse,isInitSucc=_isInitSucc;

- (id)init
{
    self = [super init];
    if (self) {
        _CMDResponse = ResultNone;
        _isInitSucc = 0;
    }
    return self;
}

@end
