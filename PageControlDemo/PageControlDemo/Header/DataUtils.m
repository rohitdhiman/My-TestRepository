//
//  DataUtils.m
//  FashionPlatform
//
//  Created by Rohit Dhiman on 8/11/12.
//
//

#import "DataUtils.h"
#import "SBJson.h"

@implementation DataUtils

#pragma mark
#pragma mark Conversion Methods

+ (NSData *) dataFromDictionry : (NSDictionary *)dict
{
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSError *error = nil;
    NSString *jsonString = [jsonWriter stringWithObject:dict error:&error];
    NSLog(@"getDataFromDic %@",jsonString);
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding
                            allowLossyConversion:YES];
    return data;
}

+ (NSData *) dataFromArray : (NSMutableArray *)array
{
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSError *error = nil;
    NSString *jsonString = [jsonWriter stringWithObject:array error:&error];
    NSLog(@"getDataFromArray : %@",jsonString);
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding
                            allowLossyConversion:YES];
    return data;
}

+(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end
