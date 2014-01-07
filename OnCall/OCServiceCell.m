//
//  OCServiceCell.m
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCServiceCell.h"

@implementation OCServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTitle:(NSString *) title
{
    [lblTitle setText:title];
}

- (void) setHealth:(NSString *) health
{
    [imgHealth setHidden:false];
    
    if ([health isEqualToString:@"OK"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"sun-100.png"]];
    }
    else if ([health isEqualToString:@"MAINTENANCE"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"hammer-100.png"]];
    }
    else if ([health isEqualToString:@"OFF"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"stop-100.png"]];
    }
    else if ([health isEqualToString:@"WARNING"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"cloudy-100.png"]];
    }
    else if ([health isEqualToString:@"ERROR"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"storm-100.png"]];
    }
    else
    {
        [imgHealth setHidden:true];
    }
}

@end
