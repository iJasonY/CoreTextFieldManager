# CorePhotoPickerVCManager
# 照片选取器
# 注：本框架由iOS开发攻城狮Charlin制作
#### Charlin：四川成都华西都市报旗下华西都市网络有限公司技术部iOS工程师！
##版本特性
##键盘自动调整工具
##本工具考虑了自动排序（不区分控件添加顺序或者您给我的数组里面的顺序）
##本工具考虑了视图嵌套。

###全新的特性：
    网上大量的代码是能够避开键盘的，不可不可接受的是不知道键盘下面还有按钮呢，很多时候文本输入框避开了，但是下面的按钮还是被挡住了，
    本工具是专门解决这个问题的，你要做的就是，继承我的这个类，传一个数组给我即可。
    bottomInset表示这个文本输入框是否需要向下多留一点空白，一般是文本框下面有提示类文字或者提交类按钮可以设置此值。
#使用示例
CoreTFDescObj *obj1=[CoreTFDescObj tfDescObj:_tf1 bottomInset:0];
    CoreTFDescObj *obj2=[CoreTFDescObj tfDescObj:_tf2 bottomInset:0];
    CoreTFDescObj *obj3=[CoreTFDescObj tfDescObj:_tf3 bottomInset:0];
    CoreTFDescObj *obj4=[CoreTFDescObj tfDescObj:_tf4 bottomInset:32];
    CoreTFDescObj *obj5=[CoreTFDescObj tfDescObj:_tf5 bottomInset:0];
    
    
    self.descObjs=@[obj1,obj2,obj3,obj4,obj5];

    



#看看效果图吧
![image](./1.png)


