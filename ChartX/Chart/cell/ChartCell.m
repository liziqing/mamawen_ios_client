//
//  ChartCell.m
//  mammawenUser
//
//  Created by alex on 15/4/13.
//  Copyright (c) 2015年 alex. All rights reserved.
//

#import "ChartCell.h"
#import "Content.h"


@implementation ChartCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(ChartCell *)ChartCell{
    
    ChartCell *chartcell=[[ChartCell alloc]init];
    
    
    
    return chartcell;
}




@end
