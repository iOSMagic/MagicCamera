//
//  EnhaceModel.h
//  MagicCamera
//
//  Created by lipnpn on 16/2/29.
//  Copyright © 2016年 SongWentong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
//    dic = @{@"classname":@"GPUImageBrightnessFilter",@"selector":@"setBrightness:",@"showname":@"亮度",@"valueRange":@"-1,1"};

@interface EnhaceModel : NSObject
@property (nonatomic,strong)NSString *classname;
@property (nonatomic,strong)NSString *selector;
@property (nonatomic,strong)NSString *showname;
@property (nonatomic,assign)CGFloat maxValue;
@property (nonatomic,assign)CGFloat minValue;
@end
