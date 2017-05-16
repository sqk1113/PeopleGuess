//
//  SelfSetController.m
//  PeopleGuess
//
//  Created by mac on 17/2/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SelfSetController.h"
#import "SelfSetCell.h"
#import "ZFActionSheet.h"
#import "LoginOutView.h"
#import "LoginController.h"
#import "PassWordView.h"
@interface SelfSetController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,ZFActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,selfSetDelegate>
{
    UITapGestureRecognizer *singleRecognizer;//轻拍手势（取消键盘）
    BOOL isChangeHeadImg;
    NSString *imgNameStr;
    MBProgressHUD *posthud;
    UITextField *tfNickName;
    BOOL isSelectMobile;
    BOOL isSelectPassWord;
}
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSMutableArray *listArr;

@property (nonatomic,strong)UIView *blackView;
@property (nonatomic,strong)UIView *bdMobileView;
@property (nonatomic,strong)PassWordView *setPassWord;
@property (nonatomic,strong)UITextField *tfMobile;
@property (nonatomic,strong)UITextField *tfCode;
@end

@implementation SelfSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationBarBackgroundColor = NAVBARMAINCOLOR;
    NSArray *arr1 = [NSArray arrayWithObjects:@"头像",@"昵称",@"性别", nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"手机",@"支付密码", nil];
    NSArray *arr3 = [NSArray arrayWithObjects:@"关于我们",@"退出登录", nil];
    _listArr = [NSMutableArray arrayWithObjects:arr1,arr2,arr3,nil];
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = BACKGROINDCOLOR;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _blackView = [[UIView alloc]init];
    _blackView.frame = self.view.bounds;
    _blackView.hidden = YES;
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4;
    [self.view  addSubview:_blackView];
    
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.blackView addGestureRecognizer:singleRecognizer];
    
    [self creatBindingMobileUI];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

