//
//  UserTableViewCell.m
//  Chelsea
//
//  Created by pandaman on 6/1/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _chatIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 60)];
        [self addSubview:_chatIdLabel];
        
        _aLLevel = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 50, 60)];
        [self addSubview:_aLLevel];
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
