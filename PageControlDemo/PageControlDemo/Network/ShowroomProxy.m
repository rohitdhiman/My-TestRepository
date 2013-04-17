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
    //[urlStr appendString:@"users/sign_in"];
    //[urlStr appendFormat:@"log_in%@",JSON];
    /*
    NSDictionary *request_header = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"dev_ts",@"201304106180750", @"anta_profile_key",@"18862013031910371515",
                                    @"dev_lang",@"ja",
                                    @"profile",@"milu@1",
                                    @"anta_access_token",@"miC5pBtQEPVHo",
                                    @"app_ver",@"4.0",
                                    nil];
    NSData *data1 = [DataUtils dataFromDictionry:request_header];
    
    NSDictionary *request_body = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"profile_id",@"1886",
                                    @"filter_type",2,
                                    nil];
    NSData *data2 = [DataUtils dataFromDictionry:request_body];
    
    NSDictionary *request_paging = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"page_count",0,
                                    @"page_id",0,
                                    @"last_index",0,
                                    nil];
    NSData *data3 = [DataUtils dataFromDictionry:request_paging];
*/
   
    
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
