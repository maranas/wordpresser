//
//  GSPostsViewCell.m
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GSPostsViewCell.h"
#import "GSPostsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation GSPostsViewCell
@synthesize excerptText;
@synthesize titleText;
@synthesize imageView;
@synthesize loadingText;
@synthesize loadingIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [excerptText release];
    [titleText release];
    [imageView release];
    [loadingText release];
    [loadingIndicator release];
    [super dealloc];
}

- (void) updateContents
{
    [[self excerptText] setHidden:NO];
    [[self titleText] setHidden:NO];
    [[self imageView] setHidden:NO];
    CALayer * l = [[self imageView] layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5];
//    [l setBorderWidth:1.0];
//    [l setBorderColor:[[UIColor blackColor] CGColor]];
    [[self loadingText] setHidden:YES];
    [[self loadingIndicator] setHidden:YES];
    [[self loadingIndicator] stopAnimating];
}

- (IBAction)viewClick:(id)sender {
    NSIndexPath *indexPath = [(UITableView*)[self superview] indexPathForCell:self];
    [(GSPostsViewController*)[(UITableView*)[self superview] delegate] viewEntryForIndexPath:indexPath];
}
@end
