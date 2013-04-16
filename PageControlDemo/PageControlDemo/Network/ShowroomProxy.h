//
//  ShowroomProxy.h
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Proxy.h"

@protocol ShowroomProxyDelegate <NSObject>

@optional

- (void) getShowroolList:(NSMutableArray *)showroomListArray;

@required
- (void) showRoomDidFail:(NSString *)error;

@end

@interface ShowroomProxy : Proxy
{
    id<ShowroomProxyDelegate>showroomProxyDelegate;
    NSString *requestName;
}
@property(nonatomic, assign)id<ShowroomProxyDelegate>showroomProxyDelegate;
@property(nonatomic, strong)NSString *requestName;

-(void)postShowroomListWithSpeeKeyAndUserDict:(NSString *)spreeKey
                                  andUserDict:(NSDictionary *)userDict;
-(void)saveShowroomList:(NSString *)responseString;

@end
