//
//  WebView+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 11/25/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "WebView+AtoZ.h"

@implementation WebView (AtoZ)


- (void) makeMobile
{
	[self setCustomUserAgent:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B179 Safari/7534.48.3"];
}


- (NSImage *)snapshot
{
    WebFrame *frame = self.mainFrame;
    WebFrameView *view = frame.frameView;
    NSRect imageRect = view.documentView.frame;

    imageRect.origin.x = 0;
    imageRect.origin.y = 0;

    NSBitmapImageRep *imageRep = [view.documentView bitmapImageRepForCachingDisplayInRect:view.documentView.frame];
    [view.documentView cacheDisplayInRect:imageRect toBitmapImageRep:imageRep];
    NSImage *image = [[[NSImage alloc] initWithSize:imageRect.size] autorelease];
    [image addRepresentation:imageRep];
    return image;
}

@end
