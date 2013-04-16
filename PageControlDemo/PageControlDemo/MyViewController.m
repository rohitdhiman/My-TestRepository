//
//  MyViewController.m
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@property (nonatomic, assign) int pageNumber;

@end

@implementation MyViewController
@synthesize pageNumber = _pageNumber;
@synthesize pageNumberLabel = _pageNumberLabel;
@synthesize numberTitle = _numberTitle;
@synthesize numberImage = _numberImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPageNumber:(NSUInteger)page
{
    if (self = [super initWithNibName:@"MyViewController" bundle:nil])
    {
        _pageNumber = page;
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
