//
//  UIColor+CFA.h
//  CFAThemeExample
//
//  Created by Bradley Mueller on 8/11/17.
//  Copyright © 2017 Cellaflora. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, CFAColor) {
    CFAColorDarkGray,
    CFAColorLightGray
};

@interface UIColor (CFA)

+ (UIColor *)cfa_day:(CFAColor)dayType night:(CFAColor)nightType;
+ (UIColor *)cfa_colorForType:(CFAColor)type;

@end
