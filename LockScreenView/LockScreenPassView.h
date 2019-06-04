//
//  LockScreenPassView.h
//  ImageShow
//
//  Created by Hepburn on 2019/6/4.
//  Copyright © 2019 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LockScreenState_Input,
    LockScreenState_OldPass,
    LockScreenState_NewPass,
    LockScreenState_DiffPass,
    LockScreenState_WrongPass,
    LockScreenState_Confirm,
    LockScreenState_Repeat,
    LockScreenState_OK
} LockScreenState;

NS_ASSUME_NONNULL_BEGIN

@interface LockScreenPassView : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *alertColor;
@property (nonatomic, strong) UIColor *selectColor;

@property (nonatomic, assign) LockScreenState state;
@property (nonatomic, assign) NSInteger passCount;
@property (nonatomic, strong) NSString *inputPass;
@property (nonatomic, readonly) BOOL isPassEmpty;
@property (nonatomic, readonly) BOOL isPassFull;

- (BOOL)AppendPassText:(NSString *)passText;
- (void)DeletePassText;
- (void)CleanPassText;

@end

NS_ASSUME_NONNULL_END
