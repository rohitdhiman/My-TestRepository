//
//  ShowroomModel.m
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import "ShowroomModel.h"

@implementation ShowroomModel
@synthesize showroom_id;
@synthesize showroom_name;
@synthesize showroom_city;
@synthesize showroom_country;
@synthesize is_showroom_followed;
@synthesize showroom_logo;
@synthesize showroom_banner;


-(NSDictionary *)jsonMapping
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"showroom_id",@"showroom_id",
            @"showroom_name",@"showroom_name",
            @"showroom_city",@"showroom_city",
            @"showroom_country",@"showroom_country",
            @"is_showroom_followed",@"is_showroom_followed",
            @"showroom_logo",@"showroom_logo",
            @"showroom_banner",@"showroom_banner",
            nil];
}

+(ShowroomModel *)showroomModelFromDictionary:(NSDictionary *)dictionary
{
    ShowroomModel *showroomModel = [[ShowroomModel alloc] init];
    NSDictionary *mapping = [showroomModel jsonMapping];
    for(NSString *attribute in [mapping allKeys])
    {
        NSString *classProperty = [mapping objectForKey:attribute];
        NSString *attributeValue = [dictionary objectForKey:attribute];
        if(attributeValue != nil && !([attributeValue isKindOfClass:[NSNull class]]))
        {
            [showroomModel setValue:attributeValue forKey:classProperty];
        }
    }
    return showroomModel;

}

+(NSDictionary *)dictionaryFromAddressModel:(ShowroomModel *)showroomModel
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSDictionary *mapping = [showroomModel jsonMapping];
    for(NSString *attribute in [mapping allKeys])
    {
        NSString *classProperty = [mapping objectForKey:attribute];
        if([showroomModel valueForKeyPath:attribute] == nil)
        {
            [dict setValue:[NSNull null] forKey:classProperty];
        }
        else
        {
            NSString *attributeValue = [showroomModel valueForKeyPath:attribute];
            if(attributeValue != nil && !([attributeValue isKindOfClass:[NSNull class]]))
            {
                [dict setValue:attributeValue forKey:classProperty];
            }
        }
    }
    return dict;

}

@end
