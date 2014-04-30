//
//  ChatTableViewCell.m
//  Chelsea
//
//  Created by pandaman on 4/29/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _chatIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 20)];
        _chatIdLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _chatIdLabel.text = @"";
        [self addSubview:_chatIdLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,_chatIdLabel.frame.origin.y+_chatIdLabel.frame.size.height, 300, 20)];
        _messageLabel.text = @"";
        _messageLabel.font = [UIFont systemFontOfSize:14.0f];
        _messageLabel.numberOfLines = 0;
        [self addSubview:_messageLabel];
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
