//
//  TapGestureRecognizer.m
//  qzalog
//
//  Created by Marat Mustakayev on 1/9/17.
//  Copyright © 2017 Mus Bai. All rights reserved.
//

#import "TapGestureRecognizer.h"



@implementation TapGestureRecognizer
-(id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        // so simple there's no setup
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateRecognized;
      
    CGFloat xScale = self.view.transform.a;
    if(xScale < 1){
        [UIView animateWithDuration:0.5
         animations:^{
             self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
              self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height );
         }
         completion:nil];
        
    }else{
        NSLog(@"TouchesEnded %f", self.view.frame.origin.x);
        
        if(self.view.frame.origin.x >= 0){
            [UIView animateWithDuration:1.0
                             animations: ^{
                                 self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height );
                             } completion:nil];
        }else{
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            
            CGFloat visibleWidth = self.view.frame.size.width + self.view.frame.origin.x;
            if(visibleWidth < screenWidth){
                [UIView animateWithDuration:1.0
                     animations: ^{
                         self.view.frame = CGRectMake(self.view.frame.origin.x + (screenWidth - visibleWidth), self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height );
                     } completion:nil];
            }
            
        }
        
    }
    
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateCancelled;
}
-(void)reset{
    // so simple there's no reset
}

@end
