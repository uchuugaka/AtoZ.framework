//
//  AZWindowExtend.h
//  AtoZ
//
//  Created by Alex Gray on 8/6/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@class AZWindowExtend;
@interface AZWindowExtendController : NSObject
@property (weak) AZWindowExtend *window;
@end

@interface AZWindowExtend : NSWindow

- (void)setAcceptsMouseMovedEvents:(BOOL)acceptMouseMovedEvents screen:(BOOL)anyWhere;

//@property (nonatomic, retain) IBOutlet NSTextField *coordinates;
@property (weak) IBOutlet NSTextField *coordinates;
@property (assign, nonatomic) CGPoint point;
@end