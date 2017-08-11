//
//  CFAThemeManager.m
//  CFAThemeExample
//
//  Created by Bradley Mueller on 8/11/17.
//  Copyright © 2017 Cellaflora. All rights reserved.
//

#import "CFAThemeManager.h"
#import <UIKit/UIKit.h>

#define BRIGHTNESS_DARK_THRESHOLD 0.30
#define BRIGHTNESS_LIGHT_THRESHOLD 0.40

#define THEME_DEBUG_MODE 0

static NSString *const kForcedThemeDefaultsKey = @"kForcedThemeDefaultsKey";
NSString *const kThemeChangedKey = @"kThemeChangedKey";

@interface CFAThemeManager ()

@property (nonatomic, readwrite) CFATheme currentTheme;

@end

@implementation CFAThemeManager

+ (instancetype)sharedManager
{
    static CFAThemeManager *manager = nil;
    if (manager == nil)
    {
        manager = [[CFAThemeManager alloc] init];
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(brightnessDidChange:)
                                                     name:UIScreenBrightnessDidChangeNotification
                                                   object:nil];
        
        [self setCurrentTheme:[self calculateCurrentTheme] animated:NO];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setters/getters

- (void)setCurrentTheme:(CFATheme)currentTheme
{
    [self setCurrentTheme:currentTheme animated:YES];
}

- (void)setCurrentTheme:(CFATheme)currentTheme animated:(BOOL)animated
{
    if (_currentTheme != currentTheme)
    {
        _currentTheme = currentTheme;
        
        [UIView animateWithDuration:animated ? 0.5 : 0.0
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangedKey
                                                                                 object:@(currentTheme)];
                         }
                         completion:nil];
    }
}

- (void)setForcedTheme:(NSNumber *)forcedTheme
{
    [[NSUserDefaults standardUserDefaults] setObject:forcedTheme forKey:kForcedThemeDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.currentTheme = [self calculateCurrentTheme];
}

- (NSNumber *)forcedTheme
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kForcedThemeDefaultsKey];
}

#pragma mark - Calculations

- (CFATheme)calculateCurrentTheme
{
#if THEME_DEBUG_MODE == 1
    // Alternate themes periodically - useful for testing on Simulator
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(brightnessDidChange:) object:nil];
    [self performSelector:@selector(brightnessDidChange:) withObject:nil afterDelay:10];
    return (CFATheme)ABS(1 - self.currentTheme);
#endif
    
    if (self.forcedTheme != nil)
    {
        return [self.forcedTheme integerValue];
    }
    
    CGFloat brightness = [[UIScreen mainScreen] brightness];
    
    if (self.currentTheme == CFAThemeLight)
    {
        if (brightness <= BRIGHTNESS_DARK_THRESHOLD)
        {
            return CFAThemeDark;
        }
        return CFAThemeLight;
    }
    else
    {
        if (brightness >= BRIGHTNESS_LIGHT_THRESHOLD)
        {
            return CFAThemeLight;
        }
        return CFAThemeDark;
    }
}

- (void)brightnessDidChange:(NSNotification *)notification
{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state != UIApplicationStateActive && state != UIApplicationStateInactive)
    {
        return;
    }
    self.currentTheme = [self calculateCurrentTheme];
}

- (void)appDidBecomeActive
{
    self.currentTheme = [self calculateCurrentTheme];
}

@end
