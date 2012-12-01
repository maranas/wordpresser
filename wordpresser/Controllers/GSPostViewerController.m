//
//  GSPostViewerController.m
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GSPostViewerController.h"
#import "GSPostsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GSPostViewerController ()

@end

@implementation GSPostViewerController
@synthesize webView;
@synthesize progressIndicator;
@synthesize postsController;

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
	// Do any additional setup after loading the view.
    CALayer * l = [[self view] layer];
    [l setMasksToBounds:NO];
    //[l setCornerRadius:5.0];
    l.shadowColor = [[UIColor blackColor] CGColor];
    l.shadowOffset = CGSizeMake(0,2);
    l.shadowRadius = 2;
    l.shadowOpacity = 0.2;
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setPostsController:nil];
    [self setProgressIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)webViewDidStartLoad:(UIWebView *)webView {
    if (loading) return;
    loading = YES;
    [self.progressIndicator setHidden:NO];
    [self.progressIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!loading) return;
    
    loading = NO;
    [self.progressIndicator stopAnimating];
    [self.progressIndicator setHidden:YES];
}
-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{ 
    if (!loading) return;
    loading = NO;
    [self.progressIndicator stopAnimating];
    [self.progressIndicator setHidden:YES];
}

- (IBAction)backClicked:(id)sender
{
    [[self postsController] hideViewer];
}

- (IBAction)refreshClick:(id)sender {
    [[self webView] stopLoading];
    [[self webView] reload];
}

- (IBAction)backNavClick:(id)sender {
    [[self webView] goBack];
}

- (IBAction)forwardNavClick:(id)sender {
    [[self webView] goForward];
}

- (IBAction)openInSafari:(id)sender {
     [[UIApplication sharedApplication] openURL:[[[self webView] request] URL]];
}

- (void) loadContentsOfPageWithLink:(NSString*)link
{
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // replace with requester call!
    [[self webView] loadRequest:request];
}

- (void)dealloc {
    [progressIndicator release];
    [super dealloc];
}
@end
