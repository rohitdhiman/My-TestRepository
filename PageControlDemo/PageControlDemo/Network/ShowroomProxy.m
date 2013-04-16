//
//  ShowroomProxy.m
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import "ShowroomProxy.h"
#import "URL.h"
#import "DataUtils.h"
#import "Proxy.h"
#import "ASIHTTPRequest.h"

@implementation ShowroomProxy
@synthesize requestName = _requestName;
@synthesize showroomProxyDelegate = _showroomProxyDelegate;

#pragma mark
#pragma mark PostMethod
-(void)postShowroomListWithSpeeKeyAndUserDict:(NSString *)spreeKey
                                  andUserDict:(NSDictionary *)userDict
{
    NSMutableString *urlStr = [[NSMutableString alloc] initWithFormat:@"%@",BASEURL];
    [urlStr appendString:@"users/sign_in"];
    //[urlStr appendFormat:@"log_in%@",JSON];
    NSData *data = [DataUtils dataFromDictionry:userDict];
    [super postRequestDataWithURL:urlStr
                  usingSessionKey:spreeKey
                        usingData:data
                   andRequestName:UserShowRoomRequestName];

}
#pragma mark
#pragma mark ASIHttp Delegate method
//Success response
- (void) postSuccess : (ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSRange range = [responseString rangeOfString:@"<!DOCTYPE html>"];
    if(range.length > 0)
    {
        if(_showroomProxyDelegate)
        {
            //On failed response returned from server call userDidFail: delegate method with error
            [_showroomProxyDelegate showRoomDidFail:[[request error] localizedDescription]];
        }
    }
    else
    {
        NSDictionary *userInfo = [request userInfo];
        _requestName = [userInfo objectForKey:@"RequestName"];
        if([_requestName isEqualToString:UserShowRoomRequestName] )
        {
            //on successfull response to parse json, call  saveUserDetail: with responseString
            [self saveShowroomList:responseString];
        }
    }
    
}

//Fail response
- (void) postFailed : (ASIHTTPRequest *)request
{
    if(_showroomProxyDelegate)
    {
        //On failed response returned from server call userDidFail: delegate method with error
        [_showroomProxyDelegate showRoomDidFail:[[request error] localizedDescription]];
    }
}

-(void)saveShowroomList:(NSString *)responseString
{
    
}

@end
