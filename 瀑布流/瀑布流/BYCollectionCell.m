//
//  BYCollectionCell.m
//  瀑布流
//
//  Created by 常布雨 on 15/12/26.
//  Copyright © 2015年 CBY. All rights reserved.
//

#import "BYCollectionCell.h"
@interface BYCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
@implementation BYCollectionCell

- (void)setColor:(UIColor *)color{
    _color = color;
    self.view.backgroundColor = color;
}

-(void)setNumber:(NSString *)number{
    _number = number;
    self.numberLabel.text = number;
}
@end
