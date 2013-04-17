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
@synthesize activityIndicator = _activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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

//For downloading in background and cached the images.
- (void)downloadImageWithURL : (NSString *)imageURL
{
    [self.activityIndicator startAnimating];
    [self performSelectorInBackground:@selector(downloadImageInBackground:) withObject:imageURL];
    
}
- (void)downloadImageInBackground : (NSString *)imageURL
{
    if ([imageURL hasPrefix:@"https://"]) {
        imageURL = [imageURL stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSMutableString *profileimgPath = [NSMutableString stringWithFormat:@"%@",documentsDirectory];
    //[profileimgPath appendString:@"/showroom/logo"];
    [profileimgPath appendString:[NSString stringWithFormat:@"/%d.jpg",[imageURL hash]]];
    NSLog(@"Image url %@",profileimgPath);
    NSData *tempImageData = [NSData dataWithContentsOfFile:profileimgPath];
    UIImage *tempImage = [UIImage imageWithData:tempImageData];
    
    if(![tempImage isKindOfClass:[NSNull class]] && tempImage!=nil)
    {
        [self.numberImage performSelectorOnMainThread:@selector(setImage:) withObject:tempImage waitUntilDone:NO];
        [self.activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    }
    else
    {
        NSData *profileimageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *product_Image = [[UIImage alloc] initWithData:profileimageData];
        
        if(![product_Image isKindOfClass:[NSNull class]] && product_Image!=nil)
        {
            [self.numberImage performSelectorOnMainThread:@selector(setImage:) withObject:product_Image waitUntilDone:NO];
            
            [self.activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            
            BOOL filestore = [profileimageData writeToFile:profileimgPath atomically:YES];
            
            if (filestore) {
                
            }
        }
    }
    
}

@end
