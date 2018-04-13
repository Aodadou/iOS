
#import <Foundation/Foundation.h>
#import "UDPPacket.h"
#import "AsyncUdpSocket.h"

@interface MyUDPSocket : NSObject
{
    NSString *_ipAddress;
    int _port;
    AsyncUdpSocket *_socket;
}

@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, assign) int port;
@property (nonatomic, strong) AsyncUdpSocket *socket;

- (void)sendToUDPServer:(UDPPacket *)packet;
- (void)closeSocket;
@end
