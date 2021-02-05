//
//  TableViewObjects.h
//  BaseKitDemo
//
//  Created by Aubrey on 2020/8/31.
//  Copyright © 2020 Aubrey. All rights reserved.
//

#import <Foundation/Foundation.h>



//  @[A模型，A模型,]  每个模型相同，他就不分组了
//  @[ @[A模型]，@[A模型]，@[A模型] ]    每个模型都相同，但是他还是分成了多组
//  @[ @[A模型]，@[B模型]，@[C模型] ]
//  @[ @[A模型，A模型],  @[B模型]  ]


typedef NS_ENUM(NSInteger,DataSectionalizedWay) {
    EverySameModelAndUngrouped = 0,  //不分组， 每个模型相同，      ==>  @[A模型，A模型,A模型.....]  共1组
    EverySameModelAndGrouped = 1,      //分组， 每个模型都相同，      ==>  @[ @[A模型]，@[A模型]，@[A模型] ] 共3组
    EveryDifferentModelAndGrouped = 2,  //分组 ，每个模型都不同，     ==>  @[ @[A模型]，@[B模型]，@[C模型] ]
    SomeSameSomeDefferGrouped =3,     // 分组，但相同模型的归为1组，  ==>   @[ @[A模型，A模型],  @[B模型] ... ]
};

NS_ASSUME_NONNULL_BEGIN


#warning 参数datas之所以是id，是因为他的数据类型不确定
///cell赋值的block回调
typedef void(^TableViewCellConfigureBlock)(id cell ,id datas, NSIndexPath*indexPath);


@interface TableViewObjects : NSObject

/// tableview标识
@property(nonatomic,strong) NSString *tableViewIdentifier;

/// tablview样式
@property(nonatomic,assign)UITableViewStyle tableViewStyle;

/// 是否是多种cell的样式
@property(nonatomic,assign)BOOL isDiversifiedCellStyle;

///Cell的类名数组(可能有多个tablviewcell的类)
@property(nonatomic,strong)NSArray *cellClassNames;

/// Cell重用标识数组(多种样式)
@property (nonatomic, strong)NSArray *cellIdentifierArr;

///Cell重用标识 ( 单一样式时，取重用标识数组中的第一个)
@property (nonatomic, copy) NSString *cellIdentifier;


//@property(nonatomic,assign)BOOL isDataSectionalized;
/// 数据源分组方式
@property(nonatomic,assign)DataSectionalizedWay dataSectionalizedWay;


/// 数据源
@property (nonatomic, strong)NSMutableArray *modelArr;



@end

NS_ASSUME_NONNULL_END
