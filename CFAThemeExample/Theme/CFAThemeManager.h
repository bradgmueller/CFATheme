//
//  CFAThemeManager.h
//  CFAThemeExample
//
//  Created by Bradley Mueller on 8/11/17.
//  Copyright © 2017 Cellaflora. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kThemeChangedKey;

typedef NS_ENUM (NSInteger, CFATheme) {
    CFAThemeLight,
    CFAThemeDark
};

#define CFACurrentTheme [[CFAThemeManager sharedManager] currentTheme]

@interface CFAThemeManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSNumber *forcedTheme;

@property (nonatomic, readonly) CFATheme currentTheme;

@end
