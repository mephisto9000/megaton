//
//  RegionCell.m
//  qzalog
//
//  Created by Mus Bai on 06.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "RegionCell.h"

@implementation RegionCell

@synthesize regionLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateRegionName: (NSString *) newName
{
    self.regionLabel.text = newName;
}


@end
