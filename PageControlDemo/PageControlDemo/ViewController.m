//
//  ViewController.m
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import "ViewController.h"

static NSUInteger kNumberOfPage = 7;

@interface ViewController ()

- (void) loadScrollViewWithPage:(int)page;

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, assign) BOOL pageControlUsed;

@end

@implementation ViewController
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize viewControllerArray = _viewControllerArray;
@synthesize pageNumber = _pageNumber;
@synthesize pageControlUsed = _pageControlUsed;

- (id)initWithPageNumber:(int)page
{
    if(self == [super initWithNibName:@"ViewController" bundle:nil])
    {
        _pageNumber = page;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //create viewcontroller
    _viewControllerArray = [[NSMutableArray alloc] init];
    for(int i=0;i<kNumberOfPage;i++)
    {
        [_viewControllerArray addObject:[NSNull null]];
    }
    
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * kNumberOfPage, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    _pageControl.numberOfPages = kNumberOfPage;
    _pageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    
}

- (void) loadScrollViewWithPage:(int)page
{
    if(page < 0) return;
    if(page >= kNumberOfPage) return;
    
    ViewController *viewController = [_viewControllerArray objectAtIndex:page];
    if((NSNull *)viewController == [NSNull null])
    {
        viewController = [[ViewController alloc] initWithPageNumber:page];
        [_viewControllerArray replaceObjectAtIndex:page withObject:viewController];
    }
    
    if(nil == viewController.view.superview)
    {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        viewController.view.frame = frame;
        [_scrollView addSubview:viewController.view];
    }

}

-(void) scrollViewDidScroll:(UIScrollView *)sender
{
    if(_pageControlUsed)
    {
        return;
    }
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
    pageControl.currentPage = page;
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changePage:(id)sender
{
    int page = _pageControl.currentPage;
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];

    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    _pageControlUsed = YES;
    
    /*
    int page = pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
    */

}

@end
