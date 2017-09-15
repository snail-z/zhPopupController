//
//  NSDate+Extend.h
//  categoryKitDemo
//
//  Created by zhanghao on 2016/7/23.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extend)

// 获取当前的时间☟
@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;
@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger minute;
@property (nonatomic, assign, readonly) NSInteger second;
@property (nonatomic, assign, readonly) NSInteger weekday;

/**
 获取星期几(名称)
 
 @return Return weekday as a localized string
 [1 - Sunday]
 [2 - Monday]
 [3 - Tuerday]
 [4 - Wednesday]
 [5 - Thursday]
 [6 - Friday]
 [7 - Saturday]
 */
- (NSString *)dayFromWeekday; // 星期几的形式
- (NSString *)dayFromWeekday2; // 周几的形式
- (NSString *)dayFromWeekday3; // 英文的形式
+ (NSString *)dayFromWeekday:(NSDate *)date; // 星期几的形式
+ (NSString *)dayFromWeekday2:(NSDate *)date; // 周几的形式
+ (NSString *)dayFromWeekday3:(NSDate *)date; // 英文的形式

+ (NSString *)ymdFormatJoinedByString:(NSString *)string;
+ (NSString *)ymdHmsFormat;
+ (NSString *)ymdFormat;
+ (NSString *)hmsFormat;
+ (NSString *)dmyFormat; // day month years format
+ (NSString *)myFormat; // month years format

/// 获取当前时间戳字符串
+ (NSString *)currentTimeString;

/// 当前date转换成时间字符串 (+方法)
+ (NSString *)stringWithFormat:(NSString *)format;

/// 将date转换成时间字符串 (NSDate => TimeString)
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;

/** 
 将时间字符串转换成date (TimeString ==> NSDate)
 Example:
 NSString *string = @"2017-09-15";
 NSDate *date = [NSDate dateWithString:string format:@"yyyy-MM-dd"];
 */
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/// 将date转换成时间戳 (NSDate => Timestamp)
+ (NSInteger)timestampFromDate:(NSDate *)date;

/// 将时间戳转换成date (Timestamp => NSDate)
+ (NSDate *)dateFromTimestamp:(NSInteger)timestamp;

/** 
 将时间字符串转换成时间戳 (TimeString => Timestamp) / 北京时间
 Example:
 NSString *timeString = @"2017-09-15 15:39";
 NSInteger timestamp = [NSDate timestampFromTimeString:timeString formatter:@"yyyy-MM-dd HH:mm"];
 */
+ (NSInteger)timestampFromTimeString:(NSString *)timeString formatter:(NSString *)format;

/// 将时间戳转换成时间字符串 (Timestamp => TimeString) / 北京时间
+ (NSString *)timeStringFromTimestamp:(NSInteger)timestamp formatter:(NSString *)format;

/// 获取当前系统时间的时间戳 / 北京时间
+ (NSInteger)getNowTimestampWithFormatter:(NSString *)format;

/// 获取某个月的天数
+ (NSInteger)getSumOfDaysMonth:(NSInteger)month inYear:(NSInteger)year;

/// 获取当前的"年月日时分"
+ (NSArray<NSString *> *)getCurrentTimeComponents;

/** 比较两个date的大小关系 return NSComparisonResult
 NSOrderedAscending     => (dateString1 < dateString2)
 NSOrderedDescending    => (dateString1 > dateString2)
 NSOrderedSame          => (dateString1 = dateString2)
 */
- (NSComparisonResult)compareDateString1:(NSString *)dateString1
                             dateString2:(NSString *)dateString2
                               formatter:(NSString *)format;

/// 是否小于当前时间(过去时间)
- (BOOL)isInPast;
/// 是否大于当前时间(未来时间)
- (BOOL)isInFuture;

/// 是否是今天
- (BOOL)isToday;

/**
 获取未来的日期时间
 
 如：获取2天后的时间 [date backward:2 unitType:NSCalendarUnitDay];
 */
+ (NSDate *)backward:(NSInteger)backwardN unitType:(NSCalendarUnit)unit;

/**
 获取之前的日期时间
 
 如：获取2天前的时间 [date forward:2 unitType:NSCalendarUnitDay];
 */
+ (NSDate *)forward:(NSInteger)forwardN unitType:(NSCalendarUnit)unit;

@end
