//
//  CardModel.h
//  WildFireChat
//
//  Created by xxx on 2018/12/12.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardModel : NSObject
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (BOOL)isEmptys;
@end

NS_ASSUME_NONNULL_END
