

#import <Foundation/Foundation.h>

@interface NSDate (Convenience)

-(NSDate *)offsetMonth:(int)numMonths;
-(NSDate *)offsetDay:(int)numDays;
-(NSDate *)offsetHours:(int)hours;
-(NSInteger)numDaysInMonth;
-(NSInteger)firstWeekDayInMonth;
-(NSInteger)year;
-(NSInteger)month;
-(NSInteger)day;

+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;

+ (NSString *)dateIntegerForDate:(NSDate *)date;

+ (NSString *)dateWithFormatter:(int)timeValue AndDateFormate:(NSString *)dateFormatter;
+ (NSString *)dateInteger:(NSString *)hour AndMinute:(NSString *)minute Istoday:(BOOL)istoday;

+(NSString*)TimeformatFromSeconds:(NSInteger)seconds;//秒转换成时间格式
+(NSString*)TimeformatFromDateWithDay:(NSInteger)day AndMinutes:(NSInteger)minutes AndSecond:(NSInteger)second;//传入天数 和 时间 转换成时间戳



@end
