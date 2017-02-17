//
//  GestureTableView.m
//  InteractiveModal-OC
//
//  Created by 王顺 on 2017/2/15.
//  Copyright © 2017年 shun. All rights reserved.
//

#import "GestureTableView.h"

@interface GestureTableView()<UIGestureRecognizerDelegate>

@end
@implementation GestureTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
