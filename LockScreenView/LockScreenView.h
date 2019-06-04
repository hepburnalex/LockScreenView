//
//  LockScreenView.h
//  LockScreenView
//
//  Created by Hepburn on 15/1/28.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockScreenView : UIView

- (void)ResetPass;

+ (void)BringToFront:(UIWindow *)window;
+ (void)ShowInWindow:(UIWindow *)window :(BOOL)bResetPass;

#define kMsg_LockScreenHidden @"kMsg_LockScreenHidden"

@end
