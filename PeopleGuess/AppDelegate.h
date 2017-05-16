//
//  AppDelegate.h
//  PeopleGuess
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MMDrawerController *drawerController;
+ (NSString *)networkStatus;
- (void)getValueForKeyInUserInfo;
- (void)clearUserInfo;
- (void)initDrawer;
@end

