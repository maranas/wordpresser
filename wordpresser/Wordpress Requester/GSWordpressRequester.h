//
//  GSWordpressRequester.h
//  wordpresser
//
//  Defines communication interface with Wordpress.
//  Requires: JSONAPI plugin for the Wordpress site.
//
//  Created by Moises Anthony Aranas on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSWordpressRequester : NSObject
{

}
+ (GSWordpressRequester*) sharedRequester;

- (void) downloadFeedForURIString:(NSString*)uri page:(NSInteger)page target:(id)target callback:(SEL)selector;
- (void) downloadContentForURIString:(NSString*)uri target:(id)target callback:(SEL)selector;
- (void) downloadImageFromURI:(NSString*)uri forView:(UIImageView*)view;

@end
