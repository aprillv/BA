//
//  website.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-5.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "website.h"

@interface website ()<UITabBarDelegate>

@end

@implementation website
@synthesize webview1, ntabbar;

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
    
    [self.navigationItem setHidesBackButton:YES];
       [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    ntabbar.delegate = self;
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goProject:) ];
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO];
    
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO];
    
    [[ntabbar.items objectAtIndex:3]setImage:nil ];
    [[ntabbar.items objectAtIndex:3]setTitle:nil ];
    [[ntabbar.items objectAtIndex:3]setEnabled:NO];
    
    [self.webview1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.Url]]];
    
    webview1.delegate=self;
    
    [NSURLRequest requestWithURL:[NSURL URLWithString:self.Url]];
	// Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Project"]) {
        [self goProject:item];
    }
}

-(IBAction)goProject:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
							 error.localizedDescription];
	[self.webview1 loadHTMLString:errorString baseURL:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
