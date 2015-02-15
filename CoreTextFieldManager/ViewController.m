//
//  ViewController.m
//  CoreTextFieldManager
//
//  Created by muxi on 15/2/15.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "CoreTFDescObj.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *tf1;

@property (strong, nonatomic) IBOutlet UITextField *tf2;

@property (strong, nonatomic) IBOutlet UITextField *tf3;

@property (strong, nonatomic) IBOutlet UITextField *tf4;

@property (strong, nonatomic) IBOutlet UITextField *tf5;






@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTF];
    
    [self.tf1 becomeFirstResponder];

}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
}

-(void)setupTF{
    CoreTFDescObj *obj1=[CoreTFDescObj tfDescObj:_tf1 bottomInset:0];
    CoreTFDescObj *obj2=[CoreTFDescObj tfDescObj:_tf2 bottomInset:0];
    CoreTFDescObj *obj3=[CoreTFDescObj tfDescObj:_tf3 bottomInset:0];
    CoreTFDescObj *obj4=[CoreTFDescObj tfDescObj:_tf4 bottomInset:32];
    CoreTFDescObj *obj5=[CoreTFDescObj tfDescObj:_tf5 bottomInset:0];
    
    
    self.descObjs=@[obj1,obj2,obj3,obj4,obj5];
}



@end
