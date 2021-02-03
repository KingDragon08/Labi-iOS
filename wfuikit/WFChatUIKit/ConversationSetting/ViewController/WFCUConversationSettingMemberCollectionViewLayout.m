//
//  ConversationSettingMemberCollectionViewLayout.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/11/3.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCUConversationSettingMemberCollectionViewLayout.h"


@interface WFCUConversationSettingMemberCollectionViewLayout()
@property(nonatomic, strong) NSMutableArray *attributesArray;
@property(nonatomic, assign) CGFloat itemAreaWidth;
@property(nonatomic, assign) CGFloat itemWidth;
@property(nonatomic, assign) CGFloat itemHeight;
@property(nonatomic, assign) CGFloat itemMargin;

@property(nonatomic, assign) int itemsPerLine;
@end

@implementation WFCUConversationSettingMemberCollectionViewLayout

- (instancetype)initWithItemMargin:(CGFloat)itemMargin {
    self = [super init];
    if (self) {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.itemMargin = ([UIScreen mainScreen].bounds.size.width - 5*50)/6;
        self.itemsPerLine = 5;
    }
    return self;
}

- (CGFloat)itemAreaWidth {
    if (!_itemAreaWidth) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _itemAreaWidth = 50;
    }
    return _itemAreaWidth;
}
- (CGFloat)itemWidth {
    if (!_itemWidth) {
        _itemWidth = 50;
    }
    return _itemWidth;
}

- (CGFloat)itemHeight {
    if (!_itemHeight) {
        _itemHeight = self.itemWidth + 20;
    }
    return _itemHeight;
}

- (void)prepareLayout {
    int itemCount = (int)[self.collectionView numberOfItemsInSection:0];
    if (itemCount == 0) {
        [super prepareLayout];
        return;
    }
    
    self.attributesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < itemCount; i++) {
        int row = i / self.itemsPerLine;
        int column = i % self.itemsPerLine;
        
        UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes
         layoutAttributesForCellWithIndexPath:[NSIndexPath
                                               indexPathForItem:i
                                               inSection:0]];

        attributes.frame = CGRectMake(column * self.itemAreaWidth + self.itemMargin * (column + 1),
                                      row * self.itemHeight + self.itemMargin * (row + 1),
                                      self.itemWidth,
                                      self.itemHeight);
        
        [self.attributesArray addObject:attributes];
    }
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [super prepareLayout];
}
- (CGFloat)getHeigthOfItemCount:(int)itemCount {
    if (itemCount == 0) {
        return 0;
    } else {
        int lines = (itemCount - 1) / 5 + 1;
        CGFloat height = (self.itemHeight + self.itemMargin) * lines + self.itemMargin;
        return height;
    }
}
- (CGSize)collectionViewContentSize {
    return CGSizeMake([self collectionView].frame.size.width, [self getHeigthOfItemCount:(int)[self.collectionView numberOfItemsInSection:0]]);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:
(NSIndexPath *)path {
    UICollectionViewLayoutAttributes *attributes =
    [self.attributesArray objectAtIndex:[path row]];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0];
         i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}
@end
