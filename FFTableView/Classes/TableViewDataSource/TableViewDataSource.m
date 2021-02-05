//
//  TableViewDataSource.m
//  BaseKitDemo
//
//  Created by Aubrey on 2020/8/31.
//  Copyright © 2020 Aubrey. All rights reserved.
//

#import "TableViewDataSource.h"

@implementation TableViewDataSource


//--------------------------------------初始化方法---------------------------------------------------//
/// 初始化方法,
- (instancetype)initWithItems:(NSMutableArray *)anItems
                      tableViewIdentifier:(NSString*)tableViewIdentifier
                      tableViewStyle:(UITableViewStyle)tableViewStyle
                      dataSectionalizedWay:(DataSectionalizedWay)dataSectionalizedWay
                      isDiversifiedCellStyle:(BOOL)isDiversifiedCellStyle
                      cellNameArr:(NSArray<NSArray<NSString*>*>*)cellNameArr
                      cellIdentifierArr:(NSArray<NSArray<NSString*>*>*)cellIdentifierArr
                      configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock {
     
    
        if (self) {
           
            self.tableViewIdentifier = tableViewIdentifier; //tablview的标识
            self.dataSectionalizedWay = dataSectionalizedWay;   //数据源是否分成多组（因为平铺时，也是可以分组的，关键还是还数据源是否分组）
            self.isDiversifiedCellStyle = isDiversifiedCellStyle;//cell是否多种样式
            self.modelArr = anItems;  //数据源
            
            if (isDiversifiedCellStyle==YES) {
                //cell的样式有多种时,重用标识肯定有多个
                self.cellIdentifierArr = cellIdentifierArr;
//                ConsoleLog(@"样式多种");
            }else{
                //cell的样式只有一种，重用标识取第一个
                self.cellIdentifierArr = cellIdentifierArr;
                self.cellIdentifier = [[cellIdentifierArr firstObject]firstObject];

//                ConsoleLog(@"样式单一,cell的标识数组%@,  取第一个重用标识==%@",self.cellIdentifierArr,self.cellIdentifier);
            }
          
            if (aConfigureCellBlock !=nil) {
                    self.configureCellBlock = [aConfigureCellBlock copy];
             }

        }
        return self;
}


//--------------------------------------数据getter-------------------------------------------------//
#pragma mark - getter -
/// 当数据源不分组的时候，获取对应的模型
- (instancetype)modelAtIndexPath:(NSIndexPath *)indexPath{
   
     if ( self.dataSectionalizedWay==EverySameModelAndUngrouped ) {
         NSLog(@"①数据源不分组 || ②共一组,行数==%ld || ③返回的是每一行的数据", (unsigned long)[self.modelArr count] );
        return self.modelArr[(NSUInteger) indexPath.row];
    }
    return nil;
}

/// 当数据源分组时，获取每个组下对应的模型数组
- (NSArray*)modelsArrayAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.dataSectionalizedWay != EverySameModelAndUngrouped) {
        NSLog(@"①数据源分组 || ②有多组，组数==%ld || ③返回的是每一组的数据",(unsigned long)[self.modelArr[(NSUInteger) indexPath.section] count]);
         return self.modelArr[(NSUInteger) indexPath.section];
    }
   return nil;
}

//--------------------------------------UITableViewDataSource------------------------------------------//
#pragma mark- UITableViewDataSource-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    CGFloat section = 0;
    return   section = (self.dataSectionalizedWay >0) ? 1 : self.modelArr.count;

    /*
     写法2
     if (self.dataSectionalizedWay != 0) { //不等于0 ，也就是分组了 ，是剩余的三种枚举之一
         //不管cell单一样式 或者 cell样式多样，只要数据源分组了，那么就都是返回总共的组数
          ConsoleLog(@"① 数据源分组 + ② tableView组数==%ld",self.modelArr.count);
         return self.modelArr.count;    //
     }else{
         //不管[cell单一样式] 还是 [cell样式多样] ，只要数据源不分组，那么就组数就是1
         ConsoleLog(@"① 数据源不分组 + ② tableView组数==1 ");
         return 1;    //(样式相同不分组)   //@[模型1，模型2....]
     }
     
     */

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *style_describeString; //tableView的样式描述
    NSString *cell_describeString;   //cell的样式描述
    NSString *datasource_describeString;  //数据源描述

    NSInteger rows = 0;
    
    //tableView的样式
    style_describeString = (self.tableViewStyle==UITableViewStylePlain) ? @"tableview平铺" : @"tableview分组";
    //cell的样式
    cell_describeString = (self.isDiversifiedCellStyle==NO) ? @"cell单一样式" : @"cell多种样式";
    //数据源描述
    datasource_describeString = (self.dataSectionalizedWay>0)? @"数据源分组" : @"数据源不分组";
    
