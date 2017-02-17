//
//  ModalViewController.m
//  InteractiveModal-OC
//
//  Created by 王顺 on 2017/2/14.
//  Copyright © 2017年 shun. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
/**
 tableview
*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareTableView];
}
- (void)prepareTableView{
    // 注册 cellID
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewGesture:)];
    pan.delegate = self;
    [self.tableView addGestureRecognizer:pan];
}

- (void)tableViewGesture:(UIPanGestureRecognizer *)gesture {
//    NSLog(@"offsetY : %f ", self.tableView.contentOffset.y);
    CGFloat percentThreshold = 0.3;
    
    CGPoint translation = [gesture translationInView:self.view];
    CGFloat verticalMovement = translation.y / self.view.bounds.size.height;
    float downwardMovement = fmaxf(verticalMovement, 0.0);
    float downwardMovementPercent = fminf(downwardMovement, 1.0);
    CGFloat progress = downwardMovementPercent;
    
    NSLog(@"progress : %f", progress);
    if (self.interactor == nil) {
        return;
    }

    if (self.tableView.contentOffset.y > 0) {
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
        progress = 0;
//        for (UIGestureRecognizer *gesture in self.tableView.gestureRecognizers) {
//            NSLog(@"%ld",gesture.state);
//        }
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactor.hasStarted = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            self.interactor.shouldFinish = progress > percentThreshold;
            
            [self.interactor updateInteractiveTransition:progress];
            if (progress > 0) {
                [self.tableView setContentOffset:CGPointMake(0, 0)];
            }
            
        }
            break;
        case UIGestureRecognizerStateCancelled:{
            self.interactor.hasStarted = NO;
            [self.interactor cancelInteractiveTransition];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            self.interactor.hasStarted = NO;
            self.interactor.shouldFinish ? [self.interactor finishInteractiveTransition] : [self.interactor cancelInteractiveTransition];
        }
            break;
        default:
            break;
    }

}

- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleGesture:(UIPanGestureRecognizer *)sender {
    CGFloat percentThreshold = 0.3;
    
    CGPoint translation = [sender translationInView:self.view];
    CGFloat verticalMovement = translation.y / self.view.bounds.size.height;
    float downwardMovement = fmaxf(verticalMovement, 0.0);
    float downwardMovementPercent = fminf(downwardMovement, 1.0);
    CGFloat progress = downwardMovementPercent;
    
    NSLog(@"progress : %f", progress);
    if (self.interactor == nil) {
        return;
    }
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactor.hasStarted = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            self.interactor.shouldFinish = progress > percentThreshold;
            [self.interactor updateInteractiveTransition:progress];
        }
            break;
        case UIGestureRecognizerStateCancelled:{
            self.interactor.hasStarted = NO;
            [self.interactor cancelInteractiveTransition];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            self.interactor.hasStarted = NO;
            self.interactor.shouldFinish ? [self.interactor finishInteractiveTransition] : [self.interactor cancelInteractiveTransition];
        }
            break;
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        NSLog(@"dfdf");
        return YES;
    }
    return NO;
}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.interactor.hasStarted = YES;
//    [self dismissViewControllerAnimated:YES completion:nil];
// 
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat percentThreshold = 0.3;
//    
//    CGPoint translation = CGPointMake(0, - scrollView.contentOffset.y);
//    CGFloat verticalMovement = translation.y / self.tableView.bounds.size.height;
//    float downwardMovement = fmaxf(verticalMovement, 0.0);
//    float downwardMovementPercent = fminf(downwardMovement, 1.0);
//    CGFloat progress = downwardMovementPercent;
//    
//    self.interactor.shouldFinish = progress > percentThreshold;
//    NSLog(@"progress : %f", progress);
//    [self.interactor updateInteractiveTransition:progress];
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//
//    self.interactor.hasStarted = NO;
//    self.interactor.shouldFinish ? [self.interactor finishInteractiveTransition] : [self.interactor cancelInteractiveTransition];
//}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 根据 cellID 创建对应的 cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    cell.textLabel.text = @"测试UITableViewCell";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    // 选中后立即取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -
- (Interactor *)interactor {
    if (_interactor == nil) {
        _interactor = [[Interactor alloc] init];
    }
    return _interactor;
}
@end
