//
//  CircleLayer.h
//  AppearanceTest
//
//  Created by Kevin Donnelly on 1/10/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CircleLayer : CALayer {
}

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) CGFloat outerRadius;

@end
