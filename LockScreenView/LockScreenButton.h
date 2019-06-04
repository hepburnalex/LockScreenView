//
//  LockScreenButton.h
//  ImageShow
//
//  Created by Hepburn on 2019/5/28.
//  Copyright © 2019 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockScreenButton : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) void(^OnButtonSelect)(NSString *inputtext);

+ (void)CreateCircleLayer:(UIView *)rootView :(UIColor *)color;
- (void)setIsSelected:(BOOL)isSelected animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
