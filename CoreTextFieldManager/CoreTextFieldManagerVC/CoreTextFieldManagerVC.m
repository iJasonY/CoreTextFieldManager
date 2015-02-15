//
//  CoreTextFieldManager.m
//  CoreTextFieldManager
//
//  Created by muxi on 15/2/15.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreTextFieldManagerVC.h"
#import "CoreTFDescObj.h"
#import "CoreTFKeyBoardToolBarView.h"

@interface CoreTextFieldManagerVC ()<UITextFieldDelegate>

/**
 *  键盘相关参数
 */

@property (nonatomic,assign) NSInteger keyBoardCurve;                                               //动画曲线

@property (nonatomic,assign) CGFloat keyBoardDuration;                                              //动画时长

@property (nonatomic,assign) CGFloat keyBoardHeight;                                                //键盘高度


@property (nonatomic,strong) CoreTFDescObj *currentTFObj;                                           //当前的输入框对象

@property (nonatomic,strong) CoreTFKeyBoardToolBarView *keyBoardToolBarView;                        //键盘工具条



@end



@implementation CoreTextFieldManagerVC



-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    //添加键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //添加键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc{
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



-(void)setDescObjs:(NSArray *)descObjs{
    
    __block NSArray *arr=descObjs;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //遍历所有文本框
        [arr enumerateObjectsUsingBlock:^(CoreTFDescObj *tfDescObj, NSUInteger idx, BOOL *stop) {
            
            //取出文本框
            UITextField *tf=tfDescObj.tf;
            
            //设置代理
            tf.delegate=self;
            
            //设置键盘工具条
            tf.inputAccessoryView=self.keyBoardToolBarView;
        }];
    });
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //遍历所有文本框
        [arr enumerateObjectsUsingBlock:^(CoreTFDescObj *tfDescObj, NSUInteger idx, BOOL *stop) {

            //取出文本框
            UITextField *tf=tfDescObj.tf;
            
            //设置键盘工具条
            tf.inputAccessoryView=self.keyBoardToolBarView;
            
            //tf控件直接存入
            CGRect unifyFrame = [self.view.window convertRect:tf.frame fromView:tf.superview];
            
            tfDescObj.unifyFrame=unifyFrame;
        }];
        
        //数组重新排序
        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(CoreTFDescObj *tfDescObj1,CoreTFDescObj *tfDescObj2) {
            
            if(tfDescObj1.unifyFrame.origin.y<tfDescObj2.unifyFrame.origin.y) return NSOrderedAscending;
            if(tfDescObj1.unifyFrame.origin.y>tfDescObj2.unifyFrame.origin.y) return NSOrderedDescending;
            return NSOrderedSame;
        }];
        //记录
        _descObjs=arr;
    });
}


#pragma mark - 键盘弹出通知
-(void)keyBoardWillShow:(NSNotification *)noti{
    
    //此方法调用时机：
    //1.弹出不同键盘
    //2.键盘初次中文输入
    //3.屏幕旋转
    
    //键盘即将弹出，更新以下值
    //如果是相同的键盘，此方法不会重复调用，我们应该在此处记录重要数据
    NSDictionary *userInfo=noti.userInfo;
    
    //记录动画曲线
    self.keyBoardCurve=[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    //时间时长
    self.keyBoardDuration=[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //键盘高度
    self.keyBoardHeight=[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self adjustFrame];
    NSLog(@"键盘弹出通知");
}

-(void)keyBoardWillHide:(NSNotification *)noti{
    //视图恢复原位
    [UIView animateWithDuration:_keyBoardDuration animations:^{
        //动画曲线
        [UIView setAnimationCurve:_keyBoardCurve];
        self.view.transform=CGAffineTransformIdentity;
    }];
}



#pragma mark  -代理方法区
#pragma mark  即将开始编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //记录
    self.currentTFObj=[CoreTFDescObj findDescObjWith:textField fromArray:self.descObjs];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self adjustFrame];
    });
    
    return YES;
}






#pragma mark - 调整当前视图的frame
-(void)adjustFrame{
    
    //控件获取最大的y值
    CGFloat tfMaxY=CGRectGetMaxY(_currentTFObj.unifyFrame);
    
    //计算得到最大的y值:主要是避开一些按钮
    CGFloat totalMaxY=tfMaxY + _currentTFObj.bottomInset;
    
    //计算键盘最小的Y值
    CGFloat keyBoardMinY=[UIScreen mainScreen].bounds.size.height - _keyBoardHeight;
    
    CGFloat deltaY= keyBoardMinY - totalMaxY;
    
    CGAffineTransform transform=deltaY>0?CGAffineTransformIdentity:CGAffineTransformMakeTranslation(0,deltaY);

    //视图上移
    [UIView animateWithDuration:_keyBoardDuration animations:^{
        //动画曲线
        [UIView setAnimationCurve:_keyBoardCurve];
        self.view.transform=transform;
    }];
    
    //更新键盘工具条的状态
    [self updateStatusForKeyboardTool];
}

-(CoreTFKeyBoardToolBarView *)keyBoardToolBarView{
    
    __weak typeof(self) weakSelf=self;
    
    if(!_keyBoardToolBarView){
        
        _keyBoardToolBarView=[CoreTFKeyBoardToolBarView keyBoardToolBarView];
        
        //上一个
        _keyBoardToolBarView.preClickBlock=^{
            
            [weakSelf toggleTFIsPre:YES];
        };
        
        //下一个
        _keyBoardToolBarView.nextClickBlock=^{
            
            [weakSelf toggleTFIsPre:NO];
        };
        
        //完成
        _keyBoardToolBarView.doneClickBlock=^{

            [weakSelf.currentTFObj.tf resignFirstResponder];
        };
        
    }
    
    return _keyBoardToolBarView;
}

-(void)toggleTFIsPre:(BOOL)isPre{
    
    //获取当前的index
    NSUInteger index=[self.descObjs indexOfObject:self.currentTFObj];
    if(index>self.descObjs.count || index<0) index=0;
    
    NSInteger i=isPre?-1:1;
    
    //下一个输入框获取焦点
    CoreTFDescObj *tfDescObj=self.descObjs[index + i];
    
    [tfDescObj.tf becomeFirstResponder];
    
    //更新键盘工具条的状态
    [self updateStatusForKeyboardTool];
}

#pragma mark  更新键盘工具条的状态
-(void)updateStatusForKeyboardTool{
    //获取当前的index
    NSUInteger nowIndex=[self.descObjs indexOfObject:self.currentTFObj];
    
    _keyBoardToolBarView.isFirst=nowIndex==0;
    _keyBoardToolBarView.isLast=nowIndex==(self.descObjs.count - 1);
}




@end
