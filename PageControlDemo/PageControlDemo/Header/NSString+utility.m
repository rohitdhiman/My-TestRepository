//*********************************************************************************
//  Name  			:		NSString+Common.h
//	Description		:		This file is used to add methods to use NSString  
//							more efficiently.
//*********************************************************************************

#import "NSString+utility.h"

@implementation NSString (utility)



-(BOOL)isStringPresent {
	if ([self isBlank] || (self == nil) || ([self isKindOfClass:[NSNull class]])) {
		return NO;
	}
	return YES;
}

-(BOOL)isBlank {
	if([[self stringByStrippingWhitespace] length] == 0) {
		return YES;
	}
	return NO;
}

-(BOOL)contains:(NSString *)string {
	NSRange range = [self rangeOfString:string];
	return (range.location != NSNotFound);
}

-(NSString *)stringByStrippingWhitespace {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSArray *)splitOnChar:(char)ch {
	NSMutableArray *results = [[NSMutableArray alloc] init];
	int start = 0;
	for(int i=0; i<[self length]; i++) {
		
		BOOL isAtSplitChar = [self characterAtIndex:i] == ch;
		BOOL isAtEnd = i == [self length] - 1;
				
		if(isAtSplitChar || isAtEnd) {
			//take the substring & add it to the array
			NSRange range;
			range.location = start;
			range.length = i - start + 1;
			
			if(isAtSplitChar)
				range.length -= 1;
			
			[results addObject:[self substringWithRange:range]];
			start = i + 1;
		}
		
		//handle the case where the last character was the split char.  we need an empty trailing element in the array.
		if(isAtEnd && isAtSplitChar)
			[results addObject:@""];
	}
	
	return results ;
}
	
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to {
	NSString *rightPart = [self substringFromIndex:from];
	return [rightPart substringToIndex:to-from];
}	


/**
 * This method will return NSNotFound as location if the str is not found. 
 */
-(int) indexOfString: (NSString *) str {
	NSRange range = [self rangeOfString:str];
	return range.location;
}


/**
 * This method will return NSNotFound as location if the str is not found. 
 */
-(int) lastIndexOfString:(NSString *) str {
	NSRange range = [self rangeOfString:str options:NSBackwardsSearch];
	return range.location;
}



@end
