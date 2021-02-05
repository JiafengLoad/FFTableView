//
//  TableViewDelegate.h
//  BaseKitDemo
//
//  Created by Aubrey on 2020/8/31.
//  Copyright © 2020 Aubrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewObjects.h"



extern  NSString * const _Nullable kApiHeader;
extern  NSString * const _Nullable kApiFooter;
extern  NSString * const _Nullable kApiHeight;
extern  NSString * const  _Nullable kApiContent;


NS_ASSUME_NONNULL_BEGIN

///cell点击的回调
typedef void(^TableViewCellDidSelctedBlock)(id tableView, id cell ,NSIndexPath*indexPath, id data);
///tablview滚动的回调
typedef void(^ScrollViewDidScrollBlock)(UIScrollView *scrollView ,CGFloat offsetX, CGFloat offsetY);
///给header赋值的block
typedef void(^TableViewSectionHeaderConfigureBlock)(id sectionHeader ,id datas, NSInteger section);


@interface TableViewDelegate:TableViewObjects<UITableViewDelegate>


/// 初始化代理对象
/// @param tableViewIdentifier tableViewIdentifier标识
/// @param cellIdentifierArr 重用标识数组
/// @param dataSectionalizedWay 数据源是否分组
/// @param isDiversifiedCellStyle cell样式是否多种
/// @param tableViewStyle tableViewStyle的样式
/// @param isCellSameHeight isCellSameHeight是否等高
/// @param  isDynamicHeight  是否是动态的高度
/// @param cell_height_arr 是cell的高的数组   （动态高度时，该数组传空就可）
/// @param aSelectedBlock 点击事件
/// @param model 数据源
- (instancetype)initWithTableViewIdentifier:(NSString*)tableViewIdentifier
                      CellIdentifierArr:(NSArray<NSArray<NSString*> *>*)cellIdentifierArr
                      dataSectionalizedWay:(DataSectionalizedWay)dataSectionalizedWay
                      isDiversifiedCellStyle:(BOOL)isDiversifiedCellStyle
                      tableViewStyle:(UITableViewStyle)tableViewStyle
                      isCellSameHeight:(BOOL)isCellSameHeight
                      isDynamicHeight:(BOOL)isDynamicHeight
                       heightArr:( nullable NSArray*)cell_height_arr
                       selectedBlock:(TableViewCellDidSelctedBlock)aSelectedBlock models:(NSArray*)model;


//tablevew滚动的block回调
@property(nonatomic,copy)ScrollViewDidScrollBlock scrollViewDidScrollBlock;
//tablevew点击的block回调
@property(nonatomic,copy)TableViewCellDidSelctedBlock tablViewCellSelectedBlock;
//header赋值的block回调
@property(nonatomic,copy)TableViewSectionHeaderConfigureBlock tableViewSectionHeaderConfigureBlock;

#warning 之所以把heightarr暴露在外面是，会因为，考虑到有时候后台请求不到某一组的时候，前端要做到把这一组给省略掉，也就是正常情况下，是把高度数组在创建代理对象的时候，就写死穿进去了的，但是如果请求不到，那么这一组就要高度为0
///cell的高的数组 （为静态数组，一开始就写死了）
@property(nonatomic,strong)NSArray *cell_height_arr;

///cell的高的数组（动态数组，动态计算数组高度）
@property(nonatomic,strong)NSMutableArray *dynamic_cell_height_arr;



//---------------------区头区脚部分------------------///
/// 区头的高数组
@property(nonatomic,strong)NSMutableArray<NSMutableDictionary*> *headerHieghts;
@property(nonatomic,strong)NSMutableArray<NSMutableDictionary*> *headerContents;
/// 区脚的数组
@property(nonatomic,strong)NSMutableArray<NSMutableDictionary*> *footers;

@property(nonatomic,strong)NSString *HeaderID;
@property(nonatomic,strong)NSString *FooterID;






@end

NS_ASSUME_NONNULL_END
