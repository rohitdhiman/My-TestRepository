//
//  MyViewController.h
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController
{
    UILabel *pageNumberLabel;
    UILabel *numberTitle;
    UIImageView *numberImage;
}

@property (nonatomic, strong) IBOutlet UILabel *pageNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberTitle;
@property (nonatomic, strong) IBOutlet UIImageView *numberImage;

- (id)initWithPageNumber:(NSUInteger)page;

@end
