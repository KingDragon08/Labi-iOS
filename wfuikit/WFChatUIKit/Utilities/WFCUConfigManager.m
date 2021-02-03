//
//  WFCUConfigManager.m
//  WFChatUIKit
//
//  Created by heavyrain lee on 2019/9/22.
//  Copyright © 2019 WF Chat. All rights reserved.
//

#import "WFCUConfigManager.h"

static WFCUConfigManager *sharedSingleton = nil;
@implementation WFCUConfigManager

+ (WFCUConfigManager *)globalManager {
    if (sharedSingleton == nil) {
        @synchronized (self) {
            if (sharedSingleton == nil) {
                sharedSingleton = [[WFCUConfigManager alloc] init];
            }
        }
    }
    return sharedSingleton;
}
- (UIColor *)backgroudColor {
//    if (_backgroudColor) {
//        return _backgroudColor;
//    }
    return [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:1.0f];
//    BOOL darkModel = NO;
//    if (@available(iOS 13.0, *)) {
//        if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//            darkModel = YES;
//        }
//    }
//
//    if (darkModel) {
//        return [UIColor colorWithRed:33/255.f green:33/255.f blue:33/255.f alpha:1.0f];
//    } else {
//        return [UIColor colorWithRed:243/255.f green:243/255.f blue:243/255.f alpha:1.0f];
//    }
}

- (UIColor *)frameBackgroudColor {
    if (_frameBackgroudColor) {
        return _frameBackgroudColor;
    }
    BOOL darkModel = NO;
//    if (@available(iOS 13.0, *)) {
//        if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//            darkModel = YES;
//        }
//    }
    
    if (darkModel) {
        return [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1.0f];
    } else {
        return [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1.0f];
    }
}

- (UIColor *)topColor {
    if (!_topColor) {
        _topColor = [UIColor colorWithRed:243/255.f green:245/255.f blue:246/255.f alpha:1.0f];
    }
    return _topColor;
}

- (UIColor *)textColor {
    
        return [UIColor whiteColor];
    
}

- (UIColor *)naviBackgroudColor {
    if (_naviBackgroudColor) {
        return _naviBackgroudColor;
    }
//    BOOL darkModel = NO;
//    if (@available(iOS 13.0, *)) {
//        if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//            darkModel = YES;
//        }
//    }
//
//    if (darkModel) {
        return [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:1.0f];
//    } else {
//    }
}

- (UIColor *)naviTextColor {
//    if (_naviTextColor) {
//        return _naviTextColor;
//    }
//    BOOL darkModel = NO;
//    if (@available(iOS 13.0, *)) {
//        if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//            darkModel = YES;
//        }
//    }
//
//    if (darkModel) {
        return [UIColor whiteColor];
//    } else {
//    }
}
@end
