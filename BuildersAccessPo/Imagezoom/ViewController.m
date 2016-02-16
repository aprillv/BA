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
@property (strong, nonatomic) IBOutlet UINavigationItem *naitem;

@end

@implementation ViewController
@synthesize xurl, scrollView, spinner, imageView;

-(IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self.naitem setLeftBarButtonItem:[self getbackButton]];
//    self.title=@"Site Map";
//    
//    int dwith =self.view.bounds.size.width;
//    int dheight =self.view.bounds.size.height;
////    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
////    [nc addObserver:self //Add yourself as an observer
////           selector:@selector(orientationChanged)
////               name:UIDeviceOrientationDidChangeNotification
////             object:nil];
//
//    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, dwith, NAVBAR_HEIGHT)];
//    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    navigationBar.items = @[self.navigationItem];
    
    [self.naitem setLeftBarButtonItem:[self getbackButton]];
//    [self.view addSubview:navigationBar];
////    [navigationBar release];
//    
//    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, dheight-NAVBAR_HEIGHT)];
//    _scrollView.delegate = self;
//    _scrollView.pagingEnabled = YES;
//    _scrollView.userInteractionEnabled = YES;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    [self.view addSubview:_scrollView];
////    [_scrollView release];
//    [_scrollView setBackgroundColor:[UIColor blackColor]];
//    
    _data =[[NSMutableData alloc]init];
    NSURLRequest* updateRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:xurl]];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:updateRequest  delegate:self];
    [spinner startAnimating];
    [connection start];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"%d", i++);
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [spinner stopAnimating];
//    UIImage *img=[UIImage imageWithData:_data];
    imageView.image = [UIImage imageWithData:_data];
//    scrollView.minimumZoomScale = self.view.frame.size.width*0.8/imageView.image.size.height;
//    scrollView.contentSize = CGSizeMake(imageView.image.size.width, imageView.image.size.height);
    
}



-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
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
