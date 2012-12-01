//
//  GSPostViewerController.h
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSPostsViewController;

@interface GSPostViewerController : UIViewController <UIWebViewDelegate>
{
    BOOL loading;
}
- (IBAction)backClicked:(id)sender;

- (IBAction)refreshClick:(id)sender;
- (IBAction)backNavClick:(id)sender;
- (IBAction)forwardNavClick:(id)sender;
- (IBAction)openInSafari:(id)sender;

- (void) loadContentsOfPageWithLink:(NSString*)link;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (retain, nonatomic) GSPostsViewController *postsController;
@end
