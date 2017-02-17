//
//  DismissAnimator.h
//  InteractiveModal-OC
//
//  Created by 王顺 on 2017/2/14.
//  Copyright © 2017年 shun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DismissAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@end
@interface Interactor : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL hasStarted;
@property (nonatomic, assign) BOOL shouldFinish;
@end
