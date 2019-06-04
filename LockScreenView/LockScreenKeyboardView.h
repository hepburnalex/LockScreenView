//
//  LockScreenKeyboardView.h
//  ImageShow
//
//  Created by Hepburn on 2019/6/3.
//  Copyright © 2019 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockScreenKeyboardView : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *selectColor;

@property (nonatomic, strong) void(^OnButtonSelect)(NSString *inputtext);

@end

NS_ASSUME_NONNULL_END
