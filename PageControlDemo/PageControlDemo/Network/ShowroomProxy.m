//
//  ShowroomProxy.m
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import "ShowroomProxy.h"
#import "Proxy.h"
#import "URL.h"

@implementation ShowroomProxy
@synthesize requestName = _requestName;
@synthesize showroomProxyDelegate = _showroomProxyDelegate;

#pragma mark
#pragma mark PostMethod
-(void)postShowroomList
{
    NSMutableString *urlStr = [[NSMutableString alloc] initWithFormat:@"%@",BASEURL];
    [urlStr appendString:@"users/sign_in"];
    //[urlStr appendFormat:@"log_in%@",JSON];
    NSData *data = [DataUtils dataFromDictionry:userDict];
    [super postRequestDataWithURL:urlStr
                  usingSessionKey:spreeKey
                        usingData:data
                   andRequestName:UserSignInRequestName];

}

-(void)saveShowroomList:(NSString *)responseString
{
    
}

@end
