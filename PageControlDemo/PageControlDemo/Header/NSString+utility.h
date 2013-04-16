//*********************************************************************************
//  Name  			:		NSString+Common.h
//	Description		:		This file is used to add methods to use NSString  
//							more efficiently.
//*********************************************************************************

#import <Foundation/Foundation.h>


@interface NSString (utility) 

-(BOOL)isStringPresent;
-(BOOL)isBlank;
-(BOOL)contains:(NSString *)string;
-(NSArray *)splitOnChar:(char)ch;
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
-(NSString *)stringByStrippingWhitespace;

-(int) indexOfString: (NSString *) str;
-(int) lastIndexOfString:(NSString *) str;


@end
