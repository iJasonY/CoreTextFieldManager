//
//  CoreTFDescObj.h
//  CoreTextFieldManager
//
//  Created by muxi on 15/2/15.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreTFDescObj : NSObject

@property (nonatomic,strong) UITextField *tf;                                           //文本框

@property (nonatomic,assign) CGRect unifyFrame;                                         //统一的frame

@property (nonatomic,assign) CGFloat bottomInset;                                       //底部需要增加的距离

+(instancetype)tfDescObj:(UITextField *)tf bottomInset:(CGFloat)bottomInset;


/**
 *  找到标准CoreTFDescObj对象
 */
+(CoreTFDescObj *)findDescObjWith:(UITextField *)tf fromArray:(NSArray *)array;


@end
