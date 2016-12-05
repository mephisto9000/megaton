//
//  CategoryDataLoader.h
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryListener.h"


//загрузка данных по категориям из интернета
@interface CategoryDataLoader : NSObject

//сюда сохраняется распарсенный json
@property(nonatomic, retain) NSMutableDictionary *catData;

//это ссылка на контроллер
@property(nonatomic, retain) NSObject<CategoryListener> *delegate;

-(void) loadCategoryData;

@end
