//
//  PagingViewController.m
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import "PagingViewController.h"
#import "MyViewController.h"

static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";

@interface PagingViewController ()

- (void)loadScrollViewWithPage:(NSUInteger)page;
- (void)gotoPage:(BOOL)animated;

@property (nonatomic, strong) NSMutableArray *contentList;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation PagingViewController
@synthesize contentList = _contentList;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize viewControllers = _viewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //read from plist
    // load our data from a plist file inside our app bundle

    NSString *path = [[NSBundle mainBundle]pathForResource:@"content_iPhone"
                                                    ofType:@"plist"];
    
    _contentList = [NSMutableArray arrayWithContentsOfFile:path];

    
    //----------//
    NSUInteger numberOfPage = _contentList.count;
    
    _viewControllers = [[NSMutableArray alloc] init];
     for (NSUInteger i = 0; i < numberOfPage; i++)
    {
        [_viewControllers addObject:[NSNull null]];
    }
    
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * numberOfPage, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    
    _pageControl.numberOfPages = numberOfPage;
    _pageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    NSUInteger page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth ) + 1;
    _pageControl.currentPage = page;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}


- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if(page >= _contentList.count)
        return ;
    
    MyViewController *myViewController = [_viewControllers objectAtIndex:page];
    if((NSNull *)myViewController == [NSNull null])
    {
        myViewController = [[MyViewController alloc] initWithPageNumber:page];
        [_viewControllers replaceObjectAtIndex:page withObject:myViewController];
    }
    
    if(myViewController.view.superview == nil)
    {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        myViewController.view.frame = frame;
        
        [self addChildViewController:myViewController];
        [_scrollView addSubview:myViewController.view];
        [myViewController didMoveToParentViewController:self];
        
        NSDictionary *numberItem = [_contentList objectAtIndex:page];
        myViewController.numberImage.image = [UIImage imageNamed:[numberItem valueForKey:kImageKey]];
        myViewController.numberTitle.text = [numberItem valueForKey:kNameKey];
    }
    
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = _pageControl.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];

    CGRect bounds = _scrollView.bounds;
    bounds.origin.x = bounds.size.width * page;
    bounds.origin.y = 0;
    [_scrollView scrollRectToVisible:bounds
                            animated:animated];
    
}

- (IBAction)changePage:(id)sender
{
     [self gotoPage:YES];
}

@end
