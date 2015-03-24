//
//  PoolBallViewController.m
//  Dynamics-jingbo chu
//
//  Created by Stan on 11/21/14.
//  Copyright (c) 2014 UWL-Jingbo Chu. All rights reserved.
//

#import "PoolBallViewController.h"
#import "BallPoolView.h"



@interface PoolBallViewController (){
    UIDynamicAnimator * animator;
    UIDynamicItemBehavior * itemBehavior;
    UICollisionBehavior * collision;
    UIAttachmentBehavior * panBehavior;
    float ball_size;
    NSMutableArray * balls;
    IBOutlet UIImageView *table;
    UIImageView * cue;
    
    CGPoint startPt;
    CGFloat angle;
    CGFloat offsetX,offsetY;
    CGFloat midX, midY;
}

@end

@implementation PoolBallViewController


-(void) reset{
    for( BallPoolView * ball in balls)
        [ball removeObserver:self forKeyPath:@"center"];
    [balls makeObjectsPerformSelector:@selector(removeFromSuperview)];
     [self.view setNeedsDisplay];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self reset];
    animator = [[UIDynamicAnimator alloc] initWithReferenceView: self.view];
    itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:nil];

    table.image = [UIImage imageNamed:@"PoolTable.jpg"];
    
    [self generateBall];
    CGRect rect = table.frame;
    
    collision = [[UICollisionBehavior alloc] initWithItems: balls];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    [collision addBoundaryWithIdentifier:@"top" fromPoint:CGPointMake(rect.origin.x + rect.size.width *0.16, rect.origin.y + rect.size.height/20) toPoint:CGPointMake(rect.origin.x + rect.size.width *0.84, rect.origin.y + rect.size.height/20)];
    [collision addBoundaryWithIdentifier:@"right1" fromPoint:CGPointMake(rect.origin.x + rect.size.width/11*10, rect.origin.y + rect.size.height*0.086) toPoint:CGPointMake(rect.origin.x + rect.size.width/11*10, rect.origin.y + rect.size.height/2.12)];
    [collision addBoundaryWithIdentifier:@"right2" fromPoint:CGPointMake(rect.origin.x + rect.size.width/11*10, rect.origin.y + rect.size.height/1.9) toPoint:CGPointMake(rect.origin.x + rect.size.width/11*10, rect.origin.y + rect.size.height*0.914)];
    [collision addBoundaryWithIdentifier:@"left1" fromPoint:CGPointMake(rect.origin.x + rect.size.width / 11, rect.origin.y +rect.size.height *0.086) toPoint:CGPointMake(rect.origin.x +rect.size.width / 11, rect.origin.y + rect.size.height/2.12)];
    [collision addBoundaryWithIdentifier:@"left2" fromPoint:CGPointMake(rect.origin.x + rect.size.width / 11, rect.origin.y +rect.size.height/1.9) toPoint:CGPointMake(rect.origin.x +rect.size.width / 11, rect.origin.y + rect.size.height*0.914)];
    [collision addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(rect.origin.x+rect.size.width *0.16, rect.origin.y + rect.size.height/20*19) toPoint:CGPointMake(rect.origin.x + rect.size.width * 0.84, rect.origin.y + rect.size.height/20*19)];
    
    
    itemBehavior.resistance = 0.6;
    itemBehavior.angularResistance = 0.5;
    itemBehavior.elasticity = 1.0;
    [animator addBehavior:itemBehavior];
    [animator addBehavior: collision];
    
    for( BallPoolView * ball in balls ){
        [ball addObserver:self
               forKeyPath:@"center" options:0 context:nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    BallPoolView * ball = (BallPoolView *) object;
    UIAlertView * alert;
    if(ball.frame.origin.x + ball_size/2 <= table.frame.origin.x + table.frame.size.width/11|| ball.frame.origin.x  + ball_size/2>= table.frame.origin.x + table.frame.size.width/11 *10){
        //[ball removeObserver:self forKeyPath:@"center"];
        [ball removeFromSuperview];
        [itemBehavior removeItem:ball];
        [collision removeItem:ball];
        [self.view setNeedsDisplay];
        if( ball.number == 0){
             alert = [[UIAlertView alloc] initWithTitle:@"Pool Ball Game" message:@"GAME OVER." delegate:self cancelButtonTitle:@"Try Again." otherButtonTitles:nil, nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        }
    }
    if(ball.frame.origin.y + ball_size/2 <= table.frame.origin.y + table.frame.size.height/20|| ball.frame.origin.y  + ball_size/2 >= table.frame.origin.y + table.frame.size.height/20 *19){
        //[ball removeObserver:self forKeyPath:@"center"];
        [ball removeFromSuperview];
        [itemBehavior removeItem:ball];
        [collision removeItem:ball];
        [self.view setNeedsDisplay];
        if( ball.number == 0 && !alert ){
             alert = [[UIAlertView alloc] initWithTitle:@"Pool Ball Game" message:@"GAME OVER." delegate:self cancelButtonTitle:@"Try again." otherButtonTitles:nil, nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        }
    }
}

-(void) generateBall{
    
    balls = [[NSMutableArray alloc] initWithCapacity:15];
    CGRect rect = table.frame;
    NSLog(@"table size x:%f y:%f width:%f height:%f ", rect.origin.x,rect.origin.y, rect.size.width,rect.size.height);
    ball_size = rect.size.width / 16;
    
    CGPoint center = CGPointMake(rect.size.width /2 + rect.origin.x - ball_size/2, rect.origin.y + rect.size.height / 3.7 -ball_size/2);

    //addd black 8
    BallPoolView * black8 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x, center.y, ball_size, ball_size)];
    black8.color = [UIColor blackColor];
    black8.opaque = NO;
    black8.number = 8;
    [self.view addSubview:black8];
    [balls addObject:black8];
    [itemBehavior addItem:black8];
    
    //add blue 2
    BallPoolView * blue2 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x - ball_size, center.y,ball_size, ball_size)];
    blue2.color = [UIColor blueColor];
    blue2.opaque = NO;
    blue2.number = 2;
    [self.view addSubview:blue2];
    [balls addObject:blue2];
    [itemBehavior addItem:blue2];
    
    //add purple 4
    BallPoolView * purple4 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x + ball_size, center.y, ball_size, ball_size)];
    purple4.color = [UIColor purpleColor];
    purple4.opaque = NO;
    purple4.number = 4;
    [self.view addSubview:purple4];
    [balls addObject:purple4];
    [itemBehavior addItem:purple4];
    
    center = CGPointMake(center.x -ball_size/2, center.y  + ball_size);
    
    //add orange 11
    BallPoolView * orange11 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x , center.y, ball_size, ball_size)];
    orange11.color = [UIColor redColor];
    orange11.opaque = NO;
    orange11.number = 11;
    [self.view addSubview:orange11];
    [balls addObject:orange11];
    [itemBehavior addItem:orange11];
    
    //add blue 10
    BallPoolView * blue10 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x + ball_size, center.y, ball_size, ball_size)];
    blue10.color = [UIColor blueColor];
    blue10.opaque = NO;
    blue10.number = 10;
    [self.view addSubview:blue10];
    [balls addObject:blue10];
    [itemBehavior addItem:blue10];
    
    //add yellow 1
    BallPoolView * yellow1 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x + ball_size/2, center.y + ball_size - 1, ball_size, ball_size)];
    yellow1.color = [UIColor yellowColor];
    yellow1.opaque = NO;
    yellow1.number = 1;
    [self.view addSubview:yellow1];
    [balls addObject:yellow1];
    [itemBehavior addItem:yellow1];
    
    center = CGPointMake(rect.size.width /2 + rect.origin.x - ball_size/2, rect.origin.y + rect.size.height / 3.6 -ball_size/2 - 2 * ball_size);
    
    //add green 6
    BallPoolView * green6 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x , center.y +1, ball_size, ball_size)];
    green6.color =  [UIColor colorWithRed:10.0/255.0 green:110.0/255.0 blue:10.0/255.0 alpha:1.0];
    green6.opaque = NO;
    green6.number = 6;
    [self.view addSubview:green6];
    [balls addObject:green6];
    [itemBehavior addItem:green6];
    
    //add orange 13
    BallPoolView * orange13 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x - ball_size, center.y +1, ball_size, ball_size)];
    orange13.color =  [UIColor orangeColor];
    orange13.opaque = NO;
    orange13.number = 13;
    [self.view addSubview:orange13];
    [balls addObject:orange13];
    [itemBehavior addItem:orange13];
    
    //add red 3
    BallPoolView * red3 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x - 2*ball_size, center.y +1, ball_size, ball_size)];
    red3.color =  [UIColor redColor];
    red3.opaque = NO;
    red3.number = 3;
    [self.view addSubview:red3];
    [balls addObject:red3];
    [itemBehavior addItem:red3];
    
    //add  soild 15
    BallPoolView * soild15 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x + ball_size, center.y +1, ball_size, ball_size)];
    soild15.color =  [UIColor colorWithRed:130.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0];
    soild15.opaque = NO;
    soild15.number = 15;
    [self.view addSubview:soild15];
    [balls addObject:soild15];
    [itemBehavior addItem:soild15];
    
    //add  orange 5
    BallPoolView * orange5 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x + 2*ball_size, center.y +1, ball_size, ball_size)];
    orange5.color =  [UIColor orangeColor];
    orange5.opaque = NO;
    orange5.number = 5;
    [self.view addSubview:orange5];
    [balls addObject:orange5];
    [itemBehavior addItem:orange5];
    
    center = CGPointMake(center.x - ball_size/2, center.y + ball_size);
    
    //add  soild 7
    BallPoolView * soild7 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x , center.y +1, ball_size, ball_size)];
    soild7.color =  [UIColor colorWithRed:130.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0];
    soild7.opaque = NO;
    soild7.number = 7;
    [self.view addSubview:soild7];
    [balls addObject:soild7];
    [itemBehavior addItem:soild7];
    
    //add green 14
    BallPoolView * green14 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x + 2*ball_size, center.y +1, ball_size, ball_size)];
    green14.color =  [UIColor colorWithRed:10.0/255.0 green:110.0/255.0 blue:10.0/255.0 alpha:1.0];
    green14.opaque = NO;
    green14.number = 14;
    [self.view addSubview:green14];
    [balls addObject:green14];
    [itemBehavior addItem:green14];
    
    //add yellow 9
    BallPoolView * yellow9 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x + ball_size, center.y +1, ball_size, ball_size)];
    yellow9.color =  [UIColor yellowColor];
    yellow9.opaque = NO;
    yellow9.number = 9;
    [self.view addSubview:yellow9];
    [balls addObject:yellow9];
    [itemBehavior addItem:yellow9];
    
    //add purple 12
    BallPoolView * purple12 = [[BallPoolView alloc] initWithFrame:CGRectMake(center.x - ball_size, center.y, ball_size, ball_size)];
    purple12.color = [UIColor purpleColor];
    purple12.opaque = NO;
    purple12.number = 12;
    [self.view addSubview:purple12];
    [balls addObject:purple12];
    [itemBehavior addItem:purple12];
    
    
    BallPoolView * white0 = [[BallPoolView alloc] initWithFrame:CGRectMake(rect.origin.x + rect.size.width/2 - ball_size/2, rect.origin.y + rect.size.height / 3.3 * 2.3,ball_size, ball_size)];
    white0.color = [UIColor whiteColor];
    white0.opaque = NO;
    white0.number = 0;
        [balls addObject:white0];
    [white0 addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handlePan:)]];
    

    [self.view addSubview:white0];
    [itemBehavior addItem:white0];

}

