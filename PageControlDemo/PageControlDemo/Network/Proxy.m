//
//  Proxy.m
//  FashionPlatform
//
//  Created by Rohit Dhiman on 8/11/12.
//
//

#import "Proxy.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "URL.h"

@implementation Proxy


#pragma mark -
#pragma mark GET Method
//Handle GET request
- (void) getRequestedDataWithURL:(NSString *)url
                 usingSessionKey:(NSString *)key
                  andRequestName:(NSString *)rName
{
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSLog(@"URL is : %@",URL);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:rName,@"RequestName", nil];
    @try {
        [request setDelegate:self];
        [request setTimeOutSeconds:60];
        [request setUserInfo:temp];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"X-Spree-Token" value:key];
        //   [request setValidatesSecureCertificate:NO];
        [request setDidFinishSelector:@selector(postSuccess:)];
        [request setDidFailSelector:@selector(postFailed:)];
        [request startAsynchronous];
        
    }
    @catch (NSException *exception) {
        //NormalLog(@"Error : %@",[exception reason]);
    }
    @finally {
        [temp release];
        //[request release];
        //[pool release];
    }
    
}

#pragma mark -
#pragma mark POST Method
//Hanlde POST request
- (void) postRequestDataWithURL:(NSString *)url
                usingSessionKey:(NSString *)key
                      usingData:(NSData *)data
                 andRequestName:(NSString *)rName
{
    NSURL *URL = [NSURL URLWithString:url];
    NSLog(@"URL is : %@",URL);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:URL];
    NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:rName,@"RequestName", nil];
    @try {
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request appendPostData:data];
        [request setUserInfo:temp];
        [request setTimeOutSeconds:60];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //   [request setValidatesSecureCertificate:NO];
        
        if([rName isEqualToString:LoginRequestName])
        {
            
        }
        else
        {
            [request addRequestHeader:@"X-Spree-Token" value:key];
        }
        [request setDidFinishSelector:@selector(postSuccess:)];
        [request setDidFailSelector:@selector(postFailed:)];
        [request startAsynchronous];
        
    }
    @catch (NSException *exception) {
        //NormalLog(@"Error : %@",[exception reason]);
    }
    @finally {
        [temp release];
        [request release];
    }
}

- (void) postMultipartRequestWithURL:(NSString *)url
                     usingSessionKey:(NSString *)key
                           usingData:(NSData *)data
                      andRequestName:(NSString *)rName
                      andProductDict:(NSDictionary *)productDict
{
    NSURL *URL = [NSURL URLWithString:url];
    NSLog(@"URL is : %@",URL);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:URL];
    NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:rName,@"RequestName", nil];
    @try {
        [request setRequestMethod:@"POST"];
        [request setPostFormat:ASIMultipartFormDataPostFormat];
        // [request setValidatesSecureCertificate:NO];
        //[request setStringEncoding:NSWindowsCP1252StringEncoding];
        [request setDelegate:self];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSError *error = nil;
        NSString *jsonBodyString = [jsonWriter stringWithObject:productDict error:&error];
        NSLog(@"getDataFromDic %@",jsonBodyString);
        NSData *jsondata = [jsonBodyString dataUsingEncoding:NSUTF8StringEncoding
                                        allowLossyConversion:YES];
        
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        NSMutableData *body = [[NSMutableData alloc] init];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]
                          dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"products\"\r\n\r\n%@", jsonBodyString] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"attachment\"; filename=\"look_photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"spree_bag.jpeg"], 1);
        [body appendData:[NSData dataWithData:imageData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //[requestData appendData:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"request_header\"\r\n\r\n%@",j]]
        
        //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"request_header\"\r\n\r\n%@", jsonHeaderString] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *dataStr = [[NSString alloc] initWithData:body
                                                  encoding:NSUTF8StringEncoding];
        NSLog(@"Data : %@",dataStr);
        
        [request appendPostData:body];
        [request setUserInfo:temp];
        [request setTimeOutSeconds:60];
        [request addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"%@",contentType]];
        
        
        if([rName isEqualToString:LoginRequestName])
        {
            
        }
        else
        {
            [request addRequestHeader:@"X-Spree-Token" value:key];
        }
        [request setDidFinishSelector:@selector(postSuccess:)];
        [request setDidFailSelector:@selector(postFailed:)];
        [request startAsynchronous];
        
    }
    @catch (NSException *exception) {
        //NormalLog(@"Error : %@",[exception reason]);
    }
    @finally {
        [temp release];
        [request release];
    }
    
}

