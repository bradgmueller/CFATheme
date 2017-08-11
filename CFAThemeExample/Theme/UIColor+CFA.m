//
//  UIColor+CFA.m
//  CFAThemeExample
//
//  Created by Bradley Mueller on 8/11/17.
//  Copyright © 2017 Cellaflora. All rights reserved.
//

#import "UIColor+CFA.h"
#import "CFAThemeManager.h"

@implementation UIColor (CFA)

+ (UIColor *)cfa_day:(CFAColor)dayType night:(CFAColor)nightType
{
    if (CFACurrentTheme == CFAThemeDark)
    {
        return [self cfa_colorForType:nightType];
    }
    return [self cfa_colorForType:dayType];
}

+ (UIColor *)cfa_colorForType:(CFAColor)type
{
    switch (type) {
        case CFAColorDarkGray:
            return [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:255.0/255.0];
        case CFAColorLightGray:
            return [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:255.0/255.0];
    }
}

@end
