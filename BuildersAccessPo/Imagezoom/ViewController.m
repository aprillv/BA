//
//  ViewController.m
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import "ViewController.h"
#import "Mysql.h"

#define NAVBAR_HEIGHT   44
@interface ViewController (){
    int i;
}

@end

@implementation ViewController
@synthesize xurl;

-(IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Site Map";
    
    int dwith =self.view.bounds.size.width;
    int dheight =self.view.bounds.size.height;
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
//    [nc addObserver:self //Add yourself as an observer
//           selector:@selector(orientationChanged)
//               name:UIDeviceOrientationDidChangeNotification
//             object:nil];

    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, dwith, NAVBAR_HEIGHT)];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBar.items = @[self.navigationItem];
    
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    [self.view addSubview:navigationBar];
//    [navigationBar release];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, 320, dheight-NAVBAR_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
//    [_scrollView release];
    [_scrollView setBackgroundColor:[UIColor blackColor]];
    
    _data =[[NSMutableData alloc]init];
    NSURLRequest* updateRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:xurl]];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:updateRequest  delegate:self];
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.hidesWhenStopped = YES;
    _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [_scrollView addSubview:_spinner];
    _spinner.center = CGPointMake(floorf(_scrollView.frame.size.width/2.0),
                                  floorf(_scrollView.frame.size.height/2.0));
    [_spinner startAnimating];
    [connection start];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"%d", i++);
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    _scrollView.backgroundColor=[UIColor whiteColor];
    [_spinner stopAnimating];
    [_spinner removeFromSuperview];
    UIImage *img=[UIImage imageWithData:_data];
    
    _zoomScrollView = [[MRZoomScrollView alloc]init];
    int xs =img.size.width;
    
    float xt = _scrollView.frame.size.width/xs;
    int xh = img.size.height*xt;
    
    [_zoomScrollView initImageView:(xs/_scrollView.frame.size.width) andHeight:xh];
//     [_zoomScrollView initImageView:img.size.width andHeight:img.size.height];
    //            NSLog(@"%f %f %d", img.size.width, img.size.height, xh);
    
    _zoomScrollView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    CGRect frame = _scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _zoomScrollView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _zoomScrollView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    _zoomScrollView.imageView.image =img;
    [_scrollView addSubview:_zoomScrollView];
    
    _scrollView.contentSize=CGSizeMake(img.size.width, img.size.height);
    _scrollView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    [_zoomScrollView release];
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