#pragma mark -
#pragma mark PUT Method
//Handle PUT request
- (void) putRequestDataWithURL:(NSString *)url
               usingSessionKey:(NSString *)key
                     usingData:(NSData *)data
                andRequestName:(NSString *)rName
{
    NSURL *URL = [NSURL URLWithString:url];
	//NormalLog(@"URL = %@",URL);
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:URL];
	NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:rName,@"RequestName",nil];
	@try {
        [request setRequestMethod:@"PUT"];
		[request setDelegate:self];
		[request appendPostData:data];
		[request setUserInfo:temp];
		[request setTimeOutSeconds:60];
        //  [request setValidatesSecureCertificate:NO];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
		if ([rName isEqualToString:LoginRequestName]) {
			
		}
		else {
			[request addRequestHeader:@"X-Spree-Token" value:key];
		}
        
		[request setDidFinishSelector:@selector(postSuccess:)];
		[request setDidFailSelector:@selector(postFailed:)];
		[request startAsynchronous];
	}
	@catch (NSException * e) {
		//NormalLog(@"Error = %@",[e reason]);
	}
	@finally {
		[temp release];
		[request release];
	}
}

#pragma mark -
#pragma mark DELETE Method
//Handle DELETE request
- (void) deleteRequestDataWithURL:(NSString *)url
                  usingSessionKey:(NSString *)key
                   andRequestName:(NSString *)rName
{
    NSURL *URL = [NSURL URLWithString:url];
	NSLog(@"URL = %@  key %@",URL,key);
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
	NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:rName,@"RequestName",nil];
	@try {
		[request setRequestMethod:@"DELETE"];
		[request setDelegate:self];
		[request setTimeOutSeconds:60];
		[request setUserInfo:temp];
        //[request setValidatesSecureCertificate:NO];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
		[request addRequestHeader:@"X-Spree-Token" value:key];
		[request setDidFinishSelector:@selector(postSuccess:)];
		[request setDidFailSelector:@selector(postFailed:)];
		[request startAsynchronous];
	}
	@catch (NSException * e) {
		//NormalLog(@"Error = %@",[e reason]);
	}
	@finally {
		[temp release];
		[request release];
	}
}

//Hanlde DELETE request
- (void) deleteRequestDataWithURL:(NSString *)url
                  usingSessionKey:(NSString *)key
                        usingData:(NSData *)data
                   andRequestName:(NSString *)rName
{
    NSURL *URL = [NSURL URLWithString:url];
	//NormalLog(@"URL = %@",URL);
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
	NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:rName,@"RequestName",nil];
	@try {
		[request setRequestMethod:@"DELETE"];
		[request setDelegate:self];
		[request appendPostData:data];
		[request setTimeOutSeconds:60];
		[request setUserInfo:temp];
        //  [request setValidatesSecureCertificate:NO];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
		[request addRequestHeader:@"x-api-key" value:key];
		[request setDidFinishSelector:@selector(postSuccess:)];
		[request setDidFailSelector:@selector(postFailed:)];
		[request startAsynchronous];
	}
	@catch (NSException * e) {
		//NormalLog(@"Error = %@",[e reason]);
	}
	@finally {
		[temp release];
		[request release];
	}
}


#pragma mark-
#pragma mark ASIHttpDelegate Method
//Handle success response
-(void)postSuccess:(ASIHTTPRequest *)request {
    
}

//Handle fail response
-(void)postFailed:(ASIHTTPRequest *)request {
    
}

@end
