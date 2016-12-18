//
//  CategoryListener.h
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>


//интерфейс для загрузки категорий, его должен реализовывать контроллер CategoryVC

@protocol CategoryListener <NSObject>

-(void) categoryLoadComplete;
-(void) categoryLoadError;

@end
