//
//  UIResponder+Theme.h
//  CFAThemeExample
//
//  Created by Bradley Mueller on 8/11/17.
//  Copyright © 2017 Cellaflora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+CFA.h"
#import "CFAThemeManager.h"

@protocol UIResponderTheme <NSObject>

@optional
- (void)themeDidChange:(CFATheme)theme;

@end

@interface UIResponder (Theme)
<
UIResponderTheme
>

/**
 Register the receiver for callbacks on @p themeDidChange whenever the theme changes, and immediately call the callback upon registration for the current theme
 */
- (void)registerForThemeChanges;

@end
