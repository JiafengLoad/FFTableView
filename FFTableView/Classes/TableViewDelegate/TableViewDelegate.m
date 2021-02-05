//
//  TableViewDelegate.m
//  BaseKitDemo
//
//  Created by Aubrey on 2020/8/31.
//  Copyright © 2020 Aubrey. All rights reserved.
//

#import "TableViewDelegate.h"
#import <objc/runtime.h>


NSString *const kApiHeader    = @"kApiHeader";
NSString *const kApiFooter    = @"kApiFooter";
NSString *const kApiHeight  = @"kApiHeight";
NSString *const kApiContent  = @"kApiContent";



@interface TableViewDelegate ()

/// 是否cell的高是相同的
@property(nonatomic,assign)BOOL isCellSameHeight;
/// cell的高，是否是动态计算的
@property(nonatomic,assign)BOOL isDynamicHeight;

@end


@implementation TableViewDelegate






#pragma mark - 代理对象初始化方法
- (instancetype)initWithTableViewIdentifier:(NSString*)tableViewIdentifier
                      CellIdentifierArr:(NSArray<NSString *>*)cellIdentifierArr
                      dataSectionalizedWay:(DataSectionalizedWay)dataSectionalizedWay
                      isDiversifiedCellStyle:(BOOL)isDiversifiedCellStyle
                      tableViewStyle:(UITableViewStyle)tableViewStyle
                      isCellSameHeight:(BOOL)isCellSameHeight
                      isDynamicHeight:(BOOL)isDynamicHeight
                      heightArr:(nullable NSArray*)cell_height_arr
                      selectedBlock:(TableViewCellDidSelctedBlock)aSelectedBlock models:(NSArray*)models
                      {
    self = [super init];
    if (self) {

        self.tableViewIdentifier = tableViewIdentifier;
        self.cellIdentifierArr = cellIdentifierArr;
        self.dataSectionalizedWay = dataSectionalizedWay;
        self.tableViewStyle = tableViewStyle;
        self.isDiversifiedCellStyle = isDiversifiedCellStyle;
        self.isCellSameHeight = isCellSameHeight; //cell是否等高
        self.isDynamicHeight = isDynamicHeight;
        if (cell_height_arr && cell_height_arr.count>0) {  //动态高度的时候，是会传nil的
              self.cell_height_arr = cell_height_arr;
        }
        if (models !=nil ) {
             self.modelArr = [models mutableCopy];
        }
        if (aSelectedBlock !=nil ) {
             self.tablViewCellSelectedBlock =[aSelectedBlock copy];
        }
    }
    return self;
}


#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
#warning 高度，需要考虑到时静态写死的，还是动态变动的

    return  (self.isDynamicHeight ==YES) ? [self getDynamicHeightAtIndexPath:indexPath]:[self getStaticHeightAtIndexPath:indexPath];

}

//动态cell的高（每个cell高度不固定）
- (CGFloat)getDynamicHeightAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.isSectionalized ==YES) {
////            if (self.isCellSameHeight) {
////                //数据源分组+等高   即使数据源分组了，但是cell的高还是可能：等高
////                return [self.dynamicHeightArr.firstObject doubleValue];
////            }else{
////                //数据源分组，且cell的高，不等高
////                return [ self.dynamicHeightArr[indexPath.section][0] doubleValue];
////            }
//        return 0;
//    }else{
//#warning 即使是动态数组的时候，数据源不分组，也未必就是等高，最典型的例子就是微信朋友圈
////            //数据源不分组+等高
////             return [self.dynamicHeightArr.firstObject doubleValue];
//
//        //微信朋友圈为例
//        if ( self.modelArr.count>self.dynamicHeightArr.count) {  //
//            NSLog(@"数据源个数%ld，动态高度数组==%ld",self.modelArr.count,self.dynamicHeightArr.count);
////                [self.dynamicHeightArr addObject:@"0"];
//            return [self.dynamicHeightArr[indexPath.row] doubleValue];
////                 NSException *exception = [NSException exceptionWithName:@"outofBounds" reason:@"数组越界" userInfo:nil];
////                 @throw exception;
//        }else{
//             return [self.dynamicHeightArr[indexPath.row] doubleValue];
//        }
//
//
//    }
    
    return 0;
}

