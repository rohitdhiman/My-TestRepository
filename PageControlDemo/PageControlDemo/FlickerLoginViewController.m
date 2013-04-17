//
//  FlickerLoginViewController.m
//  PageControlDemo
//
//  Created by Rohit Dhiman on 17/4/13.
//  Copyright (c) 2013 anchanto. All rights reserved.
//

#import "FlickerLoginViewController.h"
#import "SBJson.h"

@interface FlickerLoginViewController ()

@property (nonatomic, strong) NSMutableData *receivedData;

@end

@implementation FlickerLoginViewController
@synthesize receivedData = _receivedData;

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
    
    //flicker
    NSString *flickerAPIKey = @"9f711d1dc9919881ec73d6840befb064";
    //NSString *secretKey = @"a6e505afe8ef2b21";
    NSString *text = @"tower";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=15&format=json&nojsoncallback=1",flickerAPIKey,text]]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                delegate:self];
    if(connection)
    {
        _receivedData = [[NSMutableData alloc] init];
    }
    
    
}

//NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //_showroomImageArray = [[NSMutableArray alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
    //SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSString *responseString = [[NSString alloc] initWithData:_receivedData
                                                     encoding:NSUTF8StringEncoding];
    NSLog(@"Response : %@",responseString);

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
