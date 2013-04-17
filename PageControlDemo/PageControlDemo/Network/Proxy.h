//
//  Proxy.h
//  FashionPlatform
//
//  Created by Rohit Dhiman on 8/11/12.
//
//

#import <Foundation/Foundation.h>

@interface Proxy : NSObject

//Handle GET request
- (void) getRequestedDataWithURL:(NSString *)url
                 usingSessionKey:(NSString *)key
                  andRequestName:(NSString *)rName;

//Handle POST request
- (void) postRequestDataWithURL:(NSString *)url
                usingSessionKey:(NSString *)key
                      usingData:(NSData *)data
                 andRequestName:(NSString *)rName;

//Handle PUT request
- (void) putRequestDataWithURL:(NSString *)url
               usingSessionKey:(NSString *)key
                     usingData:(NSData *)data
                andRequestName:(NSString *)rName;

//Handle DELETE request
- (void) deleteRequestDataWithURL:(NSString *)url
                  usingSessionKey:(NSString *)key
                   andRequestName:(NSString *)rName;

//Handle DELETE request
- (void) deleteRequestDataWithURL:(NSString *)url
                  usingSessionKey:(NSString *)key
                        usingData:(NSData *)data
                   andRequestName:(NSString *)rName;




@end
