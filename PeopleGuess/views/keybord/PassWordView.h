//
//  PassWordView.h
//  PeopleGuess
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRBPayPsdInputView.h"

@protocol selfSetDelegate <NSObject>

-(void)closePasswordView;
-(void)enterSetPassword;

@end

@interface PassWordView : UIView<UITextFieldDelegate>

// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
// 完成按钮
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleLabelAgain;
@property (nonatomic, strong) UIView *hengLine;

@property (nonatomic, strong) UITextField *textfiled1;
@property (nonatomic, strong) UITextField *textfiled2;

@property (nonatomic, strong) GRBPayPsdInputView *inputView;//输入密码

@property (nonatomic, strong) GRBPayPsdInputView *inputViewAgain;//再次确认

@property(nonatomic,strong)id<selfSetDelegate>delegate;
@end
