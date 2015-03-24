//
//  BallView.m
//  Dynamics-jingbo chu
//
//  Created by Stan on 11/21/14.
//  Copyright (c) 2014 UWL-Jingbo Chu. All rights reserved.
//

#import "BallView.h"

@implementation BallView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 36, 36)];
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = 18;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2;
    }
    return self;
}
@end
