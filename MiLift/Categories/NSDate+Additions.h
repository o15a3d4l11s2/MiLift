//
//  NSDate+Additions.h
//  MiLift
//
//  Created by Dimitar Topalov on 2/22/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (instancetype)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (instancetype)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

@end
