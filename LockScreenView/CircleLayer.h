//
//  CircleLayer.h
//  LockScreenView
//
//  Created by Hepburn on 2019/5/28.
//  Copyright © 2019 Hepburn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CircleLayer : CALayer {
}

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) CGFloat outerRadius;

@end
