//
//  UITableViewCell+FFTableViewCell.m
//  BaseKitDemo
//
//  Created by Aubrey on 2020/8/31.
//  Copyright © 2020 Aubrey. All rights reserved.
//

#import "UITableViewCell+FFTableViewCell.h"

@implementation UITableViewCell (FFTableViewCell)


+ (void)setCellSeparatorInset:(UITableViewCell *)cell{
    
    for (UIView *subview in cell.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
            CGRect frame = subview.frame;
            frame.origin.x += cell.separatorInset.left;
            frame.size.width -= cell.separatorInset.right;
            subview.frame =frame;
        }
    }
}


@end
