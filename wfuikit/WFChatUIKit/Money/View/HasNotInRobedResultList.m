//
//  HasNotInRobedResultList.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/23.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "HasNotInRobedResultList.h"

@implementation HasNotInRobedResultList

+ (instancetype)createViewFromNibName:(NSString *)nibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    return [nib objectAtIndex:0];
}

+ (instancetype)createViewFromNib
{
    return [self createViewFromNibName:@"LuckyMoneyDrtailHeader"];
}

@end
