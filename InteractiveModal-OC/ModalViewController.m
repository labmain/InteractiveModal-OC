//
//  ModalViewController.m
//  InteractiveModal-OC
//
//  Created by 王顺 on 2017/2/14.
//  Copyright © 2017年 shun. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGFloat scrollProgress;
@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareTableView];
}
- (void)prepareTableView{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewGesture:)];
    pan.delegate = self;
    [self.tableView addGestureRecognizer:pan];
}

- (void)tableViewGesture:(UIPanGestureRecognizer *)gesture {
    
    if (self.tableView.contentOffset.y > 0 && self.scrollProgress == 0) {
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
        [self.interactor cancelInteractiveTransition];
        return;
    }
    // 超过区域的百分比，就dismiss
    CGFloat percentThreshold = 0.3;
    
    CGPoint translation = [gesture translationInView:self.view];
    CGFloat verticalMovement = translation.y / self.view.bounds.size.height;
    float downwardMovement = fmaxf(verticalMovement, 0.0);
    float downwardMovementPercent = fminf(downwardMovement, 1.0);
    CGFloat progress = downwardMovementPercent;
    self.scrollProgress = progress;
    if (self.interactor == nil) {
        return;
    }
    NSLog(@"progress : %f contentOffseY : %f", progress, self.tableView.contentOffset.y);

    if (progress > 0) {
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactor.hasStarted = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
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
// 手势穿透
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}
#pragma mark - 

// 关闭顶部弹簧效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.bounces = (scrollView.contentOffset.y <= [UIScreen mainScreen].bounds.size.height / 3) ? NO : YES;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell Index：%zd",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark -
- (Interactor *)interactor {
    if (_interactor == nil) {
        _interactor = [[Interactor alloc] init];
    }
    return _interactor;
}
@end
