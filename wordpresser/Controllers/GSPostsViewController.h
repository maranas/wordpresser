//
//  GSPostsViewController.h
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSPostViewerController;

@interface GSPostsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *postIDs; // ordered by download date
    NSMutableDictionary *postData; // id - data pairs
    NSInteger page;
    BOOL lastPage;
    BOOL reset;
    NSString* baseURI;
    BOOL loading;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) GSPostViewerController *postViewer;
@property (retain, nonatomic) NSString *currURI;
@property (retain, nonatomic) IBOutlet UIImageView *headerImage;
@property (retain, nonatomic) IBOutlet UIView *titleBackground;
@property (retain, nonatomic) IBOutlet UILabel *titleText;

- (IBAction)swipedRight:(id)sender;

- (void) showMenu;
- (void) hideMenu;
- (void) showViewer;
- (void) hideViewer;
- (void) refreshDataWithURI:(NSString*)uri reset:(BOOL)resetValue;
- (void) viewEntryForIndexPath:(NSIndexPath*)indexPath;
- (void) refreshCallback:(id)res;

+ (NSString*) extractImageURIFromPost:(id)post;

@end
