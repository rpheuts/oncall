//
//  OCServiceCell.h
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCServiceCell : UITableViewCell
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imgHealth;
}

- (void) setTitle:(NSString *) title;
- (void) setHealth:(NSString *) health;

@end