//静态写死的cell高度 每个cell高度固定）
- (CGFloat)getStaticHeightAtIndexPath:(NSIndexPath *)indexPath{
      //平铺+数据源分组   平铺+数据源不分组
      //分组+数据源分组   分组+数据源不分组

    switch (self.dataSectionalizedWay) {
            
        case EverySameModelAndUngrouped:   //数据源不分组+等高
            if (self.isCellSameHeight) {
                return [self.cell_height_arr.firstObject doubleValue]; //不分组， 每个模型相同，      ==>  @[A模型，A模型,A模型.....]  共1组
            }
            break;
            
        case EverySameModelAndGrouped:    //数据源分组+等高
            if (self.isCellSameHeight) {
                return [self.cell_height_arr.firstObject doubleValue]; //分组， 每个模型都相同， ==>  @[ @[A模型]，@[A模型]，@[A模型] ]
            }
            break;
            
        case EveryDifferentModelAndGrouped://数据源分组+每一组的高不一样，
            if (self.isCellSameHeight==NO) {
                return [ self.cell_height_arr[indexPath.section][0] doubleValue];//分组 ，每个模型都不同==>@[ @[A模型],@[B模型],@[C模型] ]
            }
            break;
            
        case SomeSameSomeDefferGrouped: //数据源分组+每一组的高不一样，
            if (self.isCellSameHeight==NO) {
                return [ self.cell_height_arr[indexPath.section][0] doubleValue];//分组，但相同模型的归为1组 ==>   @[ @[A模型，A模型],  @[B模型] ... ]:
            }
            break;
            
        default:
            break;
    }
    
    return 0;
    
    /*
     写法2
     if (self.isSectionalized ==YES) {
           if (self.isCellSameHeight) {
               //数据源分组+等高即使数据源分组了，但是cell的高还是可能：等高
               return [self.heightArr.firstObject doubleValue];
           }else{
               //数据源分组，且cell的高，不等高
               return [ self.heightArr[indexPath.section][0] doubleValue];
           }
       }else{
           //数据源不分组+等高
            return [self.heightArr.firstObject doubleValue];
       }
     */
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  

    //
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
//    ConsoleLog(@"我点击了第%ld组---第%ld行cell--cell类型==%@",(long)indexPath.section, (long)indexPath.row,object_getClass(cell));

    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if (self.dataSectionalizedWay != EverySameModelAndUngrouped) {  //1 数据源分组

        if (self.modelArr.count>0  &&  [self.modelArr[indexPath.section] isKindOfClass:[NSArray class]]) {  //数组
            
            id model = self.modelArr[indexPath.section][indexPath.row];
             self.tablViewCellSelectedBlock(tableView,cell, indexPath,model);
            
        }else if (self.modelArr.count>0  &&[self.modelArr[indexPath.section] isKindOfClass:[NSDictionary class]] ){ //字典
            
            id model = self.modelArr[indexPath.section];
            self.tablViewCellSelectedBlock(tableView,cell, indexPath,model);
        }
         
    }else{   //2 数据源不分组
        
        id model = self.modelArr[indexPath.row];
        self.tablViewCellSelectedBlock(tableView,cell, indexPath,model);
    }


}

//---------------------区头区脚部分------------------///
#pragma mark - 区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kApiHeader ];
    if (!header) {
         header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:kApiHeader ];
     }
#warning tablview的区头像cell一样，也是要注册的
    if (self.tableViewSectionHeaderConfigureBlock && self.headerContents ) {
        NSDictionary *contentDic = self.headerContents[section];
        NSString *string = contentDic[kApiContent];
        self.tableViewSectionHeaderConfigureBlock(header, string, section);
    }
    
   return header;
}
#pragma  mark - 区头高 -
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    if ( (self.headerHieghts && self.headerHieghts.count>0)  && (section<self.headerHieghts.count) ) {
        
        CGFloat height =  [[self.headerHieghts[section] objectForKey:kApiHeight] floatValue];//从数组的字典中，取出高
//        ConsoleLog(@"头高==%.2f",height);
        return height;
    }
   return 0;
}

#pragma mark - 区脚
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.footers && self.footers.count>0) {
        return  [self.footers[section] objectForKey:kApiFooter];  //从数组的字典中，取出脚
    }
    return nil;
}
#pragma mark - 区脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.footers && self.footers.count>0  && (section<self.footers.count)  ) {
         return  [[self.footers[section] objectForKey:kApiHeight] floatValue];//从数组的字典中，取出高
    }
    return 0;
}



#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"X==%f",offsetX);
    NSLog(@"Y==%f",offsetY);

    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView, offsetX, offsetY);
    }
    
}



//重写动态高度的数组，并缓存高度，以键值对的形式去缓存 index.row : height,放到数组中
- (void)setDynamic_cell_height_arr:(NSMutableArray *)dynamic_cell_height_arr{
    _dynamic_cell_height_arr = dynamic_cell_height_arr;
}



@end
