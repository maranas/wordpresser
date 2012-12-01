//
//  GSPostsViewCell.h
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPostsViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *excerptText;
@property (retain, nonatomic) IBOutlet UILabel *titleText;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *loadingText;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)viewClick:(id)sender;

- (void) updateContents;
@end
