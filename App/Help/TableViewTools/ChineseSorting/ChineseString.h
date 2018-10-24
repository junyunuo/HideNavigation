//
//  ChineseString.h
//  YUChineseSorting
//
//  Created by yuzhx on 15/4/19.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//
#import "pinyin.h"

@interface ChineseString : NSObject
@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;

// ----- 返回tableview右方 indexArray 其中#在最下方
+(NSMutableArray*)IndexArrayForSpecialCharactorInLast:(NSArray*)stringArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;

//-----  返回联系人 #在最下方
+ (NSMutableArray*)LetterSortArrayForSpecialCharactorInLast:(NSArray*)stringArr;

///----------------------
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)stringArr;

@end