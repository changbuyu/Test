//
//  BYWaterFallLayout.m
//  瀑布流
//
//  Created by 常布雨 on 15/12/26.
//  Copyright © 2015年 CBY. All rights reserved.
//

#import "BYWaterFallLayout.h"
#import "UIView+Extension.h"
@interface BYWaterFallLayout()
@property (nonatomic, strong) NSMutableArray *currentYs;
@property (nonatomic, strong) NSMutableArray *attributes;
//@property (nonatomic, assign) CGSize size;
@end

@implementation BYWaterFallLayout
/**
 *  懒加载数组,用于存放当前的Y值
 */
- (NSMutableArray *)currentYs{
    if (!_currentYs) {
        _currentYs = [NSMutableArray array];
        for (int i = 0; i < self.columns; i++) {
            _currentYs[i] = @(0.0);
        }
    }
    return _currentYs;
}

- (NSArray *)attributes{
    if (!_attributes) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
/**
 * 只需设置一次的属性
 */

- (instancetype)init{
    if (self = [super init]) {
        self.columns = 3;
        self.marginX = 10;
        self.marginY = 10;
        self.inset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView.contentInset = self.inset;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    for (int i = 0; i < self.columns; i++) {
        self.currentYs[i] = @(0.0);
    }
    /**
     *  计算所有item尺寸
     */
    [self.attributes removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributes addObject:attribute];
    }
}
/**
 *  计算contentsize
 */
- (CGSize)collectionViewContentSize{

    CGFloat maxY = 0;
    for (NSNumber *currentY in self.currentYs) {
        if ([currentY floatValue] > maxY) {
            maxY = currentY.floatValue;
        }
    }
    return CGSizeMake(0, maxY + self.inset.bottom);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributes;
}

/**
 *  计算每个item属性
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemW = (self.collectionView.width - self.inset.right - self.inset.left - self.marginX * (self.columns - 1)) / self.columns;
    
    attribute.size = [self.delegate waterFallLayout:self withItemWidth:itemW andIndexPath: indexPath];
    CGRect frame = attribute.frame;
    
    CGFloat minY = MAXFLOAT;
    /**
     *  标记当前列
     */
    NSInteger index = 0;

    for (int i = 0; i < 3; i++) {
        NSNumber *currentY = self.currentYs[i];
        if ([currentY floatValue] < minY) {
            minY = [currentY floatValue];
            index = i;
        }
    }
    
    if (minY == 0.0) {
        frame.origin.y = self.inset.top;
    }else{
        frame.origin.y = minY + self.marginY;
    }
     frame.origin.x = self.inset.left + (attribute.size.width + self.marginX)  * index;
    
    attribute.frame = frame;
    
    [self.currentYs replaceObjectAtIndex:index withObject:@(frame.origin.y + attribute.size.height)];
   
    return attribute;
    
}


@end



//@property (nonatomic) CGRect frame;
//@property (nonatomic) CGPoint center;
//@property (nonatomic) CGSize size;
//@property (nonatomic) CATransform3D transform3D;
//@property (nonatomic) CGRect bounds NS_AVAILABLE_IOS(7_0);
//@property (nonatomic) CGAffineTransform transform NS_AVAILABLE_IOS(7_0);
//@property (nonatomic) CGFloat alpha;
//@property (nonatomic) NSInteger zIndex; // default is 0
//@property (nonatomic, getter=isHidden) BOOL hidden; // As an optimization, UICollectionView might not create a view for items whose hidden attribute is YES
//@property (nonatomic, strong) NSIndexPath *indexPath;