//
//  GSWordpressRequester.m
//  wordpresser
//
//  Created by Moises Anthony Aranas on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GSWordpressRequester.h"
#import "JSONKit.h"
#import <dispatch/dispatch.h> // we'll use Grand Central Dispatch to queue requests

#import "GSSettings.h"

#define CACHE_PATH @"images"

@implementation GSWordpressRequester
static GSWordpressRequester* _sharedRequester = nil;
static dispatch_queue_t queue;

+ (GSWordpressRequester*) sharedRequester
{
    @synchronized([GSWordpressRequester class])
    {
        if (!_sharedRequester)
        {
            _sharedRequester = [[self alloc] init];
        }
        return _sharedRequester;
    }
    return nil;
}

- (id) init {
    self = [super init];
    if (self != nil)
    {
        queue = dispatch_queue_create(DISPATCH_QUEUE_NAME,NULL);
        dispatch_retain(queue);
        [self clearImageCache];
    }
    return self;
}

- (void) downloadFeedForURIString:(NSString*)uri page:(NSInteger)page target:(id)target callback:(SEL)selector
{
    void (^block)(void) = ^{
        NSString *processedURI = [NSString stringWithString:uri];
        if ([uri rangeOfString:@"?"].location == NSNotFound) {
            processedURI = [[[processedURI stringByAppendingFormat:@"?json=1&page=%d", page] retain] autorelease];
        }
        else {
            processedURI = [[[processedURI stringByAppendingFormat:@"&json=1&page=%d", page] retain] autorelease];
        }
        NSLog(@"uri: %@", processedURI);
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:processedURI]];
        NSURLResponse *res = nil;
        NSError *err = nil;
        NSData *theData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        NSString *ret = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding]; 
        [target performSelectorOnMainThread:selector withObject:[ret objectFromJSONString] waitUntilDone:NO];
    };
    dispatch_async(queue, block);
}

- (void) downloadContentForURIString:(NSString*)uri target:(id)target callback:(SEL)selector
{
    void (^block)(void) = ^{
        NSLog(@"uri: %@", uri);
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:uri]];
        NSURLResponse *res = nil;
        NSError *err = nil;
        NSData *theData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        NSString *ret = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
        [target performSelectorOnMainThread:selector withObject:[ret objectFromJSONString] waitUntilDone:NO];
        NSLog(@"%@", ret);
    };
    dispatch_async(queue, block);
}

- (void) downloadImageFromURI:(NSString*)uri forView:(UIImageView*)view
{
    if (uri == nil)
    {
        [view setImage:[UIImage imageNamed:DEFAUT_POST_IMAGE]];
        [view setNeedsDisplay];
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageDir = [documentsDirectory stringByAppendingPathComponent:CACHE_PATH];
    NSString *imagename = [imageDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[NSURL URLWithString:uri] path]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagename])
    {
        [view setImage:[UIImage imageWithContentsOfFile:imagename]];
        [view setNeedsDisplay];
        return;
    }
    void (^block)(void) = ^{
        if (![[NSFileManager defaultManager] fileExistsAtPath:imageDir])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:imageDir withIntermediateDirectories:NO attributes:nil error:nil];
        }        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:uri]];
        NSURLResponse *res = nil;
        NSError *err = nil;
        NSData *theData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        [[NSFileManager defaultManager] createFileAtPath:imagename contents:theData attributes:nil];
        [view setImage:[UIImage imageWithContentsOfFile:imagename]];
        [view performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
    };
    dispatch_async(queue, block);
}

- (void) clearImageCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageDir = [documentsDirectory stringByAppendingPathComponent:CACHE_PATH];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageDir])
    {
        [[NSFileManager defaultManager] removeItemAtPath:imageDir error:nil];
        return;
    }
}

@end
