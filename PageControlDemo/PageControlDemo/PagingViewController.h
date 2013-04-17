//
//  PagingViewController.h
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagingViewController : UIViewController <UIScrollViewDelegate, NSURLConnectionDelegate>
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    UIButton *flickerButton;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *flickerButton;

- (IBAction)changePage:(id)sender;
- (IBAction)flickerButtonTapped:(id)sender;

@end
