//
//  ShowroomProxy.h
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShowroomProxyDelegate <NSObject>

@optional

- (void) getShowroolList:(NSMutableArray *)showroomListArray;

@required


@end

@interface ShowroomProxy : NSObject
{
    id<ShowroomProxyDelegate>showroomProxyDelegate;
    NSString *requestName;
}
@property(nonatomic, assign)id<ShowroomProxyDelegate>showroomProxyDelegate;
@property(nonatomic, strong)NSString *requestName;

-(void)postShowroomList;
-(void)saveShowroomList:(NSString *)responseString;

@end
