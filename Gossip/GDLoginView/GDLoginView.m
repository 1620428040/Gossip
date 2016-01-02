//
//  LoginViewController.m
//  GDFW
//
//  Created by 国栋 on 15/12/11.
//  Copyright (c) 2015年 GD. All rights reserved.
//


#import "GDLoginView.h"

#define sw (self.frame.size.width)
#define sh (self.frame.size.height)

@interface GDLoginView ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property UIButton *grayView;
@property UITableView *customUserList;
@property CustomUserManager *customUserManager;

@property BOOL isSavePassword;
@property BOOL isAutoLogin;

@property NSString *savepath;
@end

@implementation GDLoginView

@synthesize delegate,accountInputField,passwordInputField,background,portraits,loginButton,registerButton,grayView,customUserList,savePassword,forgetPassword,autoLogin,isAutoLogin,isSavePassword,imageForYes,imageForNo,customUserManager,savepath;

+(id)createWithDelegate:(id<GDLoginViewDelegate>)delegate frame:(CGRect)rect
{
    GDLoginView *new=[[self alloc]initWithFrame:rect];
    new.delegate=delegate;
    return new;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        //读取已存在的数据
        customUserManager=[CustomUserManager share];
        
        background=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sw, sh)];
        background.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"backgroundImage1" ofType:@"png"]];
        background.backgroundColor=[UIColor whiteColor];
        
        imageForYes=[UIImage imageNamed:@"选中.png"];
        imageForNo=[UIImage imageNamed:@"未选中.png"];
        
        portraits=[[Portraits alloc]initWithFrame:CGRectMake(sw*0.3, sh*0.15, sw*0.4, sw*0.4)];
        //portraits.layer.cornerRadius=75;
        portraits.backgroundColor=[UIColor whiteColor];
        portraits.clipsToBounds=YES;
        [portraits setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"head1" ofType:@"png"]] forState:UIControlStateNormal];
        [portraits addTarget:self action:@selector(selectAccount) forControlEvents:UIControlEventTouchUpInside];
        
        accountInputField=[[UITextField alloc]initWithFrame:CGRectMake(sw*0.1, sh*0.5, sw*0.8, 30)];
        accountInputField.backgroundColor=[UIColor whiteColor];
        accountInputField.delegate=self;
        accountInputField.placeholder=@"  用户名";
        accountInputField.layer.cornerRadius=10;
        
        passwordInputField=[[UITextField alloc]initWithFrame:CGRectMake(sw*0.1, sh*0.6, sw*0.8, 30)];
        passwordInputField.backgroundColor=[UIColor whiteColor];
        passwordInputField.delegate=self;
        passwordInputField.placeholder=@"  密码";
        passwordInputField.layer.cornerRadius=10;
        passwordInputField.secureTextEntry=YES;
        
        registerButton=[[UIButton alloc]initWithFrame:CGRectMake(sw*0.1, sh*0.8, sw*0.2, 30)];
        registerButton.backgroundColor=[UIColor grayColor];
        registerButton.layer.cornerRadius=10;
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [registerButton addTarget:delegate action:@selector(registerView) forControlEvents:UIControlEventTouchDown];
        
        loginButton=[[UIButton alloc]initWithFrame:CGRectMake(sw*0.7, sh*0.8, sw*0.2, 30)];
        loginButton.backgroundColor=[UIColor grayColor];
        loginButton.layer.cornerRadius=10;
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(checkingAccount) forControlEvents:UIControlEventTouchDown];
        
        savePassword=[[UIButton alloc]initWithFrame:CGRectMake(sw*0.1, sh*0.7, sw*0.35, 30)];
        savePassword.backgroundColor=[UIColor grayColor];
        savePassword.layer.cornerRadius=10;
        [savePassword setTitle:@"记住密码" forState:UIControlStateNormal];
        [savePassword setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        if (isSavePassword==YES) {
            [savePassword setImage:imageForYes forState:UIControlStateNormal];
        }
        else
        {
            [savePassword setImage:imageForNo forState:UIControlStateNormal];
        }
        [savePassword addTarget:self action:@selector(savePasswordHandler) forControlEvents:UIControlEventTouchDown];
        
        forgetPassword=[[UIButton alloc]initWithFrame:CGRectMake(sw*0.35, sh*0.8, sw*0.3, 30)];
        forgetPassword.backgroundColor=[UIColor grayColor];
        forgetPassword.layer.cornerRadius=10;
        [forgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetPassword setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [forgetPassword addTarget:self action:@selector(forgetPasswordHandler) forControlEvents:UIControlEventTouchDown];
        
        autoLogin=[[UIButton alloc]initWithFrame:CGRectMake(sw*0.55, sh*0.7, sw*0.35, 30)];
        autoLogin.backgroundColor=[UIColor grayColor];
        autoLogin.layer.cornerRadius=10;
        [autoLogin setTitle:@"自动登录" forState:UIControlStateNormal];
        [autoLogin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        if (isAutoLogin==YES) {
            [autoLogin setImage:imageForYes forState:UIControlStateNormal];
        }
        else
        {
            [autoLogin setImage:imageForNo forState:UIControlStateNormal];
        }
        [autoLogin addTarget:self action:@selector(autoLoginHandler) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:background];
        [self addSubview:portraits];
        [self addSubview:accountInputField];
        [self addSubview:passwordInputField];
        [self addSubview:registerButton];
        [self addSubview:loginButton];
        [self addSubview:savePassword];
        [self addSubview:forgetPassword];
        [self addSubview:autoLogin];
        
        //常用账号
        if (customUserManager.list.count>0) {
            CustomUser *aUser=[customUserManager.list firstObject];
            accountInputField.text=aUser.account;
            passwordInputField.text=aUser.password;
            [portraits setImage:aUser.icon forState:UIControlStateNormal];
            isAutoLogin=aUser.isAutoLogin;
            isSavePassword=aUser.isSavePassword;
            if (isSavePassword==YES) {
                [savePassword setImage:imageForYes forState:UIControlStateNormal];
            }
            else
            {
                [savePassword setImage:imageForNo forState:UIControlStateNormal];
            }
            if (isAutoLogin==YES) {
                [autoLogin setImage:imageForYes forState:UIControlStateNormal];
                [self checkingAccount];
            }
            else
            {
                [autoLogin setImage:imageForNo forState:UIControlStateNormal];
            }
        }
    }
    return self;
}
-(void)savePasswordHandler
{
    if (isSavePassword==NO) {
        isSavePassword=YES;
        [savePassword setImage:imageForYes forState:UIControlStateNormal];
    }
    else
    {
        isSavePassword=NO;
        [savePassword setImage:imageForNo forState:UIControlStateNormal];
        isAutoLogin=NO;
        [autoLogin setImage:imageForNo forState:UIControlStateNormal];
    }
}
-(void)forgetPasswordHandler
{
    [delegate findBackPassword];
}
-(void)autoLoginHandler
{
    if (isAutoLogin==NO) {
        isAutoLogin=YES;
        [autoLogin setImage:imageForYes forState:UIControlStateNormal];
        isSavePassword=YES;
        [savePassword setImage:imageForYes forState:UIControlStateNormal];
    }
    else
    {
        isAutoLogin=NO;
        [autoLogin setImage:imageForNo forState:UIControlStateNormal];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)checkingAccount
{
    CustomUser *user=[[CustomUser alloc]init];
    user.account=accountInputField.text;
    user.password=passwordInputField.text;
    CustomUser *back=[delegate checkingAccount:user];
    if (back==nil) {
        UIAlertView *accounterror=[[UIAlertView alloc]initWithTitle:@"账号或密码错误" message:@"账号或密码错误，请重新输入或注册账号" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [accounterror show];
    }
    else
    {
        [customUserManager deleteArray:[customUserManager findObjectIn:@"account" for:back.account]];
        if (isSavePassword==NO) {
            back.password=nil;
        }
        [customUserManager addWithicon:back.icon account:back.account password:back.password isSavePassword:isSavePassword isAutoLogin:isAutoLogin];
        [delegate nextView];
    }
}

//常用账号列表
-(void)selectAccount
{
    if ([customUserManager getall].count==0) {
        return;
    }
    grayView=[[UIButton alloc]initWithFrame:CGRectMake(sw, 0, sw, sh)];
    grayView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    
    customUserList=[[UITableView alloc]initWithFrame:CGRectMake(sw*0.1, sh*0.1, sw*0.8, sh*0.6)];
    customUserList.dataSource=self;
    customUserList.delegate=self;
    customUserList.layer.cornerRadius=20;
    [grayView addSubview:customUserList];
    [grayView addTarget:self action:@selector(closeList) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:grayView];
    
    [UIView animateWithDuration:0.5 animations:^{
        grayView.frame=[UIScreen mainScreen].bounds;
    }];
}
-(void)closeList
{
    [UIView animateWithDuration:0.5 animations:^{
        grayView.center=CGPointMake(sw*1.5, sh*0.5);
    } completion:^(BOOL finished) {
        [grayView removeFromSuperview];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [customUserManager getall].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[UITableViewCell new];
    CustomUser *aUser=[[customUserManager getall] objectAtIndex:indexPath.row];

    UIImageView *usericon=[[UIImageView alloc]initWithFrame:CGRectMake(30, 2, 40, 40)];
    usericon.image=aUser.icon;
    [cell addSubview:usericon];
    
    UILabel *account=[[UILabel alloc]initWithFrame:CGRectMake(100, 3, sw*0.3, 44)];
    account.text=aUser.account;
    [cell addSubview:account];
    
    UIButton *delete=[[UIButton alloc]initWithFrame:CGRectMake(260, 2, 40, 40)];
    [delete setTitle:@"❌" forState:UIControlStateNormal];
    delete.tag=indexPath.row;
    [delete addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:delete];
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"常用账号";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomUser *selUser=[[customUserManager getall] objectAtIndex:indexPath.row];
    [portraits setImage:selUser.icon forState:UIControlStateNormal];
    accountInputField.text=selUser.account;
    passwordInputField.text=selUser.password;
    isAutoLogin=selUser.isAutoLogin;
    isSavePassword=selUser.isSavePassword;
    if (isSavePassword==YES) {
        [savePassword setImage:imageForYes forState:UIControlStateNormal];
    }
    else
    {
        [savePassword setImage:imageForNo forState:UIControlStateNormal];
    }
    if (isAutoLogin==YES) {
        [autoLogin setImage:imageForYes forState:UIControlStateNormal];
    }
    else
    {
        [autoLogin setImage:imageForNo forState:UIControlStateNormal];
    }
    [self closeList];
}
-(void)deleteCell:(UIButton*)sender
{
    [customUserManager deleteObject:[[customUserManager getall] objectAtIndex:sender.tag]];
    [customUserList reloadData];
}
@end
