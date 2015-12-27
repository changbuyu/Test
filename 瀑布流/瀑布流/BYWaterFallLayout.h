//
//  BYWaterFallLayout.h
//  瀑布流
//
//  Created by 常布雨 on 15/12/26.
//  Copyright © 2015年 CBY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYWaterFallLayout;
@protocol BYWaterFallLayoutDelegate <NSObject>

- (CGSize)waterFallLayout: (BYWaterFallLayout *)layout withItemWidth: (CGFloat)width andIndexPath: (NSIndexPath *)indexPath;

@end

@interface BYWaterFallLayout : UICollectionViewLayout
@property (nonatomic, assign) CGFloat columns;
@property (nonatomic, assign) CGFloat marginX;
@property (nonatomic, assign) CGFloat marginY;
@property (nonatomic, assign) UIEdgeInsets inset;
@property (nonatomic, weak) id<BYWaterFallLayoutDelegate> delegate;
@end
