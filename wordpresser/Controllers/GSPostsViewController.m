//
//  GSPostsViewController.m
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GSPostsViewController.h"
#import "GSPostsViewCell.h"
#import "GSWordpressRequester.h"
#import "GSPostViewerController.h"
#import "GSSettings.h"
#import "GSMenuData.h"

#import <QuartzCore/QuartzCore.h>

#import "JSONKit.h"

#define VIEW_OFFSET 280.0

@interface GSPostsViewController ()

@end

@implementation GSPostsViewController
@synthesize tableView;
@synthesize postViewer;
@synthesize currURI = _currURI;
@synthesize headerImage;
@synthesize titleBackground;
@synthesize titleText;

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
    postIDs = [[NSMutableArray array] retain];
    postData = [[NSMutableDictionary dictionary] retain];
    page = 1;
    
	// Do any additional setup after loading the view.
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self tableView] addGestureRecognizer:recognizer];
    
    [[self headerImage] setImage:[GSMenuData getHeaderImage]];
    [[self titleText] setText:[GSMenuData getBlogTitle]];
    [[self titleBackground] setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    
    
    // add post viewer
    [self setPostViewer:[[GSPostViewerController alloc] initWithNibName:@"GSPostViewer" bundle:nil]];
    [[self postViewer] setPostsController:self];
    [[self view] addSubview:[[self postViewer] view]];
    [self setCurrURI:WORDPRESS_BASE_URL];
    [self refreshDataWithURI:[self currURI] reset:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideViewer];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setPostViewer:nil];
    [self setHeaderImage:nil];
    [self setTitleBackground:nil];
    [self setTitleText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)swipedRight:(id)sender
{
    [self showMenu];
}

- (void) showMenu
{
    [UIView beginAnimations:nil context:nil];
    CGRect f = self.view.frame;
    f.origin.x = VIEW_OFFSET;
    self.view.frame = f;
    [UIView commitAnimations]; 
}

- (void) hideMenu
{
    [UIView beginAnimations:nil context:nil];
    CGRect f = self.view.frame;
    f.origin.x = 0;
    self.view.frame = f;
    [UIView commitAnimations];
}

- (void) showViewer
{
    [UIView beginAnimations:nil context:nil];
    CGRect f = [[[self postViewer] view] frame];
    f.origin.x = 0;
    [[[self postViewer] view] setFrame:f];
    [UIView commitAnimations];
}

- (void) hideViewer
{
    [UIView beginAnimations:nil context:nil];
    CGRect f = [[[self postViewer] view] frame];
    f.origin.x += f.size.width;
    [[[self postViewer] view] setFrame:f];
    [UIView commitAnimations];
}

- (void)dealloc {
    [postIDs release];
    [postData release];
    [postViewer release];
    [tableView release];
    [_currURI release];
    [headerImage release];
    [titleBackground release];
    [titleText release];
    [super dealloc];
}

- (void) refreshDataWithURI:(NSString*)uri reset:(BOOL)resetValue;
{
    @synchronized(self)
    {
        loading = YES;
        reset = resetValue;
        if (baseURI != nil) {
            [baseURI release];
        }
        if (reset) {
            page = 1;
            lastPage = NO;
        }
        baseURI = [[NSString stringWithString:uri] retain];
        [[GSWordpressRequester sharedRequester] downloadFeedForURIString:uri page:page target:self callback:@selector(refreshCallback:)];
    }
}

