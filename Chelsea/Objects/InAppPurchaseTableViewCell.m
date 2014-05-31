//
//  InAppPurchaseTableViewCell.m
//  Chelsea
//
//  Created by pandaman on 5/31/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "InAppPurchaseTableViewCell.h"

@implementation InAppPurchaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 37, 260, 20)];
        [self addSubview:_subtitleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 23 , 40, 20)];
        [self addSubview:_priceLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
