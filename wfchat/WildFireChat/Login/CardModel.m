//
//  CardModel.m
//  WildFireChat
//
//  Created by xxx on 2018/12/12.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "CardModel.h"

@implementation CardModel
- (BOOL)isEmptys {
    return !(self.name.length > 0 && self.bank.length > 0 && self.number.length > 0);
}
@end
