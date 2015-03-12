//
//  NSDate+Additions.m
//  MiLift
//
//  Created by Dimitar Topalov on 2/22/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (instancetype)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    return [self dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (instancetype)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    components.month = month;
    components.year = year;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}



@end
