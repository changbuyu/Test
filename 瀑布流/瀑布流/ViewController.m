//
//  ViewController.m
//  瀑布流
//
//  Created by 常布雨 on 15/12/26.
//  Copyright © 2015年 CBY. All rights reserved.
//

#import "ViewController.h"
#import "BYCollectionCell.h"
#import "BYWaterFallLayout.h"
#import "MJRefresh.h"
#define BYRANDOMCOLOR [UIColor colorWithRed:arc4random_uniform(254)/255.0 green:arc4random_uniform(254)/255.0 blue:arc4random_uniform(254)/255.0 alpha:1]


@interface ViewController () <BYWaterFallLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, weak) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *aspectRatio;
@end

static NSString *const ID = @"item";

@implementation ViewController

-(NSMutableArray *)colors{
    if (!_colors) {
        _colors = [NSMutableArray array];
        for (int i = 0; i < 50; i++) {
            UIColor *color = BYRANDOMCOLOR;
            [_colors addObject:color];
        }
    }
    return _colors;
}
/**
 *  随机宽高比
 */
- (NSMutableArray *)aspectRatio{
    if (!_aspectRatio) {
        _aspectRatio = [NSMutableArray array];
        for (int i = 0; i < 50; i++) {
            CGFloat ratio = (1.0 + arc4random_uniform(254)/255.0);
            [_aspectRatio addObject:@(ratio)];
        }
    }
    return _aspectRatio;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BYWaterFallLayout *layout = [[BYWaterFallLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BYCollectionCell" bundle:nil] forCellWithReuseIdentifier: ID];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.colors.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BYCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.color = self.colors[indexPath.item];
    cell.number = [NSString stringWithFormat:@"%ld", indexPath.item];
    return cell;
}
/**
 *  实现代理方法 返回itemSize;
 *  @param width     传过来的宽度
 *  @param indexPath item所在位置
 */
-(CGSize)waterFallLayout:(BYWaterFallLayout *)layout withItemWidth:(CGFloat)width andIndexPath: (NSIndexPath *)indexPath{
    CGFloat ratio = [self.aspectRatio[indexPath.item] floatValue];
    return CGSizeMake(width, width * ratio);
}
/**
 *  下拉加载更多
 */
- (void)loadMore{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 50; i++) {
            UIColor *color = BYRANDOMCOLOR;
            [self.colors addObject:color];
        }
        
        for (int i = 0; i < 50; i++) {
            CGFloat ratio = (1.0 + arc4random_uniform(254)/255.0);
            [self.aspectRatio addObject:@(ratio)];
        }
        
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}
/**
 *  点击删除
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.colors removeObjectAtIndex:indexPath.item];
    [self.aspectRatio removeObjectAtIndex:indexPath.item];
    [self.collectionView reloadData];
}
@end
