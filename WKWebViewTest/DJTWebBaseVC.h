//
//  DJTWebBaseVC.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/25.
//  Copyright © 2018年 Smy_D. All rights reserved.
//


//这个基类主要是为了设置uinavbar样式，uinavigationcontroller之时一个控制控制器的工具，起粘合作用，不包括uinavigationbar的样式设置，我们应该把 设置uinavigationbar的样式放在这样一个基类中，其他类继承这个基类，就有了相同的样式，那如果想要不同的样式，直接重写这个基类的setnavbar方法即可

#import <UIKit/UIKit.h>

@interface DJTWebBaseVC : UIViewController

@end
