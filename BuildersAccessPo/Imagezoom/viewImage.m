//
//  viewImage.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-10.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "viewImage.h"

#import "Mysql.h"

#define NAVBAR_HEIGHT   44
@interface viewImage ()

@end

@implementation viewImage
@synthesize  img;

-(IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"View Picture";
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self //Add yourself as an observer
           selector:@selector(orientationChanged)
               name:UIDeviceOrientationDidChangeNotification
             object:nil];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, NAVBAR_HEIGHT)];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBar.items = @[self.navigationItem];
    
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    [self.view addSubview:navigationBar];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, self.view.bounds.size.height-NAVBAR_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView setBackgroundColor:[Mysql groupTableViewBackgroundColor]];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    
    
    
    _zoomScrollView = [[MRZoomScrollView alloc]init];
    int xs =img.size.width;
    
    float xt = _scrollView.frame.size.width/xs;
    int xh = img.size.height*xt;
    
    [_zoomScrollView initImageView:(xs/_scrollView.frame.size.width) andHeight:xh];
    //            NSLog(@"%f %f %d", img.size.width, img.size.height, xh);
    
    _zoomScrollView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    CGRect frame = _scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _zoomScrollView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _zoomScrollView.frame = frame;
    _zoomScrollView.imageView.image =img;
    [_scrollView addSubview:_zoomScrollView];
    
    
//    _data =[[NSMutableData alloc]init];
//    NSURLRequest* updateRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:xurl]];
//    
//    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:updateRequest  delegate:self];
//    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    _spinner.hidesWhenStopped = YES;
//    _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
//    [_scrollView addSubview:_spinner];
//    _spinner.center = CGPointMake(floorf(_scrollView.frame.size.width/2.0),
//                                  floorf(_scrollView.frame.size.height/2.0));
//    [_spinner startAnimating];
//    [connection start];
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
