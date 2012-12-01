//
//  GSMenuViewController.h
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSPostsViewController;

@interface GSMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *menuData;
    NSArray *menuTexts;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *menuTitle;
- (IBAction)homeClick:(id)sender;
- (IBAction)aboutClick:(id)sender;

@property (retain, nonatomic) GSPostsViewController* postsController;

@end
