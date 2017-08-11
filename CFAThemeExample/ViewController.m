//
//  ViewController.m
//  CFAThemeExample
//
//  Created by Bradley Mueller on 8/11/17.
//  Copyright © 2017 Cellaflora. All rights reserved.
//

#import "ViewController.h"
#import "UIResponder+Theme.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return (CFACurrentTheme == CFAThemeDark) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:UIScreenBrightnessDidChangeNotification object:nil];
    [self updateLabel];
    
    NSNumber *forcedTheme = [[CFAThemeManager sharedManager] forcedTheme];
    if (forcedTheme == nil) {
        [self.segmentedControl setSelectedSegmentIndex:0];
    }
    else if ([forcedTheme integerValue] == 0) {
        [self.segmentedControl setSelectedSegmentIndex:1];
    }
    else {
        [self.segmentedControl setSelectedSegmentIndex:2];
    }
    
    [self registerForThemeChanges];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Theme changes

// This is called immediately upon registration & whenever the theme changes

- (void)themeDidChange:(CFATheme)theme
{
    self.view.backgroundColor = [UIColor cfa_day:CFAColorLightGray night:CFAColorDarkGray];
    
    self.segmentedControl.tintColor = [UIColor cfa_day:CFAColorDarkGray night:CFAColorLightGray];
    self.label.textColor = [UIColor cfa_day:CFAColorDarkGray night:CFAColorLightGray];
    self.noteLabel.textColor = [UIColor cfa_day:CFAColorDarkGray night:CFAColorLightGray];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark -

- (void)updateLabel
{
    self.label.text = [NSString stringWithFormat:@"Brightness: %0.0f%%", [[UIScreen mainScreen] brightness] * 100.0];
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [[CFAThemeManager sharedManager] setForcedTheme:nil];
            break;
        case 1:
            [[CFAThemeManager sharedManager] setForcedTheme:@(CFAThemeLight)];
            break;
        case 2:
            [[CFAThemeManager sharedManager] setForcedTheme:@(CFAThemeDark)];
            break;
    }
}

@end
