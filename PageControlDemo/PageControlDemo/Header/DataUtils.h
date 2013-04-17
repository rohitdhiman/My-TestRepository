//
//  DataUtils.h
//  FashionPlatform
//
//  Created by Rohit Dhiman on 8/11/12.
//
//

#import <Foundation/Foundation.h>

@interface DataUtils : NSObject

+ (NSData *) dataFromDictionry : (NSDictionary *)dict;
+ (NSData *) dataFromArray : (NSMutableArray *)array;
+ (BOOL) isValidEmail:(NSString *)checkString;

@end
