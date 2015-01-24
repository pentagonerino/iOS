//
//  Peertalker.h
//  ios
//
//  Created by Jorge Izquierdo on 24/01/15.
//  Copyright (c) 2015 izqui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTChannel.h"

typedef void (^StringCallback)(NSString*);

@interface Peertalker : NSObject <PTChannelDelegate>

@property (nonatomic, strong) StringCallback cb;
-(void)setupWithCallback: (StringCallback)callback;
@end
