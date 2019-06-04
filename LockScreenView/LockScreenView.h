//
//  LockScreenView.h
//  LockScreenView
//
//  Created by Hepburn on 15/1/28.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockScreenView : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *alertColor;
@property (nonatomic, strong) UIColor *selectColor;

- (void)ResetPass;

+ (LockScreenView *)ShowInWindow:(UIWindow *)window :(BOOL)bResetPass;

#define kMsg_LockScreenHidden @"kMsg_LockScreenHidden"

@end
