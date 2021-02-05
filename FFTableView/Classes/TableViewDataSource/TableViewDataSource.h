//
//  TableViewDataSource.h
//  BaseKitDemo
//
//  Created by Aubrey on 2020/8/31.
//  Copyright © 2020 Aubrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewObjects.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewDataSource : TableViewObjects<UITableViewDataSource>

///cell赋值的block回调
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;


/// 数据源对象初始化方法
/// @param anItems  tablview的数据
/// @param tableViewIdentifier tablview的标识（表明我当前创建的是哪个tabalview）
/// @param tableViewStyle tablview的风格（平铺还是分组）
/// @param dataSectionalizedWay 数据源分组方式，默认0为不分组
/// @param isDiversifiedCellStyle tableview是否是多种样式的cell
/// @param cellNameArr 所注册的cell的名称数组
/// @param cellIdentifierArr  所注册的cell的重用标识数组
/// @param aConfigureCellBlock 赋值cell的block
- (instancetype)initWithItems:(NSMutableArray *)anItems
                      tableViewIdentifier:(NSString*)tableViewIdentifier
                      tableViewStyle:(UITableViewStyle)tableViewStyle
                      dataSectionalizedWay:(DataSectionalizedWay)dataSectionalizedWay
                      isDiversifiedCellStyle:(BOOL)isDiversifiedCellStyle
                      cellNameArr:(NSArray<NSArray<NSString*>*>*)cellNameArr
                      cellIdentifierArr:(NSArray<NSArray<NSString*>*>*)cellIdentifierArr
                      configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;


///数据源不分组时候，拿到某一行的数据
- (instancetype)modelAtIndexPath:(NSIndexPath *)indexPath;

///数据源分组时候，拿到对应组中的某一行的数组
- (NSArray*)modelsArrayAtIndexPath:(NSIndexPath *)indexPath;



@end

NS_ASSUME_NONNULL_END
