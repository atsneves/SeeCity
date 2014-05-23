//
//  SCDelegaciaTableViewCell.m
//  SeeCity
//
//  Created by Anderson Neves on 23/05/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCDelegaciaTableViewCell.h"

@implementation SCDelegaciaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
