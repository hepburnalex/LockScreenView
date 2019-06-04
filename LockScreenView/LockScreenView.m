//
//  LockScreenView.m
//  LockScreenView
//
//  Created by Hepburn on 15/1/28.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import "LockScreenView.h"
#import "LockScreenButton.h"
#import "LockScreenHeader.h"
#import <CommonCrypto/CommonDigest.h>
#import "LockScreenKeyboardView.h"
#import "LockScreenPassView.h"

typedef enum {
    LockScreenType_New,
    LockScreenType_Repeat,
    LockScreenType_Check,
    LockScreenType_Modify,
    LockScreenType_OK
} LockScreenType;

@interface LockScreenView () {
    UIStatusBarStyle mStyle;
}

@property (nonatomic, assign) NSString *correctPass;
@property (nonatomic, strong) NSString *repeatPass;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) LockScreenKeyboardView *inputView;
@property (nonatomic, strong) LockScreenPassView *passView;
@property (nonatomic, readonly) CGFloat keyboardScale;

@property (nonatomic, assign) LockScreenType type;
@property (nonatomic, readonly) BOOL isCorrectPass;


@end

@implementation LockScreenView

#pragma mark - 懒加载
- (LockScreenPassView *)passView {
    if (!_passView) {
        _passView = [[LockScreenPassView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGFAF(50))];
        _passView.tintColor = kTintColor;
        _passView.textColor = [UIColor whiteColor];
        _passView.alertColor = kRedColor;
        _passView.selectColor = [UIColor whiteColor];
    }
    return _passView;
}

- (LockScreenKeyboardView *)inputView {
    if (!_inputView) {
        CGFloat fWidth = MIN(self.frame.size.width, self.frame.size.height)*0.7;
        CGFloat fHeight = fWidth*1.38;
        _inputView = [[LockScreenKeyboardView alloc] initWithFrame:CGRectMake(0, 0, fWidth, fHeight)];
        WS(weakSelf);
        _inputView.OnButtonSelect = ^(NSString * _Nonnull inputtext) {
            [weakSelf OnButtonSelect:inputtext];
        };
        _inputView.tintColor = kTintColor;
        _inputView.textColor = [UIColor whiteColor];
        _inputView.selectColor = [UIColor whiteColor];
    }
    return _inputView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(CGFAF(10), kStatusBarHeight, 40, 40);
        [_backBtn setTitle:@"<" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont fontWithName:@"EuphemiaUCAS" size:20];
        [_backBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.hidden = YES;
        [LockScreenButton CreateCircleLayer:_backBtn :[UIColor yellowColor]];
    }
    return _backBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(self.frame.size.width-60, self.frame.size.height-60, 50, 40);
        _deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deleteBtn addTarget:self action:@selector(OnDelClick) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}

#pragma mark - LifeCycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mStyle = [UIApplication sharedApplication].statusBarStyle;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.backgroundColor = [UIColor colorWithWhite:0.22 alpha:1.0];
        
        [self addSubview:self.backBtn];
        [self addSubview:self.deleteBtn];

        //键盘输入区
        [self addSubview:self.inputView];
        [self addSubview:self.passView];
        [self setFrame:frame];
        
        if (self.correctPass && self.correctPass.length>0) {
            self.type = LockScreenType_Check;
            self.passView.state = LockScreenState_Input;
        }
        else {
            self.type = LockScreenType_New;
            self.passView.state = LockScreenState_NewPass;
        }
    }
    [self AnimateShow];
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.passView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.2*self.keyboardScale);
    self.inputView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.6);
    self.inputView.transform = CGAffineTransformMakeScale(self.keyboardScale, self.keyboardScale);
}

- (void)removeFromSuperview {
    [UIApplication sharedApplication].statusBarStyle = mStyle;
    if (self.backBtn.hidden) {
        NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"hidden", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_LockScreenHidden object:nil userInfo:userinfo];
    }
    [super removeFromSuperview];
}