//轻拍取消键盘
-(void)handleSingleTapFrom{
    [_tfCode resignFirstResponder];
    [_tfMobile resignFirstResponder];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    WS(weakSelf);
    if (isSelectMobile==YES) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.bdMobileView.frame = CGRectMake(0, SCREEN_HEIGHT-weakSelf.bdMobileView.frame.size.height-height, weakSelf.bdMobileView.frame.size.width,weakSelf.bdMobileView.frame.size.height);
            
        }];
    }
    if (isSelectPassWord==YES) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.setPassWord.frame = CGRectMake(0, SCREEN_HEIGHT-weakSelf.setPassWord.frame.size.height-height, weakSelf.setPassWord.frame.size.width,weakSelf.setPassWord.frame.size.height);
            
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    WS(weakSelf);
    if (isSelectMobile==YES) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bdMobileView.frame = CGRectMake(0, SCREEN_HEIGHT-weakSelf.bdMobileView.frame.size.height, weakSelf.bdMobileView.frame.size.width,weakSelf.bdMobileView.frame.size.height);
            
        }];
    }
    if (isSelectPassWord==YES) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.setPassWord.frame = CGRectMake(0, SCREEN_HEIGHT-weakSelf.setPassWord.frame.size.height, weakSelf.setPassWord.frame.size.width,weakSelf.setPassWord.frame.size.height);
            
        }];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==tfNickName) {
        isSelectMobile=NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==tfNickName) {
        if (tfNickName.text.length>=20)
        {
            [[Toast shareToast]makeText:@"昵称超出最大长度限制" time:1];
            return YES;
        }
        if(tfNickName.text.length==0)
        {
            [[Toast shareToast]makeText:@"昵称不能为空" time:1];
            return YES;
        }
        [self updateUserWithNickName:tfNickName.text withGender:0 withMobile:nil withPw:nil withCode:nil];
    }
    return YES;
}
#pragma mark request
- (void)getCodeWithPhoneNum
{
    if ([Tool isBlankString:_tfMobile.text]) {
        [[Toast shareToast]makeText:@"请输入手机号" time:1];
        return;
    }
    MBProgressHUD *hud = [Tool showMBProgressHUDWithTitle:@"正在发送验证码" inView:self.view];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_tfMobile.text forKey:@"mobile"];
    [dic setValue:@(1) forKey:@"type"];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,GETPHONECODE]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            hud.labelText = @"发送成功，请注意查收";
            [hud hide:YES afterDelay:1];
        }
        else
        {
            hud.labelText = response.msg;
            [hud hide:YES afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        hud.labelText = @"发送失败，请稍后再试";
        [hud hide:YES afterDelay:1];
    }];
}
- (void)updateUserWithNickName:(NSString *)nickName withGender:(int)gender withMobile:(NSString *)mobile withPw:(NSString *)password withCode:(NSString *)code
{
    MBProgressHUD *hud = [Tool showMBProgressHUDWithTitle:@"正在验证" inView:self.view];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (nickName) {
        [dic setValue:nickName forKey:@"nickName"];
    }
    if (gender!=0) {
        [dic setValue:@(gender) forKey:@"gender"];
    }
    if (mobile) {
        [dic setValue:mobile forKey:@"mobile"];
    }
    if (password) {
        [dic setValue:password forKey:@"payPassword"];
    }
    if (code) {
        [dic setValue:code forKey:@"code"];
    }

    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,USERUPDATE]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            hud.labelText = @"修改成功";
            [hud hide:YES afterDelay:1];
            if (nickName) {
                [CoreArchive setStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]]     key:KNickName];
                [Singleton sharedSingleton].nickName = [dic objectForKey:@"nickName"];
            }
            if (gender!=0) {
                [CoreArchive setStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"gender"]]     key:KGender];
                [Singleton sharedSingleton].gender =[NSString stringWithFormat:@"%@",[dic objectForKey:@"gender"]];
            }
            if (mobile) {
                [CoreArchive setStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile"]]     key:KMobile];
                [Singleton sharedSingleton].mobile =[NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile"]];
            }
            if (password) {
                [CoreArchive setStr:[NSString stringWithFormat:@"%@",@"1"] key:KHasPayPass];
                [Singleton sharedSingleton].hasPayPass =[NSString stringWithFormat:@"%@",@"1"];
                [self closePasswordView];
            }
            [_table reloadData];
        }
        else
        {
            hud.labelText = response.msg;
            [hud hide:YES afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        hud.labelText = @"修改失败，请稍后再试";
        [hud hide:YES afterDelay:1];
    }];
    
}

