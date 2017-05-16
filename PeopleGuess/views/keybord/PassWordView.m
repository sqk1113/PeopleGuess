//
//  PassWordView.m
//  PeopleGuess
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PassWordView.h"

@implementation PassWordView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self ==[super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self creatUI];
    }
    return self;
}
- (void)creatUI
{
    // 关闭按钮
    self.closeBtn = [[UIButton alloc] init];
    [self.closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"请输入支付密码";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.titleLabel];
    
    // 关闭按钮
    self.enterBtn = [[UIButton alloc] init];
    [self.enterBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.enterBtn setTitleColor:NAVBARMAINCOLOR forState:UIControlStateNormal];
    self.enterBtn.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:15];
    [self.enterBtn addTarget:self action:@selector(enterSet) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.enterBtn];
    
    // 横线
    self.hengLine = [[UIView alloc] init];
    self.hengLine.backgroundColor = UIColorFromRGB(0xcccccc);
    [self addSubview:self.hengLine];
    
    // 密码输入框
    self.inputView = [[GRBPayPsdInputView alloc] init];
    self.inputView.layer.borderWidth = 0.5;
    self.inputView.layer.borderColor =[UIColorFromRGB(0xbababa) CGColor];
    [self addSubview:self.inputView];
    self.inputView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputView1BecomeFirst)];
//    tap.numberOfTapsRequired=1;
//    tap.numberOfTouchesRequired = 1;
//    [self.inputView addGestureRecognizer:tap];
    
    
    self.titleLabelAgain = [[UILabel alloc] init];
    self.titleLabelAgain.text = @"再次确认支付密码";
    self.titleLabelAgain.textColor = UIColorFromRGB(0x999999);
    self.titleLabelAgain.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabelAgain];
    
    // 再次密码输入框
    self.inputViewAgain = [[GRBPayPsdInputView alloc] init];
    self.inputViewAgain.layer.borderWidth = 0.5;
    self.inputViewAgain.layer.borderColor =[UIColorFromRGB(0xbababa) CGColor];
    [self addSubview:self.inputViewAgain];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputView2BecomeFirst)];
//    tap.numberOfTapsRequired=1;
//    tap.numberOfTouchesRequired = 1;
//    [self.inputViewAgain addGestureRecognizer:tap1];
    
    
    self.textfiled1 = [[UITextField alloc]initWithFrame:CGRectMake(0, -30, 30, 30)];
    [self addSubview:self.textfiled1];
    self.textfiled1.borderStyle = UITextBorderStyleNone;
    self.textfiled1.keyboardType = UIKeyboardTypeNumberPad;
    self.textfiled1.delegate = self;
    self.textfiled1.hidden = YES;
    [self.textfiled1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.textfiled2 = [[UITextField alloc]initWithFrame:CGRectMake(0, -30, 30, 30)];
    [self addSubview:self.textfiled2];
    self.textfiled2.borderStyle = UITextBorderStyleNone;
    self.textfiled2.keyboardType = UIKeyboardTypeNumberPad;
    self.textfiled2.delegate = self;
    self.textfiled2.hidden= YES;
    [self.textfiled2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)closeView
{
    [_delegate closePasswordView];
}
-(void)enterSet
{
    [_delegate enterSetPassword];
}
//
-(void)inputView1BecomeFirst
{
    [self.textfiled1 becomeFirstResponder];
}
-(void)inputView2BecomeFirst
{
    [self.textfiled2 becomeFirstResponder];
}
-(void)textFieldDidChange :(UITextField *)theTextField
{
    if (theTextField==self.textfiled1) {
        if (self.textfiled1.text.length<=6) {
            [self.inputView setBlackRoundCount:self.textfiled1.text.length];
            if (self.textfiled1.text.length==6) {
                [self inputView2BecomeFirst];
            }
        }
        return;
    }
    if (theTextField==self.textfiled2) {
        if (self.textfiled2.text.length<=6) {
            [self.inputViewAgain setBlackRoundCount:self.textfiled2.text.length];
            if (self.textfiled2.text.length==0) {
                [self inputView1BecomeFirst];
 
            }
            
            return;
        }
        else
        {
            self.textfiled2.text =[self.textfiled2.text substringToIndex:6];
        }
        
    }
}
-(void)layoutSubviews
{
    [self.hengLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.equalTo(self.mas_top).offset(47);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.hengLine.mas_top).offset(0);
        make.height.mas_equalTo(47);
        make.width.mas_equalTo(47);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.hengLine.mas_top);
    }];
    
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.hengLine.mas_top);
        make.width.mas_equalTo(60);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hengLine.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(47*SCREEN_WIDTH_RATE);
    }];
    
    [self.titleLabelAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom).offset(27);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
    [self.inputViewAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabelAgain.mas_bottom).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(47*SCREEN_WIDTH_RATE);
    }];
}

@end
