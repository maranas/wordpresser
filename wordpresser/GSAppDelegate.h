//
//  GSAppDelegate.h
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSViewController, GSPostsViewController, GSMenuViewController;

@interface GSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GSViewController *viewController;

@property (strong, nonatomic) GSPostsViewController *postsViewController;

@property (strong, nonatomic) GSMenuViewController *menuViewController;

@end
