//
//  LockScreenPassView.m
//  LockScreenView
//
//  Created by Hepburn on 2019/6/4.
//  Copyright © 2019 Hepburn. All rights reserved.
//

#import "LockScreenPassView.h"
#import "LockScreenHeader.h"
#import "LockScreenButton.h"

#define LockPassCount   4

@interface LockScreenPassView () {
    
}

@property (nonatomic, strong) UILabel *msgLabel;

@end

@implementation LockScreenPassView

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        CGFloat fontSize = MIN(CGFAF(16), 25);
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGFAF(20))];
        _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    return _msgLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textColor = kTintColor;
        _tintColor = kTintColor;
        _alertColor = [UIColor redColor];
        self.inputPass = @"";
        //提示信息
        [self addSubview:self.msgLabel];
        self.state = LockScreenState_Input;
        self.passCount = LockPassCount;
    }
    return self;
}

- (void)CreateUI {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LockScreenButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    float fMinWidth = IsiPadUI?CGFAF(8):CGFAF(12);
    float fMinOffset = IsiPadUI?CGFAF(16):CGFAF(25);
    float fLeft = (self.frame.size.width-fMinWidth*_passCount-fMinOffset*(_passCount-1))/2;
    
    //顶部密码区
    for (int i = 0; i < _passCount; i ++) {
        LockScreenButton *pointView = [[LockScreenButton alloc] initWithFrame:CGRectMake(fLeft+(fMinWidth+fMinOffset)*i, CGFAF(30), fMinWidth, fMinWidth)];
        pointView.tag = 1000+i;
        pointView.userInteractionEnabled = NO;
        [self addSubview:pointView];
    }
}

- (void)ShakeAlert {
    CGPoint point = self.msgLabel.center;
    WS(weakSelf);
    [UIView animateWithDuration:0.05 animations:^{
        weakSelf.msgLabel.center = CGPointMake(point.x-10, point.y);
    }completion:^(BOOL finish) {
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.msgLabel.center = CGPointMake(point.x+10, point.y);
        }completion:^(BOOL finish) {
            [UIView animateWithDuration:0.05 animations:^{
                weakSelf.msgLabel.center = CGPointMake(point.x, point.y);
            }completion:^(BOOL finish) {
            }];
        }];
    }];
}

- (void)RefreshStatus {
    for (int i = 0; i < _passCount; i ++) {
        LockScreenButton *pointView = (LockScreenButton *)[self viewWithTag:1000+i];
        pointView.isSelected = (i<self.inputPass.length);
    }
}

- (BOOL)AppendPassText:(NSString *)passText {
    if (self.inputPass.length >= _passCount) {
        return NO;
    }
    self.inputPass = [self.inputPass stringByAppendingString:passText];
    [self RefreshStatus];
    return YES;
}

- (void)DeletePassText {
    if (self.inputPass.length > 0) {
        self.inputPass = [self.inputPass substringToIndex:self.inputPass.length-1];
        [self RefreshStatus];
    }
}

- (void)CleanPassText {
    self.inputPass = @"";
    [self RefreshStatus];
}

#pragma mark - Property

- (void)setPassCount:(NSInteger)passCount {
    _passCount = passCount;
    [self CreateUI];
}

- (void)setState:(LockScreenState)state {
    _state = state;
    if (_state == LockScreenState_WrongPass) {
        self.msgLabel.textColor = _alertColor;
        self.msgLabel.text = @"密码错误";
        [self ShakeAlert];
    }
    else if (_state == LockScreenState_DiffPass) {
        self.msgLabel.textColor = _alertColor;
        self.msgLabel.text = @"两次输入密码不一致";
        [self ShakeAlert];
    }
    else if (_state == LockScreenState_Input) {
        self.msgLabel.textColor = _textColor;
        self.msgLabel.text = @"请输入密码";
    }
    else if (_state == LockScreenState_OldPass) {
        self.msgLabel.textColor = _textColor;
        self.msgLabel.text = @"请输入旧密码";
    }
    else if (_state == LockScreenState_NewPass) {
        self.msgLabel.textColor = _textColor;
        self.msgLabel.text = @"请输入新密码";
    }
    else if (_state == LockScreenState_Confirm) {
        self.msgLabel.textColor = _textColor;
        self.msgLabel.text = @"密码确认";
    }
    else if (_state == LockScreenState_Repeat) {
        self.msgLabel.textColor = _textColor;
        self.msgLabel.text = @"请再次输入密码";
    }
    else if (_state == LockScreenState_OK) {
        self.msgLabel.textColor = _textColor;
        self.msgLabel.text = @"密码正确";
    }
}

- (BOOL)isPassEmpty {
    return self.inputPass.length == 0;
}

- (BOOL)isPassFull {
    return self.inputPass.length == _passCount;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    for (LockScreenButton *btn in self.subviews) {
        if ([btn isKindOfClass:[LockScreenButton class]]) {
            btn.tintColor = tintColor;
        }
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setState:_state];
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    for (LockScreenButton *btn in self.subviews) {
        if ([btn isKindOfClass:[LockScreenButton class]]) {
            btn.selectColor = selectColor;
        }
    }
}

- (void)setAlertColor:(UIColor *)alertColor {
    _alertColor = alertColor;
    [self setState:_state];
}

@end
