//
//  seekImageView.m
//  seekRightAnswer
//
//  Created by lijinggang on 13-5-25.
//  Copyright (c) 2013年 JSSH. All rights reserved.
//

#import "seekImageView.h"

@implementation seekImageView
@synthesize  sign, delegate;
@synthesize fras;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if([self respondsToSelector:@selector(addClickAvatarEvent)])
            [self addClickAvatarEvent];
             
    }
    return self;
}

- (void)addClickAvatarEvent
{
    [self setUserInteractionEnabled:YES];
    //NSLog(@"self  == %@", self);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextClicked:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
}

-(void)setF:(CGRect)fra
{
    [self setFrame:CGRectMake(fra.origin.x, fra.origin.y, fra.size.width, fra.size.height)];
}

- (void)nextClicked:(id)sender
{
    NSLog(@"hello world----%ld  888888888888888%@", (long)self.tag, self);
    [self.delegate imageViewBetaped];
}


@end
