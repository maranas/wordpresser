//
//  GSMenuViewController.m
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GSMenuViewController.h"
#import "GSPostsViewController.h"
#import "GSMenuCell.h"
#import "GSSettings.h"
#import "GSMenuData.h"

@interface GSMenuViewController ()

@end

@implementation GSMenuViewController
@synthesize tableView;
@synthesize menuTitle;
@synthesize postsController = _postsController;

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
    menuData = [[GSMenuData getMenuData] retain];
    menuTexts = [[menuData allKeys] retain];
    [menuTitle setText:[GSMenuData getBlogTitle]];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setMenuTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [menuData release];
    [menuTexts release];
    [tableView release];
    [_postsController release];
    [menuTitle release];
    [super dealloc];
}

// table view delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* labelText = [menuTexts objectAtIndex:indexPath.row];
    NSString* uri = [menuData objectForKey:labelText];
    NSLog(@"loading %@", uri);
    [[self postsController] refreshDataWithURI:uri reset:YES]; //reset when changing pages
    [[self postsController] hideMenu];
}


// data source delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuTexts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if (cell == nil)
    {
        NSArray *xibContents = [[NSBundle mainBundle] loadNibNamed:@"GSMenuCell" owner:self options:nil];
        for (id view in xibContents)
        {
            if ([view isKindOfClass:[GSMenuCell class]])
            {
                cell = (GSMenuCell *)view;
                break;
            }
        }
    }
    NSString* labelText = [menuTexts objectAtIndex:indexPath.row];
    [[cell mainText] setText:labelText];
    return cell;
}

- (IBAction)homeClick:(id)sender {
    [[self postsController] refreshDataWithURI:WORDPRESS_BASE_URL reset:YES];
    [[self postsController] hideMenu]; 
}

- (IBAction)aboutClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ganglionsoftware.com"]];
}
@end
