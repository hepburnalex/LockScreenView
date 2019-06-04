//
//  LockScreenHeader.h
//  LockScreenView
//
//  Created by Hepburn on 2019/6/3.
//  Copyright © 2019 Hepburn. All rights reserved.
//

#ifndef LockScreenHeader_h
#define LockScreenHeader_h

#import <Masonry/Masonry.h>

#define kTintColor  [UIColor colorWithRed:0.8 green:0.92 blue:0.76 alpha:1.0]
#define kRedColor   [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0]

#ifndef IsiPadUI
#define IsiPadUI    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

#ifndef CGFAF
#define CGFAF(a) a*(MIN(MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)/320.0, 2.0))
#endif

#ifndef WS//(weakSelf)
#define WS(weakSelf)  __weak __typeof (&*self)weakSelf = self
#endif

#define LockScreenTag   30000

#endif /* LockScreenHeader_h */
