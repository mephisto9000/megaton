//
//  RegionCell.h
//  qzalog
//
//  Created by Mus Bai on 06.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UIView *regionCellView;

-(void) updateRegionName: (NSString *) newName;

@end
