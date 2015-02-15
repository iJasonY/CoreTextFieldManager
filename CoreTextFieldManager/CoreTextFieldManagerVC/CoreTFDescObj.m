//
//  CoreTFDescObj.m
//  CoreTextFieldManager
//
//  Created by muxi on 15/2/15.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreTFDescObj.h"

@implementation CoreTFDescObj


+(instancetype)tfDescObj:(UITextField *)tf bottomInset:(CGFloat)bottomInset{
    
    CoreTFDescObj *tfObj=[[CoreTFDescObj alloc] init];
    
    tfObj.tf=tf;
    
    tfObj.bottomInset=bottomInset;
    
    return tfObj;
}



/**
 *  找到标准CoreTFDescObj对象
 */
+(CoreTFDescObj *)findDescObjWith:(UITextField *)tf fromArray:(NSArray *)array{
    
    for (CoreTFDescObj *tfDescObj in array) {
        if(tfDescObj.tf == tf) return tfDescObj;
    }
    
    return nil;
}


@end
