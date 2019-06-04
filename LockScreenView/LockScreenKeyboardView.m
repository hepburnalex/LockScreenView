//
//  LockScreenKeyboardView.m
//  LockScreenView
//
//  Created by Hepburn on 2019/6/3.
//  Copyright © 2019 Hepburn. All rights reserved.
//

#import "LockScreenKeyboardView.h"
#import "LockScreenButton.h"
#import "LockScreenHeader.h"

@implementation LockScreenKeyboardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float fOffset = frame.size.width*0.08;
        float fBtnWidth = (frame.size.width-fOffset*2)/3;
        float fontSize = fBtnWidth*0.4;
        
        WS(weakSelf);
        NSArray *namearray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
        for (int i = 0; i < 10; i ++) {
            int iXPos = i%3;
            int iYPos = i/3;
            if (i == 9) {
                iXPos = 1;
            }
            LockScreenButton *btn = [[LockScreenButton alloc] initWithFrame:CGRectMake((fBtnWidth+fOffset)*iXPos, (fBtnWidth+fOffset)*iYPos, fBtnWidth, fBtnWidth)];
            btn.OnButtonSelect = ^(NSString * _Nonnull inputtext) {
                [weakSelf OnButtonClick:inputtext];
            };
            btn.title = namearray[i];
            btn.fontSize = fontSize;
            [self addSubview:btn];
        }
    }
    return self;
}

#pragma mark - Property

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
    for (LockScreenButton *btn in self.subviews) {
        if ([btn isKindOfClass:[LockScreenButton class]]) {
            btn.textColor = textColor;
        }
    }
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    for (LockScreenButton *btn in self.subviews) {
        if ([btn isKindOfClass:[LockScreenButton class]]) {
            btn.selectColor = selectColor;
        }
    }
}

#pragma mark - Action

- (void)OnButtonClick:(NSString *)inputtext {
    if (_OnButtonSelect) {
        _OnButtonSelect(inputtext);
    }
}

@end