//    ConsoleLog(@"①%@ || 行数==%ld  + ②%@ + ③%@", datasource_describeString, self.modelArr.count, style_describeString, cell_describeString);

    return   rows = (self.dataSectionalizedWay >0) ? [self.modelArr[section] count] : self.modelArr.count;

    
    
    /*
     
     写法2
     
     //数据源分组情况
       switch (self.dataSectionalizedWay) {
           case EverySameModelAndUngrouped: //不分组， 每个模型相同，      ==>  @[A模型，A模型,A模型.....]  共1组
               return self.modelArr.count;
               break;
               
           case EverySameModelAndGrouped: //分组， 每个模型都相同，      ==>  @[ @[A模型]，@[A模型]，@[A模型] ]
               return  [self.modelArr[section] count];;
               break;
               
           case EveryDifferentModelAndGrouped: //分组 ，每个模型都不同，     ==>  @[ @[A模型]，@[B模型]，@[C模型] ]
               return [self.modelArr[section] count];
               break;
               
           case SomeSameSomeDefferGrouped: //分组，但相同模型的归为1组，      ==>   @[ @[A模型，A模型],  @[B模型] ... ]
               return [self.modelArr[section] count];
               break;
        
           default:
               break;
       }
     
     */

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    switch (self.dataSectionalizedWay) {
            
        //1 数据源不分组
        case EverySameModelAndUngrouped: //不分组， 每个模型相同，      ==>  @[A模型，A模型,A模型.....]  共1组
            if (self.isDiversifiedCellStyle==NO) { //单一样式
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
                    if (!cell) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
                        }
                    id item = [self modelAtIndexPath:indexPath]; //在数据源中拿到对应行的数据
                    if (self.configureCellBlock) {
                            //通过block把cell和改cell对应的数据（如果转过模型就是对应的model）传过去。
                           self.configureCellBlock(cell, item,indexPath);
                    }
                   
                   return cell;
   
            }//else{ //1-2 数据源不分组+cell样式不同 （基本上不太可能）   }
            break;
            
       //2 数据源分组
        case EverySameModelAndGrouped://分组， 每个模型都相同，      ==>  @[ @[A模型]，@[A模型]，@[A模型] ]
            if (self.isDiversifiedCellStyle==NO) {
    
                if (indexPath.section < self.modelArr.count) {//防止数组越界
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
                        }
                    id modelArray = [self modelsArrayAtIndexPath:indexPath];
                    if (self.configureCellBlock) {
                        self.configureCellBlock(cell, modelArray, indexPath); //通过block把cell和改cell对应的模型数组传过去。
                       }
                    return cell;
                }

            }
            break;
           
        //3 数据源分组
        case EveryDifferentModelAndGrouped: //分组 ，每个模型都不同，     ==>  @[ @[A模型]，@[B模型]，@[C模型] ]
            if (self.isDiversifiedCellStyle==YES){
                if ( indexPath.row<[self.modelArr[indexPath.section] count] ) { //防止数组越界
                         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifierArr[indexPath.section][0]  forIndexPath:indexPath];
                         if (!cell) {
                             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifierArr[indexPath.section][0] ];
                             }
                         //在数据源中拿到对应行的数据
                         id modelArray = [self modelsArrayAtIndexPath:indexPath];
                         if (self.configureCellBlock) {
                             self.configureCellBlock(cell, modelArray, indexPath);  //通过block把cell和改cell对应的数据（如果转过模型就是对应的model）传过去。
                             }
                                                                     
                             return cell;
                       }
            }
            break;
            
#warning 这里就是OC语言的语法局限性的提现了，case==2和3明明可以合并的
       //4 数据源分组
        case SomeSameSomeDefferGrouped://分组，但相同模型的归为1组，      ==>   @[ @[A模型，A模型],  @[B模型] ... ]
            if (self.isDiversifiedCellStyle==YES){
                if ( indexPath.row<[self.modelArr[indexPath.section] count] ) { //防止数组越界
                         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifierArr[indexPath.section][0]  forIndexPath:indexPath];
                         if (!cell) {
                             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifierArr[indexPath.section][0] ];
                             }
                         //在数据源中拿到对应行的数据
                         id modelArray = [self modelsArrayAtIndexPath:indexPath];
                         if (self.configureCellBlock) {
                             self.configureCellBlock(cell, modelArray, indexPath);  //通过block把cell和改cell对应的数据（如果转过模型就是对应的model）传过去。
                             }
                                                                     
                             return cell;
                       }
            }
            break;
            
        default:
            break;
    }
    
    
    return [UITableViewCell new];
    
    
    
    /*
     
     //1-数据源不分组
      if (self.isDataSectionalized==NO) {
          //1-1 数据源不分组+cell样式相同
          if (self.isDiversifiedCellStyle==NO) { //单一样式
                  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
                  if (!cell) {
                          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
                      }
                  id item = [self modelAtIndexPath:indexPath]; //在数据源中拿到对应行的数据
                  if (self.configureCellBlock) {
                          //通过block把cell和改cell对应的数据（如果转过模型就是对应的model）传过去。
                         self.configureCellBlock(cell, item,indexPath);
                  }
                 
                 return cell;
 
          }
          //1-2 数据源不分组+cell样式不同 （基本上不太可能）
          else{
              
          }
          
      }
  
     //2-数据源分组
      else{
          //2-1 数据源分组 + cell样式相同
          if (self.isDiversifiedCellStyle==NO) {
  
              if (indexPath.section < self.modelArr.count) {//防止数组越界
                  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
                  if (!cell) {
                      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
                      }
                  id modelArray = [self modelsArrayAtIndexPath:indexPath];
                  if (self.configureCellBlock) {
                      self.configureCellBlock(cell, modelArray, indexPath); //通过block把cell和改cell对应的模型数组传过去。
                     }
                  return cell;
              }

          }
          //2-2 数据源分组 + cell样式不同
          else{
              
                 if ( indexPath.row<[self.modelArr[indexPath.section] count]) { //防止数组越界
                          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifierArr[indexPath.section][0]  forIndexPath:indexPath];
                          if (!cell) {
                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifierArr[indexPath.section][0] ];
                              }
                          //在数据源中拿到对应行的数据
                          id modelArray = [self modelsArrayAtIndexPath:indexPath];
                          if (self.configureCellBlock) {
                              self.configureCellBlock(cell, modelArray, indexPath);  //通过block把cell和改cell对应的数据（如果转过模型就是对应的model）传过去。
                              }
                                                                      
                              return cell;
                        }

            
          }
          
      }
     */


    
}




@end
