//
//  BallPoolView.m
//  Dynamics-jingbo chu
//
//  Created by Stan on 11/21/14.
//  Copyright (c) 2014 UWL-Jingbo Chu. All rights reserved.
//

#import "BallPoolView.h"

@interface BallPoolView (){
    CATextLayer * textLayer;
}

@end

@implementation BallPoolView


- (void)drawRect:(CGRect)rect {
    
    [self.color set];
    [[UIBezierPath bezierPathWithOvalInRect: rect] fill];


    
    if(  self.number == 9 || self.number == 1){
        NSString * label = [NSString stringWithFormat:@"%i", self.number];
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByCharWrapping;
        style.alignment = NSTextAlignmentCenter;
        [label drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize: (rect.size.width - 7)], NSParagraphStyleAttributeName: style}];
    }else{
        textLayer = [[CATextLayer alloc] init];
        textLayer.string = [NSString stringWithFormat:@"%i", self.number];
        [textLayer setFontSize:(rect.size.width - 7 )];
        textLayer.borderColor = [[UIColor blackColor] CGColor];
        if( self.number >= 10 )
            textLayer.frame = CGRectMake(2, 1, 30, 30);
        else
            textLayer.frame = CGRectMake(7, 1, 22, 29);
        [self.layer addSublayer:textLayer];
    }
    
    
    
}

@end
