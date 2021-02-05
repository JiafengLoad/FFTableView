//
//  UITableViewCell+FFTableViewCell.h
//  BaseKitDemo
//
//  Created by Aubrey on 2020/8/31.
//  Copyright © 2020 Aubrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewObjects.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (FFTableViewCell)


///设置内边距
+ (void)setCellSeparatorInset:(UITableViewCell *)cell;


@end

NS_ASSUME_NONNULL_END
