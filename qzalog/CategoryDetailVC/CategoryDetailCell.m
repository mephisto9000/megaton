//
//  CategoryDetailCell.m
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "CategoryDetailCell.h"

@implementation CategoryDetailCell
{
    int starMode;
}

@synthesize adImage;
@synthesize adTextLabel;
@synthesize addrLabel;
@synthesize infoLabel;

@synthesize starButton;
@synthesize objectId;
@synthesize priceLabel;
@synthesize dbManager = _dbManager;


-(void) setDbManager:(DBManager *)dbManager
{
    _dbManager = dbManager;
    
    
    NSLog(@"creating cell categoryDetailCell");
    
    //NSString *query =
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
    NSString *query = [NSString stringWithFormat: @"select * from liked where object_id = %@", self.objectId];
    
    NSLog(query);
    
    NSArray *likedInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    
    
    
    if (likedInfo!=nil && [likedInfo count] > 0)
    {
        [self starButtonClicked:nil];
    }

  }

-(IBAction) starButtonClicked:(id) sender
{
    NSLog(@"star button clicked");
    
    NSLog(@"object id == %@", self.objectId);
    
    NSString *query;
    if (starMode == 1)
    {
        starMode = 2;
        [starButton setBackgroundImage:  [UIImage imageNamed:@"star_circle.png"] forState:UIControlStateNormal];
        
        query = [NSString stringWithFormat:@"insert into liked (object_id) values( %@ )", self.objectId ];
    }
    else
    {
        starMode = 1;
        [starButton setBackgroundImage: [UIImage imageNamed:@"star_circle_empty.png"] forState:UIControlStateNormal];
        
        
        query = [NSString stringWithFormat:@"delete from liked where object_id =  %@ ", self.objectId ];
    }
    
    NSLog (query);
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
    [_dbManager executeQuery:query];
    
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //starMode = 1;
    
    starMode = 1;
    
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