#pragma mark - Action

- (void)AnimateShow {
    for (UIView *subView in self.subviews) {
        subView.alpha = 0.0;
    }
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView *subView in self.subviews) {
            subView.alpha = 1.0;
        }
    }];
}

- (void)ResetPass {
    self.type = LockScreenType_Modify;
    self.passView.state = LockScreenState_OldPass;
    self.backBtn.hidden = NO;
}

- (void)OnDelClick {
    [self.passView DeletePassText];
    self.deleteBtn.hidden = self.passView.isPassEmpty;
}

- (void)OnButtonSelect:(NSString *)inputtext {
    if (![self.passView AppendPassText:inputtext]) {
        return;
    }
    self.deleteBtn.hidden = self.passView.isPassEmpty;
    if (self.passView.isPassFull) {
        if (self.type == LockScreenType_New) {
            //初次设置密码
            self.repeatPass = self.passView.inputPass;
            self.type = LockScreenType_Repeat;
            self.passView.state = LockScreenState_Repeat;
        }
        else if (self.type == LockScreenType_Repeat) {
            //再次输入密码
            if ([self.repeatPass isEqualToString:self.passView.inputPass]) {
                self.correctPass = self.passView.inputPass;
                self.passView.state = LockScreenState_Confirm;
                [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
                return;
            }
            else {
                self.type = LockScreenType_New;
                self.passView.state = LockScreenState_DiffPass;
            }
        }
        else if (self.type == LockScreenType_Check) {
            //校验密码
            if (self.isCorrectPass) {
                self.passView.state = LockScreenState_OK;
                [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
                return;
            }
            else {
                self.passView.state = LockScreenState_WrongPass;
            }
        }
        else if (self.type == LockScreenType_Modify) {
            //修改密码
            if (self.isCorrectPass) {
                self.type = LockScreenType_New;
                self.passView.state = LockScreenState_NewPass;
            }
            else {
                self.passView.state = LockScreenState_WrongPass;
            }
        }
        [self performSelector:@selector(ReInputPass) withObject:nil afterDelay:0.2];
    }
}

//重新输入密码
- (void)ReInputPass {
    [self.passView CleanPassText];
    self.deleteBtn.hidden = self.passView.isPassEmpty;
}

#pragma mark - property

- (CGFloat)keyboardScale {
    CGFloat scale = self.frame.size.height/(MAX(self.frame.size.width, self.frame.size.height));
    return MAX(scale, 0.7);
}

- (BOOL)isCorrectPass {
    NSString *encStr = [LockScreenView MD5String:self.passView.inputPass];
    return [self.correctPass isEqualToString:encStr];
}

- (NSString *)correctPass {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

- (void)setCorrectPass:(NSString *)value {
    if (value && value.length>0) {
        value = [LockScreenView MD5String:value];
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"password"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    _passView.tintColor = tintColor;
    _inputView.tintColor = tintColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _passView.textColor = textColor;
    _inputView.textColor = textColor;
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    _passView.selectColor = selectColor;
    _inputView.selectColor = selectColor;
}

- (void)setAlertColor:(UIColor *)alertColor {
    _alertColor = alertColor;
    _passView.alertColor = alertColor;
}

#pragma mark - Public

+ (NSString *)MD5String:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (LockScreenView *)ShowInWindow:(UIWindow *)window :(BOOL)bResetPass {
    @autoreleasepool {
        UIView *view = [window viewWithTag:LockScreenTag];
        if (view) {
            [view removeFromSuperview];
        }
    }
    NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"hidden", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_LockScreenHidden object:nil userInfo:userinfo];
    LockScreenView *lockView = [[LockScreenView alloc] initWithFrame:window.bounds];
    lockView.tag = LockScreenTag;
    lockView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [window addSubview:lockView];
    if (bResetPass) {
        [lockView ResetPass];
    }
    return lockView;
}

@end
