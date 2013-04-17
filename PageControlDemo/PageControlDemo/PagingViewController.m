//
//  PagingViewController.m
//  PageControlDemo
//
//  Created by Rohit Dhiman on 16/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import "PagingViewController.h"
#import "MyViewController.h"
#import "SBJson.h"
#import "ShowroomModel.h"

static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";

@interface PagingViewController ()

- (void)loadScrollViewWithPage:(NSUInteger)page
                   andImageURL:(NSString *)showroomImageURL;

- (void)gotoPage:(BOOL)animated;
- (void)configureViewWithShowroomImage:(NSString *)showroomImageURL;


@property (nonatomic, strong) NSMutableArray *contentList;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSMutableArray *showroomImageArray;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) NSUInteger totalPageCount;
@property (nonatomic, strong) MyViewController *myViewController;

@end

@implementation PagingViewController
@synthesize contentList = _contentList;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize viewControllers = _viewControllers;
@synthesize receivedData = _receivedData;
@synthesize totalPageCount = _totalPageCount;
@synthesize showroomImageArray = _showroomImageArray;
@synthesize myViewController = _myViewController;

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

    
    
    ///webservice
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dvm.zoolook.me/showroom/list"]];
    
    [request setHTTPMethod:@"POST"];
    
    //Request Header
    NSDictionary *request_header = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"dev_ts",@"201304106180750",
                                    @"anta_profile_key",@"18862013031910371515",
                                    @"dev_lang",@"ja",
                                    @"profile",@"milu@1",
                                    @"anta_access_token",@"miC5pBtQEPVHo",
                                    @"app_ver",@"4.0",
                                    nil];
    
    NSDictionary *request_body = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"profile_id",@"1886",
                                  @"filter_type",@"2",
                                  nil];
    
    NSDictionary *request_paging = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"page_count",@"0",
                                    @"page_id",@"0",
                                    @"last_index",@"0",
                                    nil];
    

    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSError *error = nil;
    NSString *request_headerJsonString = [jsonWriter stringWithObject:request_header error:&error];
    NSString *request_bodyJsonString = [jsonWriter stringWithObject:request_body error:&error];
    NSString *request_pagingJsonString = [jsonWriter stringWithObject:request_paging error:&error];
    
    NSString *post =[NSString stringWithFormat:@"request_header=%@&request_body=%@&request_paging=%@",request_headerJsonString,request_bodyJsonString,request_pagingJsonString];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding
                          allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Length"];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self];
    if(connection)
    {
        _receivedData = [[NSMutableData alloc] init];
    }
    
}
///connection delegate method start
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _showroomImageArray = [[NSMutableArray alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSString *responseString = [[NSString alloc] initWithData:_receivedData
                                                     encoding:NSUTF8StringEncoding];
    NSLog(@"Response : %@",responseString);
    NSDictionary *dict = [jsonParser objectWithString:[NSString stringWithFormat:@"%@",responseString]];
    
    NSDictionary *resp_body = [dict objectForKey:@"resp_body"];
    NSArray *showroomsArray = [resp_body objectForKey:@"showrooms"];
    _totalPageCount = [showroomsArray count];
    NSLog(@"TotalImageCOunt: %d",_totalPageCount);
    
    

    
    int index = 0;
    for(NSDictionary *showroomDicts in showroomsArray)
    {
        ShowroomModel *showroomModel = [ShowroomModel showroomModelFromDictionary:showroomDicts];
        NSLog(@"ShowroomName: %@",showroomModel.showroom_banner);
        [_showroomImageArray addObject:[NSString stringWithFormat:@"%@",showroomModel.showroom_banner]];
        
        if(index == 0)
        {
            [self configureViewWithShowroomImage:[NSString stringWithFormat:@"%@",showroomModel.showroom_banner]];
        }
        
        [self loadScrollViewWithPage:index
                         andImageURL:[NSString stringWithFormat:@"%@",showroomModel.showroom_banner]];
        index++;
    }
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

}


- (void)configureViewWithShowroomImage:(NSString *)showroomImageURL;
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"content_iPhone"
                                                    ofType:@"plist"];
    _contentList = [NSMutableArray arrayWithContentsOfFile:path];
    
    
    //----------//
    //NSUInteger numberOfPage = _contentList.count;
    
    _viewControllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < _totalPageCount; i++)
    {
        [_viewControllers addObject:[NSNull null]];
    }
    
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _totalPageCount, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    
    _pageControl.numberOfPages = _totalPageCount;
    _pageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0
                     andImageURL:[NSString stringWithFormat:@"%@",showroomImageURL]];
    
//    [self loadScrollViewWithPage:1
//                     andImageURL:[NSString stringWithFormat:@"%@",showroomImageURL]];

}


//connection delegate method end

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
    NSString *showroomImageURL = [NSString stringWithFormat:@"%@",[_showroomImageArray objectAtIndex:page]];
//    [self loadScrollViewWithPage:page - 1
//                     andImageURL:[NSString stringWithFormat:@"%@",showroomImageURL]];
    [self loadScrollViewWithPage:page
                     andImageURL:[NSString stringWithFormat:@"%@",showroomImageURL]];
//    [self loadScrollViewWithPage:page + 1
//                     andImageURL:[NSString stringWithFormat:@"%@",showroomImageURL]];
}


- (void)loadScrollViewWithPage:(NSUInteger)page
                   andImageURL:(NSString *)showroomImageURL
{
    if(page >= _showroomImageArray.count)
        return ;
    
    _myViewController = [_viewControllers objectAtIndex:page];
    if((NSNull *)_myViewController == [NSNull null])
    {
        _myViewController = [[MyViewController alloc] initWithPageNumber:page];
        [_viewControllers replaceObjectAtIndex:page withObject:_myViewController];
    }
    
    if(_myViewController.view.superview == nil)
    {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        _myViewController.view.frame = frame;
        
        [self addChildViewController:_myViewController];
        [_scrollView addSubview:_myViewController.view];
        [_myViewController didMoveToParentViewController:self];
        
        [_myViewController downloadImageWithURL:[NSString stringWithFormat:@"http://%@",showroomImageURL]];
         _myViewController.numberTitle.text = [NSString stringWithFormat:@"%d",page];
        
    }
    
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = _pageControl.currentPage;
    NSString *showroomImageURL = [NSString stringWithFormat:@"%@",[_showroomImageArray objectAtIndex:page]];

//    [self loadScrollViewWithPage:page - 1
//                     andImageURL:[NSString stringWithFormat:@"%@",showroomImageURL]];
    [self loadScrollViewWithPage:page
                     andImageURL:[NSString stringWithFormat:@"%@",showroomImageURL]];
//    [self loadScrollViewWithPage:page + 1
//                     andImageURL:[NSString stringWithFormat:@"%@",showroomImageURL]];

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
