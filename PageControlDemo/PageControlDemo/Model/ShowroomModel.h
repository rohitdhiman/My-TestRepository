//
//  ShowroomModel.h
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowroomModel : NSObject
{
    NSString *showroom_id;
    NSString *showroom_name;
    NSString *showroom_city;
    NSString *showroom_country;
    NSString *is_showroom_followed;
    NSString *showroom_logo;
    NSString *showroom_banner;

}

@property (nonatomic, strong) NSString *showroom_id;
@property (nonatomic, strong) NSString *showroom_name;
@property (nonatomic, strong) NSString *showroom_city;
@property (nonatomic, strong) NSString *showroom_country;
@property (nonatomic, strong) NSString *is_showroom_followed;
@property (nonatomic, strong) NSString *showroom_logo;
@property (nonatomic, strong) NSString *showroom_banner;

-(NSDictionary *)jsonMapping;
+(ShowroomModel *)showroomModelFromDictionary:(NSDictionary *)dictionary;
+(NSDictionary *)dictionaryFromAddressModel:(ShowroomModel *)showroomModel;


@end