-(void)loginOut
{
    MBProgressHUD *hud = [Tool showMBProgressHUDWithTitle:@"正在登出您的账号..." inView:self.view];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,LOGINOUT]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            LoginController *vc = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
            [ApplicationDelegate.window setRootViewController:vc];
            [ApplicationDelegate clearUserInfo];
            [hud hide:YES afterDelay:0];
        }
        else
        {
            hud.labelText = response.msg;
            [hud hide:YES afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        hud.labelText = @"登出失败，请稍后再试";
        [hud hide:YES afterDelay:1];
    }];

}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_listArr objectAtIndex:section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelfSetCell * cell = [SelfSetCell cellWithTableView:tableView];
    cell.leftText.text = [[_listArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([cell.leftText.text isEqualToString:@"退出登录"]) {
        cell.leftText.textColor = UIColorFromRGB(0xee0c11);
    }
    if (indexPath.section==0&&indexPath.row==0) {
        cell.rightText.hidden = YES;
        if ([Tool isBlankString:[Singleton sharedSingleton].logo]) {
            cell.headIcon.image = [UIImage imageNamed:@"image_mine"];
        }
        else{
            [cell.headIcon sd_setImageWithURL:[NSURL URLWithString:[Singleton sharedSingleton].logo] placeholderImage:[UIImage imageNamed:@"image_mine"]];
        }
        [Tool addSepLine:CGRectMake(15, 43.5, SCREEN_WIDTH-15, 0.5) inView:cell];
    }
    if (indexPath.section==0&&indexPath.row==1) {
        [Tool addSepLine:CGRectMake(15, 43.5, SCREEN_WIDTH-15, 0.5) inView:cell];
        tfNickName = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-15, 44)];
        tfNickName.textAlignment = NSTextAlignmentRight;
        tfNickName.font = [UIFont fontWithName:PFREGULARFONT size:15];
        tfNickName.textColor =NAVBARMAINCOLOR;
        tfNickName.text =[Singleton sharedSingleton].nickName;
        tfNickName.borderStyle = UITextBorderStyleNone;
        tfNickName.returnKeyType = UIReturnKeyDone;
        tfNickName.delegate = self;
        [cell addSubview:tfNickName];
        cell.rightText.hidden = YES;
    }
    if (indexPath.section==0&&indexPath.row==2) {
        if ([[Singleton sharedSingleton].gender intValue]==0) {
            cell.rightText.text = @"未设置";
            cell.rightText.textColor = UIColorFromRGB(0xa9a9a9);
        }
        else if([[Singleton sharedSingleton].gender intValue]==1)
        {
            cell.rightText.text = @"男";
            cell.rightText.textColor = NAVBARMAINCOLOR;
        }
        else
        {
            cell.rightText.text = @"女";
            cell.rightText.textColor = NAVBARMAINCOLOR;
        }
    }
    if (indexPath.section==1&&indexPath.row==0) {
        [Tool addSepLine:CGRectMake(15, 43.5, SCREEN_WIDTH-15, 0.5) inView:cell];
        if ([Tool isBlankString:[Singleton sharedSingleton].mobile]) {
            cell.rightText.text = @"未设置";
            cell.rightText.textColor = UIColorFromRGB(0xa9a9a9);
        }
        else
        {
            cell.rightText.text = [Singleton sharedSingleton].mobile;
            cell.rightText.textColor = NAVBARMAINCOLOR;
        }
    }
    
    if (indexPath.section==1&&indexPath.row==1) {
        if ([[Singleton sharedSingleton].hasPayPass intValue]==0) {
            cell.rightText.text = @"未设置";
            cell.rightText.textColor = UIColorFromRGB(0xa9a9a9);
        }
        else
        {
            cell.rightText.text = @"已设置";
            cell.rightText.textColor = NAVBARMAINCOLOR;
        }
    }
    if (indexPath.section==2&&indexPath.row==0) {
        [Tool addSepLine:CGRectMake(15, 43.5, SCREEN_WIDTH-15, 0.5) inView:cell];
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(13*SCREEN_WIDTH_RATE, 18*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 14*SCREEN_WIDTH_RATE)];
    view.backgroundColor = BACKGROINDCOLOR;
    if (section==2) {
        return view;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(13*SCREEN_WIDTH_RATE, 18*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 14*SCREEN_WIDTH_RATE)];
    label.textColor = UIColorFromRGB(0x888888);
    label.font = [UIFont fontWithName:PFREGULARFONT size:14*SCREEN_WIDTH_RATE];
    [view addSubview:label];
    if (section==0)
    {
        label.text = @"个人信息";
    }
    else
    {
        label.text = @"账号";
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2)
        return 18;
    else
        return 42;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isSelectMobile = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0) {
        ZFActionSheet *actionSheet = [ZFActionSheet actionSheetWithTitle:nil confirms:@[@"拍摄",@"从手机相册选择"] cancel:@"取消" style:ZFActionSheetStyleCancel];
        actionSheet.delegate = self;
        actionSheet.tag=1;
        [actionSheet showInView:self.view.window];
    }
    
    if (indexPath.section==0&&indexPath.row==2) {
        ZFActionSheet *actionSheet = [ZFActionSheet actionSheetWithTitle:nil confirms:@[@"男",@"女"] cancel:@"取消" style:ZFActionSheetStyleCancel];
        actionSheet.delegate = self;
        actionSheet.tag=2;
        [actionSheet showInView:self.view.window];
    }
    if (indexPath.section==1&&indexPath.row==0) {
        isSelectMobile = YES;
        isSelectPassWord = NO;
        _blackView.hidden = NO;
        _blackView.alpha = 0.5;
        [UIView animateWithDuration:0.3 animations:^{
            _bdMobileView.frame = CGRectMake(0, SCREEN_HEIGHT-_bdMobileView.frame.size.height, _bdMobileView.frame.size.width,_bdMobileView.frame.size.height);
            
        }];
        //轻怕手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlerTap:)];
        tap.numberOfTapsRequired=1;
        tap.numberOfTouchesRequired = 1;
        [self.blackView addGestureRecognizer:tap];
    }
    
    if (indexPath.section==1&&indexPath.row==1) {
        isSelectMobile = NO;
        isSelectPassWord = YES;
        _blackView.hidden = NO;
        _blackView.alpha = 0.5;
        if (!_setPassWord) {
            _setPassWord = [[PassWordView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 270)];
            [self.view addSubview:_setPassWord];
            _setPassWord.delegate = self;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _setPassWord.frame = CGRectMake(0, SCREEN_HEIGHT-_setPassWord.frame.size.height, _setPassWord.frame.size.width,_setPassWord.frame.size.height);
            if (_setPassWord.textfiled2.text.length>0) {
                [_setPassWord.textfiled2 becomeFirstResponder];
            }
            else{
                [_setPassWord.textfiled1 becomeFirstResponder];
            }
        }];
        
        //轻怕手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlerTap:)];
        tap.numberOfTapsRequired=1;
        tap.numberOfTouchesRequired = 1;
        [self.blackView addGestureRecognizer:tap];
    }
    
    if (indexPath.section==2&&indexPath.row==1) {
        WS(weakSelf);
        [LoginOutView showPopView:^(UIButton *btn) {
            [weakSelf loginOut];
        }];
    }
}
#pragma mark SelfSetDelegate
-(void)closePasswordView
{
    [_setPassWord.textfiled1 resignFirstResponder];
    [_setPassWord.textfiled2 resignFirstResponder];
    _blackView.hidden = YES;
    _blackView.alpha = 1;
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.setPassWord.frame = CGRectMake(0, SCREEN_HEIGHT, weakSelf.setPassWord.frame.size.width,weakSelf.setPassWord.frame.size.height);
        weakSelf.table.alpha = 1;
    }];

}
-(void)enterSetPassword
{
    NSLog(@"%@-----%@",_setPassWord.textfiled1.text,_setPassWord.textfiled2.text);
    if (![_setPassWord.textfiled1.text isEqualToString:_setPassWord.textfiled2.text]) {
        [[Toast shareToast]makeText:@"两次密码输入不一致" time:1];
        return;
    }
    [self updateUserWithNickName:nil withGender:0 withMobile:nil withPw:_setPassWord.textfiled1.text withCode:nil];
    
}


