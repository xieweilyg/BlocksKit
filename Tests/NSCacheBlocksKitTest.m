//
//  NSCacheBlocksKitTest.m
//  BlocksKit
//
//  Created by Zachary Waldowski on 10/5/11.
//  Copyright (c) 2011 Dizzy Technology. All rights reserved.
//

#import "NSCacheBlocksKitTest.h"
#import "NSTimer+BlocksKit.h"

@interface NSCacheBlocksKitTest () <NSCacheDelegate>
@property (nonatomic) NSInteger total;
@end

@implementation NSCacheBlocksKitTest

@synthesize subject, total;

- (void)setUpClass {
    // Run at start of all tests in the class
    self.subject = [[[NSCache alloc] init] autorelease];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
    self.subject = nil;
}

- (void)setUp {
    self.total = 0;
	self.subject.delegate = nil;
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
	self.total--;
}

- (void)testDelegate {
	self.subject.delegate = self;
	self.total = 2;
	self.subject.willEvictBlock = ^(NSCache *cache, id obj){
        self.total--;
    };
	[self.subject.delegate cache:self.subject willEvictObject:nil];
	GHAssertEquals(self.total, 0, @"The delegates should have been called!");
}

#if 0
- (void)testEvictionDelegate {
    self.subject.willEvictBlock = ^(NSCache *cache, id obj){
        self.total--;
    };
	
	self.total = 300;
	
	@autoreleasepool {
		for (NSUInteger i = 0; i < total; i++) {
			NSString *string = [NSString stringWithFormat:@"%i", i];
			NSPurgeableData *obj = [NSPurgeableData dataWithBytes:string.UTF8String length:string.length];
			NSIndexPath *key = [NSIndexPath indexPathWithIndex:i];
			[self.subject setObject:obj forKey:key];
		}
	}
	
    
    // force an eviction
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"UISimulatedMemoryWarningNotification", NULL, NULL, true);
    
    [self prepare];
    
    [self performSelector:@selector(_succeed) withObject:nil afterDelay:4];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)_succeed {
    GHAssertEquals(self.total, 2, @"The cache should have been emptied!");
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testEvictionDelegate)];
    self.subject.willEvictBlock = nil;
}
#endif

@end