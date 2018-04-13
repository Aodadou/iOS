//
//  ServerResult.h
//  UDPServer_Client
//
//  Created by gabo on 13-9-11.
//  Copyright (c) 2013年 Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    // 此项表示为定义
    ResultNone = 0,
    // 设备配置wifi参数结果
    ResultWifiSetting = 1,
    
}ResultIdentify;

@interface ServerResult : NSObject{
    ResultIdentify _CMDResponse;
    int _isInitSucc;
}

@property (nonatomic, assign) ResultIdentify CMDResponse;
@property (nonatomic, assign) int isInitSucc;

@end