- (void) refreshCallback:(id)res
{
    @synchronized(self)
    {
        if (reset) {
            page = 1;
            lastPage = NO;
        }
        if ([[res objectForKey:@"pages"] integerValue] <= page)
        {
            if ([[res objectForKey:@"status"] isEqualToString:@"ok"])
            {
                NSLog(@"last page reached!");
                page = [[res objectForKey:@"pages"] integerValue];
                lastPage = YES;
            }
            else {
                NSLog(@"no data");
                [self.tableView reloadData];
                [self.tableView setNeedsDisplay];
                [self.tableView setNeedsLayout];
                loading = NO;
                NSString* messageString = @"Couldn't retrieve data; check your data connection's availability.";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data available!"
                                                                message: messageString
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
                return;
            }
        }
        NSArray *posts;
        if (![[res allKeys] containsObject:@"posts"]) {
            NSString *uri = [[[res objectForKey:@"page"] objectForKey:@"url"] stringByAppendingString:@"?json=1"];
            [[self postViewer] loadContentsOfPageWithLink:uri];
            [self showViewer];
        }
        else {
            if (reset) // if reset is true, clear table. if not, just add
            {
                [self setCurrURI:baseURI];
                [postIDs removeAllObjects];
                [postData removeAllObjects];
            }
            posts = [[[res objectForKey:@"posts"] retain] autorelease];
            for (id post in posts) {
                NSString* postID = [NSString stringWithFormat:@"%@", [post objectForKey:@"id"]];
                if (![postIDs containsObject:postID])
                {
                    [postIDs addObject:postID];
                    [postData setObject:post forKey:postID];
                }
            }
            [self.tableView reloadData];
            [self.tableView setNeedsDisplay];
            [self.tableView setNeedsLayout];
        }
    }
    loading = NO;
}

- (void)viewEntryForIndexPath:(NSIndexPath*)indexPath {
    NSDictionary *post = [postData objectForKey:[postIDs objectAtIndex:indexPath.row]];
    NSString *uri = [[post objectForKey:@"url"] stringByAppendingString:@"?json=1"];
    [[self postViewer] loadContentsOfPageWithLink:uri];
    [self showViewer];
}

// table view delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [postIDs count])
        [self viewEntryForIndexPath:indexPath];
    else {
        //load more
        loading = YES;
        [self.tableView reloadData];
        page += 1;
        [self refreshDataWithURI:[self currURI] reset:NO];
    }
}


// data source delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (lastPage)
        return [postIDs count];
    return [postIDs count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSPostsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        NSArray *xibContents = [[NSBundle mainBundle] loadNibNamed:@"GSPostsViewCell" owner:self options:nil];
        for (id view in xibContents)
        {
            if ([view isKindOfClass:[GSPostsViewCell class]])
            {
                cell = (GSPostsViewCell *)view;
                break;
            }
        }
    }
    [cell updateContents];
    if (indexPath.row < [postIDs count])
    {
        NSDictionary *post = [postData objectForKey:[postIDs objectAtIndex:indexPath.row]];
        [[cell titleText] setText:[post objectForKey:@"title"]];
        [[cell excerptText] setText:[post objectForKey:@"excerpt"]];
        [[GSWordpressRequester sharedRequester] downloadImageFromURI:[self extractImageURIFromPost:post] forView:[cell imageView]];
    }
    else {
        [[cell titleText] setHidden:YES];
        [[cell excerptText] setHidden:YES];
        [[cell imageView] setHidden:YES];
        [[cell loadingIndicator] setHidden:NO];
        [[cell loadingText] setHidden:NO];
        if (loading)
        {
            [[cell loadingText] setText:@"Loading..."];
            [[cell loadingIndicator] startAnimating];
        }
        else {
            [[cell loadingText] setText:@"Load more items..."];
            [[cell loadingIndicator] stopAnimating];
        }
    }
    [cell setNeedsDisplay];
    [cell setNeedsLayout];
    return cell;
}


// utility methods
- (NSString*) extractImageURIFromPost:(id)post
{
    NSArray* attachments = [post objectForKey:@"attachments"];
    if ([attachments count] > 0) {
        for (id attachmentDic in attachments)
        {
            if ([[attachmentDic objectForKey:@"mime_type"] hasPrefix:@"image"])
            {
                return [[[attachmentDic objectForKey:@"url"] retain] autorelease];
            }
        }
    }
    NSString* content = [post objectForKey:@"content"];
    NSArray *contentArray = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<> \""]];
    for (NSString* uri in contentArray)
    {
        if ([uri hasPrefix:@"http"])
        {
            if ([uri hasSuffix:@".gif"] ||
                [uri hasSuffix:@".png"] ||
                [uri hasSuffix:@".jpg"] ||
                [uri hasSuffix:@".jpeg"])
            {
                return [[uri retain] autorelease];
            }
        }
    }
    return nil;
}

@end
