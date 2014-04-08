//
//  seekImageView.h
//  seekRightAnswer
//
//  Created by lijinggang on 13-5-25.
//  Copyright (c) 2013年 JSSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "seekImageView.h"
@protocol seekImageViewdelegate

-(void)imageViewBetaped;

@end

@interface seekImageView : UIImageView
{
    id<seekImageViewdelegate>delegate;
    
    BOOL sign;//是否正确答案标记
}

@property(nonatomic, assign)id<seekImageViewdelegate>delegate;
@property(nonatomic, assign)BOOL sign;
@property(nonatomic, assign)CGRect fras;

- (void)nextClicked:(id)sender;

-(void)setF:(CGRect)fra;
@end
