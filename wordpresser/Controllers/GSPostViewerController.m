//
//  GSPostViewerController.m
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GSPostViewerController.h"
#import "GSPostsViewController.h"
#import "GSWordpressRequester.h"
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
    for(UIView *subview in [[[self.webView subviews] objectAtIndex:0] subviews]) {
        if([subview isKindOfClass:[UIImageView class]]) {
            [subview setHidden:YES];
        }
    }
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
    if ([[[[[self webView] request] URL] absoluteString] isEqualToString:@"about:blank"]) {
        NSLog(@"Won't refresh post");
    } else {
        [[self webView] reload];
    }
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
    // replace with requester call!
    // [[self webView] loadRequest:request];
    [[GSWordpressRequester sharedRequester] downloadContentForURIString:link target:self callback:@selector(contentLoadCallback:)];
}

- (void) contentLoadCallback:(id)res {
    NSDictionary* page = [res objectForKey:@"post"];
    if (page == nil) {
        page = [res objectForKey:@"page"];
        if (page == nil) {
            NSLog(@"Empty/invalid JSON response");
            return;
        }
    }
    NSString* htmlStyle = @"<style type=\"text/css\">div.body {margin-top:20px; margin-bottom:20px; margin-right:20px; margin-left:20px; font-family: Georgia, serif} div.title {font-family: Helvetica, Verdana, serif; color:black; font-size: 20px; font-weight: bold;} div.author {color: gray; font-size: 12px; font-weight: italic} div.content {color: black} img {margin-top:10px; margin-bottom:10px; margin-right:10px; margin-left:10px;} </style>";
    
    NSString *imageHeader = @"";
    /* TODO: images? i don't think we need it
    NSString* urlForImage = [GSPostsViewController extractImageURIFromPost:page];
    if (urlForImage != nil) {
        imageHeader = [NSString stringWithFormat:@"<img src=\"%@\"></img>", urlForImage];
    }
    */
    NSString* htmlString = [NSString stringWithFormat:@"<html><head>%@</head><body>%@<div class=\"body\"><div class=\"title\">%@</div><div class=\"author\"> by %@ </div><div class=\"content\">%@</div></div></body></html>",
                            htmlStyle,
                            imageHeader,
                            [page objectForKey:@"title"],
                            [[page objectForKey:@"author"] objectForKey:@"nickname"],
                            [page objectForKey:@"content"]];
    [[self webView] loadHTMLString:htmlString baseURL:nil];
}

- (void)dealloc {
    [progressIndicator release];
    [super dealloc];
}
@end
