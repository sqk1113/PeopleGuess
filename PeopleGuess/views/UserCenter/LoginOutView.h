//
//  popView.h
//  popView
//
//  Created by mac on 16/12/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ChooseAction)(UIButton *btn);
@interface LoginOutView : UIView

+(void)showPopView:(ChooseAction)block;

@end

@interface UIButton (block)

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ChooseAction)action;

@end