#pragma mark - ZFActionSheetDelegate
- (void)clickAction:(ZFActionSheet *)actionSheet atIndex:(NSUInteger)index
{
    if (actionSheet.tag==1) {
        if (index==0)
        {
            NSLog(@"拍照");
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            //设置数据源类型
            imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagepicker.allowsEditing = YES;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
        else
        {
            NSLog(@"从相册选择");
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //是否允许用户操作
            imagepicker.allowsEditing = YES;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
    }
    if (actionSheet.tag==2) {
        if (index==0)
        {
            [self updateUserWithNickName:nil withGender:1 withMobile:nil withPw:nil withCode:nil];

        }
        else
        {
            [self updateUserWithNickName:nil withGender:2 withMobile:nil withPw:nil withCode:nil];
        }
    }

}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    UIImage * cmpImage = [Tool imageCompressForSize:image targetSize:CGSizeMake(800, 800)];
    //压缩
    NSData * imageData = UIImageJPEGRepresentation(cmpImage, 0.2);
    //    imgData = imageData;
    isChangeHeadImg = YES;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f.jpg",a];
    //重命名为md5值
    imgNameStr = [self saveImage:imageData withName:timeString];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgNameStr];
    NSLog(@"_imgChoose full path is %@", fullPath);
    [self dismissViewControllerAnimated:YES completion:nil];
    [self save];
}

