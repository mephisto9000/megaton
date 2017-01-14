//
//  TapGestureRecognizer.m
//  qzalog
//
//  Created by Marat Mustakayev on 1/9/17.
//  Copyright © 2017 Mus Bai. All rights reserved.
//

#import "CustomPinchGestureRecognizer.h"
#import "PhotoCollectionViewCell.h"


@implementation CustomPinchGestureRecognizer
-(id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        // so simple there's no setup
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateRecognized;
    
    NSLog(@"Tapped pinch Ended");
    
    
    UICollectionView *view = (UICollectionView *)self.view;
    PhotoCollectionViewCell *currentCell;
    for (PhotoCollectionViewCell *cell in [view visibleCells]) {
        currentCell = cell;
    }
    CGFloat xScale = currentCell.scrollview.transform.a;
    if(xScale < 1){
        [UIView animateWithDuration:0.5
                         animations:^{
                             currentCell.scrollview.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             currentCell.scrollview.frame = CGRectMake(0, 0, currentCell.frame.size.width, currentCell.frame.size.height );
                         }
                         completion:nil];
        
    }
    
    
    
}


@end
