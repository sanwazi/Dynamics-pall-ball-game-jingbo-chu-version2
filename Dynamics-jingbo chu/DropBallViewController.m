//
//  DropBallViewController.m
//  Dynamics-jingbo chu
//
//  Created by Stan on 11/21/14.
//  Copyright (c) 2014 UWL-Jingbo Chu. All rights reserved.
//

#import "DropBallViewController.h"
#import "BallView.h"

@interface DropBallViewController (){
    BallView * ball;
    UIDynamicAnimator * animator;
    UIGravityBehavior * gravity;
    UICollisionBehavior * collision;
    UIDynamicItemBehavior * dynamicItem;
    
    CGFloat block_height;
    CGFloat blank_height;
}

@end

@implementation DropBallViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 }

-(void) reset{
    [self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self.view setNeedsDisplay];
}

-(IBAction)tap:( UIGestureRecognizer *) gesture{
    CGPoint pt = [gesture locationInView: self.view];
    ball = [[BallView alloc] init];
   
    ball.center = CGPointMake(pt.x, pt.y);
    
    [self.view addSubview: ball];
    [collision addItem: ball];
    [gravity addItem: ball];
    [dynamicItem addItem:ball];
}

-(void) viewWillAppear:(BOOL)animated{
    [self reset];
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    gravity = [[UIGravityBehavior alloc] initWithItems:nil];
    [animator addBehavior:gravity];
    
    collision = [[UICollisionBehavior alloc] initWithItems:nil];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [animator addBehavior:collision];

    dynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:nil];
    dynamicItem.resistance = 0.1;
    dynamicItem.angularResistance = 0.1;
    dynamicItem.elasticity = 0.9;
    [animator addBehavior: dynamicItem];

    
    CGRect r = [UIScreen mainScreen].applicationFrame ;
    
    block_height = (r.size.height * 0.8)/ 8 * 0.28;
    blank_height = (r.size.height * 0.8)/ 8 * 0.72;
    
    CGFloat from = r.size.height * 0.25;
    
    for( int i = 0; i < 7; i++ ){
        [self generateBlock:from];
        from = from + block_height + blank_height;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) generateBlock:(CGFloat)begin{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    
    int count = arc4random() %3 + 3;
    int average = (rect.size.width - (count-1) * 59) / count;
    
    CGFloat from = 0;
    
    for( int i = 0; i < count - 1; i++ ){
        CGFloat w;
        switch( arc4random() % 4 ){
            case 0:
                w  = average + average * 0.15;
                break;
            case 1:
                w = average - average * 0.05;
                break;
            case 2:
                w = average + average * 0.17;
                break;
            default:
                w = average - average * 0.07;
        }
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(from,begin, w, block_height)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.layer.borderWidth = 2;
        [view.layer setBorderColor: [[UIColor blackColor] CGColor]];
        view.layer.cornerRadius = 8;
        [self.view addSubview:view];
        from += w + 59;
        
        [collision addBoundaryWithIdentifier:[NSString stringWithFormat:@"%i", i] forPath:[UIBezierPath bezierPathWithRect:view.frame]];
        
    }
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(from,begin, rect.size.width - from, block_height)];
    [view setBackgroundColor:[UIColor whiteColor]];
     view.layer.borderWidth = 2;
     [view.layer setBorderColor: [[UIColor blackColor] CGColor]];
     view.layer.cornerRadius = 8;
    [self.view addSubview:view];
     [collision addBoundaryWithIdentifier:[NSString stringWithFormat:@"%i", 15] forPath:[UIBezierPath bezierPathWithRect:view.frame]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