#pragma mark 保存图片进入沙盒
- (NSString *)saveImage:(NSData *)imageData withName:(NSString *)imageName{
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSLog(@"full path is %@", fullPath);
    [imageData writeToFile:fullPath atomically:NO];
    NSString * md5Name = [Tool  getFileMD5:fullPath];
    md5Name = [md5Name stringByAppendingString:@".jpg"];
    NSString * md5Path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:md5Name];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath: md5Path isDirectory:nil] == YES) {
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    }else{
        if ([[NSFileManager defaultManager] moveItemAtPath:fullPath toPath:md5Path error:&error] != YES){
            NSLog(@"%@", error);
        }
    }
    return md5Name;
}

-(void)save
{
    if (isChangeHeadImg==YES) {
        posthud = [Tool showMBProgressHUDWithTitle:@"正在上传..." inView:self.view];
        [self postImage];
    }
}
-(void)postImage
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    NSData *data = [NSData dataWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgNameStr]];
    NSString *str = [NSString stringWithFormat:@"?v=%@&t=%@&s=%@",[dic objectForKey:@"v"],[dic objectForKey:@"t"],signature];
    ZZFormData *formData = [[ZZFormData alloc] init];
    formData.data = data;
    formData.name = @"file";
    formData.filename =imgNameStr;
    formData.mimeType = @"image/jpg";
    WS(weakSelf);
    [ZZHttpTool postWithURL:[NSString stringWithFormat:@"%@%@%@",SERVER_HOST,UPDATELOGO,str] params:dic formDataArray:@[formData] success:^(id json) {
        NSLog(@"%@",json);
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000) {
            posthud.labelText=@"上传成功!";
            [posthud hide:YES afterDelay:1];
            [CoreArchive setStr:[NSString stringWithFormat:@"%@",[response.data objectForKey:@"logo"]]     key:KLogo];
            [Singleton sharedSingleton].logo = [response.data objectForKey:@"logo"];
            [weakSelf.table reloadData];
        }
        
    } failure:^(NSError *error) {
        posthud.labelText=@"连接超时!";
        [posthud hide:YES afterDelay:1];
    }];
}

#pragma mark 创建绑定手机号码UI

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.table endEditing:YES];
    [self closeView];
    [self closeSetPassWord];
}

-(void)handlerTap:(UIGestureRecognizer *)sender
{
//    [self closeView];
}

//关闭设置密码
-(void)closeSetPassWord
{
    [self.view endEditing:YES];
    _blackView.hidden = YES;
    _blackView.alpha = 1;
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.setPassWord.frame = CGRectMake(0, SCREEN_HEIGHT, weakSelf.setPassWord.frame.size.width,weakSelf.setPassWord.frame.size.height);
        weakSelf.table.alpha = 1;
    }];
}
//关闭修改手机号码
-(void)closeView{
    [_tfMobile resignFirstResponder];
    [_tfCode resignFirstResponder];
    _blackView.hidden = YES;
    _blackView.alpha = 1;
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bdMobileView.frame = CGRectMake(0, SCREEN_HEIGHT, weakSelf.bdMobileView.frame.size.width,weakSelf.bdMobileView.frame.size.height);
        weakSelf.table.alpha = 1;
    }];
}


