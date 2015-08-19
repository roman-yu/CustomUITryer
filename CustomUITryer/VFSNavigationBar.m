//
//  VFSNavigationBar.m
//  CustomUITryer
//
//  Created by Chen YU on 7/8/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import "VFSNavigationBar.h"

const CGFloat VFSNavigationBarHeightIncrease = 38.f;

@implementation VFSNavigationBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
//    [self setTitleVerticalPositionAdjustment:-(VFSNavigationBarHeightIncrease) forBarMetrics:UIBarMetricsDefault];
    [self setTransform:CGAffineTransformMakeTranslation(0, -(VFSNavigationBarHeightIncrease))];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSArray *classNamesToReposition = @[@"UINavigationItemView", @"UINavigationButton"];
//    
//    for (UIView *view in [self subviews]) {
//        
//        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
//            
//            CGRect frame = [view frame];
//            frame.origin.y -= VFSNavigationBarHeightIncrease;
//            
//            [view setFrame:frame];
//            
//            if ([NSStringFromClass([view class]) isEqualToString:@"UINavigationItemView"]) {
//                view.backgroundColor = [UIColor orangeColor];
//                NSLog(@"Superview: %@", NSStringFromCGRect(view.frame));
//                for (UIView *subview in view.subviews) {
//                    if ([subview isKindOfClass:[UILabel class]]) {
//                        NSLog(@"Subview: %@", NSStringFromCGRect(subview.frame));
//                        subview.backgroundColor = [UIColor redColor];
//                    }
//                }
//            }
//        }
//    }
    
    [super layoutSubviews];
    
    NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            frame.origin.y = bounds.origin.y + VFSNavigationBarHeightIncrease - 20.f;
            frame.size.height = bounds.size.height + 20.f;
            
            [view setFrame:frame];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height += VFSNavigationBarHeightIncrease;
    
    return amendedSize;
}

@end
