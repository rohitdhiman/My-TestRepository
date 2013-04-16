//
//  PagingViewController.h
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagingViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;

@end
