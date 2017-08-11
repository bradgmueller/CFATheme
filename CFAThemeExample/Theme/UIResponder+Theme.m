//
//  UIResponder+Theme.m
//  CFAThemeExample
//
//  Created by Bradley Mueller on 8/11/17.
//  Copyright © 2017 Cellaflora. All rights reserved.
//

#import "UIResponder+Theme.h"

@import ObjectiveC;

@interface CFANotifier : NSObject
@property (nonatomic, copy) void (^block)(NSNotification *notification);
@end

@implementation CFANotifier

- (instancetype)initWithName:(NSString *)name object:(id)object block:(void(^)(NSNotification *notification))block
{
    NSParameterAssert(name);
    NSParameterAssert(block);
    
    self = [super init];
    if (self)
    {
        self.block = block;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationReceived:)
                                                     name:name
                                                   object:object];
    }
    return self;
}

- (void)notificationReceived:(NSNotification *)notification
{
    self.block(notification);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark - Category

@interface UIResponder (Theme_Private)

@property (nonatomic, strong) CFANotifier *themeChangedNotifier;

@end

@implementation UIResponder (Theme)

- (void)registerForThemeChanges
{
    NSAssert([self respondsToSelector:@selector(themeDidChange:)], @"%@ must implement %@", NSStringFromClass(self.class), NSStringFromSelector(@selector(themeDidChange:)));
    
    __weak typeof(self) weakSelf = self;
    self.themeChangedNotifier = [[CFANotifier alloc] initWithName:kThemeChangedKey object:nil block:^(NSNotification *notification) {
        
        [weakSelf themeDidChange:CFACurrentTheme];
    }];
    
    [self themeDidChange:CFACurrentTheme];
}

- (CFANotifier *)themeChangedNotifier
{
    return objc_getAssociatedObject(self, @selector(themeChangedNotifier));
}

- (void)setThemeChangedNotifier:(CFANotifier *)themeChangedNotifier
{
    objc_setAssociatedObject(self, @selector(themeChangedNotifier), themeChangedNotifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
