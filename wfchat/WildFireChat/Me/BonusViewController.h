//
//  BonusViewController.h
//  WildFireChat
//
//  Created by xxx on 2018/12/12.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KJiFen,
    KTiXian,
} BonusType;

NS_ASSUME_NONNULL_BEGIN

@interface BonusViewController : UIViewController
@property (nonatomic, assign) BonusType type;

@end

NS_ASSUME_NONNULL_END