- (void) handlePan: (UIPanGestureRecognizer *) gesture {
    CGPoint touchPt = [gesture locationInView: nil];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            startPt = [[balls lastObject] center];
            
            cue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cue.jpg"]];
            cue.frame = CGRectMake(touchPt.x, touchPt.y, 5,140);
            [self.view addSubview:cue];
            
//            if (panBehavior) NSLog(@"panBehavior not removed");
//            panBehavior = [[UIAttachmentBehavior alloc] initWithItem: gesture.view offsetFromCenter: UIOffsetMake(offsetPt.x,offsetPt.y) attachedToAnchor: touchPt];
//            NSLog( @"pt x:%f y:%f vel x:%f y :%f", touchPt.x, touchPt.y, velocity.x, velocity.y);
//            [animator addBehavior: panBehavior];
        } break;
        case UIGestureRecognizerStateChanged: {
            //panBehavior.anchorPoint = touchPt;
            [cue removeFromSuperview];
            
            cue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cue.jpg"]];

            offsetX = touchPt.x - startPt.x;
            offsetY = touchPt.y - startPt.y;
            
            //calculate angle
            if( offsetX < 0 ){
                if( offsetY < 0 ){
                    NSLog(@"WestNorth");
                    angle =  M_PI  - atan((double)offsetX/ (double)offsetY );
                }
                else{
                    NSLog(@"Westsouth");
                    angle = atan((double)-offsetX/(double)offsetY);
                    
                }
            }else{
                if( offsetY > 0 ){
                    NSLog(@"EastSouth");
                    angle = 2 * M_PI - atan((double)offsetX/(double)offsetY);
                }else{
                    NSLog(@"EastNorth");
                    angle = M_PI + atan((double)-offsetX/(double)offsetY);

                }
            }
            
            cue.autoresizesSubviews=NO;
            midX = touchPt.x + offsetX/sqrt(offsetX*offsetX+offsetY*offsetY)*70;
            midY = touchPt.y + offsetY/sqrt(offsetX*offsetX+offsetY*offsetY)*70;
            cue.frame = CGRectMake(midX - 3, midY - 70, 5,140);
            [self.view addSubview:cue];
            CGAffineTransform currentTransform = cue.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, angle);
            cue.transform = newTransform;
        } break;
        default: {
//            midX = startPt.x + offsetX/sqrt(offsetX*offsetX+offsetY*offsetY)*(70+ball_size/2) ;
//            midY = startPt.y + offsetY/sqrt(offsetX*offsetX+offsetY*offsetY)*(70+ball_size/2);
//            [UIView animateWithDuration:0.8 delay:0.1 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionTransitionNone animations:^{
//                cue.frame = CGRectMake(midX, midY - 70, 5,140);
//            } completion:^(BOOL finished) {
//                [cue removeFromSuperview];
//                [itemBehavior addLinearVelocity: CGPointMake(-offsetX *10, -offsetY*10) forItem: gesture.view];
//            }];
            cue.frame = CGRectMake(midX, midY - 70, 5,140);
            [cue removeFromSuperview];
            [itemBehavior addLinearVelocity: CGPointMake(-offsetX *10, -offsetY*10) forItem: gesture.view];

        } break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tap:( UIGestureRecognizer *) gesture{
    CGPoint pt = [gesture locationInView: [[self.view subviews] lastObject]];
    NSLog(@"tap x:%f y:%f", pt.x, pt.y);
}

@end
