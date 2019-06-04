//
//  LockScreenButton.m
//  LockScreenView
//
//  Created by Hepburn on 2019/5/28.
//  Copyright © 2019 Hepburn. All rights reserved.
//

#import "LockScreenButton.h"
#import "CircleLayer.h"
#import "LockScreenHeader.h"

@interface LockScreenButton() {
    
}

@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UIButton *lockBtn;

@end

@implementation LockScreenButton

#pragma mark - 懒加载

- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [[UIView alloc] initWithFrame:self.bounds];
        _pointView.backgroundColor = [UIColor whiteColor];
        _pointView.userInteractionEnabled = NO;
        _pointView.layer.cornerRadius = self.frame.size.width/2;
        _pointView.layer.masksToBounds = YES;
        _pointView.layer.shouldRasterize = YES;
        _pointView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _pointView.hidden = YES;
    }
    return _pointView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lockBtn.frame = self.bounds;
        [_lockBtn addTarget:self action:@selector(OnButtonDown) forControlEvents:UIControlEventTouchDown];
        [_lockBtn addTarget:self action:@selector(OnButtonUp) forControlEvents:UIControlEventTouchUpInside];
        [_lockBtn addTarget:self action:@selector(OnButtonUpOut) forControlEvents:UIControlEventTouchUpOutside];
        [_lockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _lockBtn;
}

#pragma mark - LifeCycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tintColor = kTintColor;
        [self addSubview:self.lockBtn];
        [self addSubview:self.pointView];
        [LockScreenButton CreateCircleLayer:self :_tintColor];
    }
    return self;
}

#pragma mark - Properties

//按钮文字
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.lockBtn setTitle:_title forState:UIControlStateNormal];
}

//字体大小
- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.lockBtn.titleLabel.font = [UIFont boldSystemFontOfSize:_fontSize];
}

//是否选中
- (BOOL)isSelected {
    return !self.pointView.hidden;
}

- (void)setIsSelected:(BOOL)isSelected {
    [self setIsSelected:isSelected animated:NO];
}

- (void)setIsSelected:(BOOL)isSelected animated:(BOOL)animated {
    if (isSelected) {
        self.pointView.hidden = NO;
        self.pointView.alpha = 0.8;
    }
    else {
        if (animated) {
            WS(weakSelf);
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.pointView.alpha = 0.0;
            } completion:^(BOOL finish) {
                weakSelf.pointView.hidden = YES;
            }];
        }
        else {
            self.pointView.hidden = YES;
            self.pointView.alpha = 0.0;
        }
    }
}

//圆圈颜色
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CircleLayer class]]) {
            CircleLayer *circlelayer = (CircleLayer *)layer;
            circlelayer.color = _tintColor;
            [circlelayer setNeedsDisplay];
        }
    }
}

//字体颜色
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self.lockBtn setTitleColor:_textColor forState:UIControlStateNormal];
}

//选中颜色
- (void)setSelectColor:(UIColor *)selectColor {
    self.pointView.backgroundColor = selectColor;
}

- (UIColor *)selectColor {
    return self.pointView.backgroundColor;
}

#pragma mark - Action

- (void)OnButtonDown {
    self.isSelected = YES;
}

- (void)OnButtonUp {
    [self OnButtonUpOut];
    if (_OnButtonSelect) {
        _OnButtonSelect(_title);
    }
}

- (void)OnButtonUpOut {
    [self setIsSelected:NO animated:YES];
}

#pragma mark - Create View

+ (void)CreateCircleLayer:(UIView *)rootView :(UIColor *)color {
    CircleLayer *sublayer = [CircleLayer layer];
    sublayer.frame = rootView.bounds;
    sublayer.contentsScale = 4.0;
    sublayer.outerRadius = rootView.frame.size.width/2;
    sublayer.innerRadius = sublayer.outerRadius-1.0;
    sublayer.color = color;
    [rootView.layer addSublayer:sublayer];
    [sublayer setNeedsDisplay];
}

@end