-(void)creatBindingMobileUI
{
    _bdMobileView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 534/2*SCREEN_WIDTH_RATE)];
    _bdMobileView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48*SCREEN_WIDTH_RATE)];
    text.text = @"绑定手机号码";
    text.font = [UIFont fontWithName:PFREGULARFONT size:18*SCREEN_WIDTH_RATE];
    text.textAlignment = NSTextAlignmentCenter;
    [_bdMobileView addSubview:text];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48*SCREEN_WIDTH_RATE, 48*SCREEN_WIDTH_RATE)];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [_bdMobileView addSubview:closeBtn];
    
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-57*SCREEN_WIDTH_RATE, 0, 57*SCREEN_WIDTH_RATE, 48*SCREEN_WIDTH_RATE)];
    [enterBtn setTitle:@"完成" forState:UIControlStateNormal];
    [enterBtn setTitleColor:NAVBARMAINCOLOR forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:15*SCREEN_WIDTH_RATE];
    [enterBtn addTarget:self action:@selector(changeMobileNum) forControlEvents:UIControlEventTouchUpInside];
    [_bdMobileView addSubview:enterBtn];
    
    [Tool addSepLine:CGRectMake(0, 48*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 0.5) inView:_bdMobileView];
    
    UIImageView *mobIcon = [[UIImageView alloc]initWithFrame:CGRectMake(73*SCREEN_WIDTH_RATE, VIEWY(text)+52*SCREEN_WIDTH_RATE, 14*SCREEN_WIDTH_RATE, 14*SCREEN_WIDTH_RATE)];
    mobIcon.image = [UIImage imageNamed:@"mine_binding"];
    [_bdMobileView addSubview:mobIcon];
    
    
    UIImageView *codeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(73*SCREEN_WIDTH_RATE, VIEWY(mobIcon)+36*SCREEN_WIDTH_RATE, 14*SCREEN_WIDTH_RATE, 14*SCREEN_WIDTH_RATE)];
    codeIcon.image = [UIImage imageNamed:@"code_binding"];
    [_bdMobileView addSubview:codeIcon];
    
    
    _tfMobile = [[UITextField alloc]initWithFrame:CGRectMake(VIEWX(mobIcon)+11*SCREEN_WIDTH_RATE, VIEWY(text)+44*SCREEN_WIDTH_RATE, 205*SCREEN_WIDTH_RATE, 30*SCREEN_WIDTH_RATE)];
    _tfMobile.placeholder = @"请输入手机号";
    _tfMobile.font = [UIFont fontWithName:PFREGULARFONT size:15*SCREEN_WIDTH_RATE];
    _tfMobile.borderStyle = UITextBorderStyleNone;
    _tfMobile.keyboardType = UIKeyboardTypeNumberPad;
    [_bdMobileView addSubview:_tfMobile];
    
    _tfCode = [[UITextField alloc]initWithFrame:CGRectMake(VIEWX(mobIcon)+11*SCREEN_WIDTH_RATE, VIEWY(_tfMobile)+21*SCREEN_WIDTH_RATE, 130*SCREEN_WIDTH_RATE, 30*SCREEN_WIDTH_RATE)];
    _tfCode.placeholder = @"请输入验证码";
    _tfCode.font = [UIFont fontWithName:PFREGULARFONT size:15*SCREEN_WIDTH_RATE];
    _tfCode.borderStyle = UITextBorderStyleNone;
    _tfCode.keyboardType = UIKeyboardTypeNumberPad;
    [_bdMobileView addSubview:_tfCode];
    
    UIButton *getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140.5*SCREEN_WIDTH_RATE, VIEWY(text)+95*SCREEN_WIDTH_RATE, 68*SCREEN_WIDTH_RATE, 30*SCREEN_WIDTH_RATE)];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getCodeBtn.backgroundColor = NAVBARMAINCOLOR;
    getCodeBtn.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE];
    [getCodeBtn addTarget:self action:@selector(getCodeWithPhoneNum) forControlEvents:UIControlEventTouchUpInside];
    [_bdMobileView addSubview:getCodeBtn];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(mobIcon.frame.origin.x, VIEWY(_tfMobile), SCREEN_WIDTH-145*SCREEN_WIDTH_RATE, 0.5)];
    line1.backgroundColor = NAVBARMAINCOLOR;
    [_bdMobileView addSubview:line1];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(mobIcon.frame.origin.x, VIEWY(_tfCode), SCREEN_WIDTH-225*SCREEN_WIDTH_RATE, 0.5)];
    line2.backgroundColor = NAVBARMAINCOLOR;
    [_bdMobileView addSubview:line2];
    
    [self.view addSubview:_bdMobileView];
}

-(void)changeMobileNum
{
    if ([Tool isBlankString:_tfMobile.text]) {
        [[Toast shareToast]makeText:@"请输入手机号" time:1];
        return;
    }
    if ([Tool isBlankString:_tfCode.text]) {
        [[Toast shareToast]makeText:@"请输入验证码" time:1];
        return;
    }
    [self updateUserWithNickName:nil withGender:0 withMobile:_tfMobile.text withPw:nil withCode:_tfCode.text];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
