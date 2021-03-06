//
//  CMD2D_ServerQueryNormalDevices.h
//  NewProtocol
//
//  Created by chendy on 13-9-14.
//  Copyright (c) 2013 year chendy. All rights reserved.
//

#import "ServerCommand.h"

///The server returned the commonly used equipment list
@interface CMD2D_ServerQueryNormalDevices : ServerCommand<APPCommandProto>

///Commonly used equipment list
@property(nonatomic,strong) NSArray* deviceList;

-(id)initWithDevices:(NSArray*)deviceList;

@end
