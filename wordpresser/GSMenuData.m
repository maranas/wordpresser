//
//  GSMenuData.m
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GSMenuData.h"
#import "GSSettings.h"

@implementation GSMenuData

+ (NSMutableDictionary*) getMenuData
{
// Customize the values here for each blog
    NSMutableDictionary* menuData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"http://localhost:8888/wordpress/?page_id=54", @"About",
                                     @"http://localhost:8888/wordpress/?page_id=24", @"Contact",
                                     @"http://localhost:8888/wordpress/?cat=6", @"Category",
                                     @"http://localhost:8888/wordpress/?tag=tag2", @"Tag",
                                     nil];
    return [[menuData retain] autorelease];
}

+ (UIImage*) getHeaderImage
{
    return [[[UIImage imageNamed:@"header.jpg"] retain] autorelease];
}

+ (NSString*) getBlogTitle
{
    return [[[NSString stringWithString:BLOG_TITLE] retain] autorelease];
}

@end
