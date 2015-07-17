//
//  ShearPhotographView.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/9.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "ShearPhotographView.h"
#import "PureLayout.h"
#import "UIImage+Custom.h"

#define CornerWidth 40
#define CornerHeight 40

@interface ShearPhotographView ()

@property (strong, nonatomic)UIImageView *mImageView;
@property (strong, nonatomic)UIView *mTopLineView;
@property (strong, nonatomic)UIView *mLeftLineView;
@property (strong, nonatomic)UIView *mRightLineView;
@property (strong, nonatomic)UIView *mBottomLineView;
@property (strong, nonatomic)UIView *mCropView;

@property (strong, nonatomic)UIImageView *mTopLeftCorner;
@property (strong, nonatomic)UIImageView *mTopRightCorner;
@property (strong, nonatomic)UIImageView *mBottomLeftCorner;
@property (strong, nonatomic)UIImageView *mBottomRightCorner;

@property (assign, nonatomic)CGPoint mPanGestureStartPoint;
@property (assign, nonatomic)BOOL mDidSetupConstraints;
@property (assign, nonatomic)CGPoint mTopLineCenter;
@property (assign, nonatomic)CGPoint mLeftLineCenter;
@property (assign, nonatomic)CGPoint mRightLineCenter;
@property (assign, nonatomic)CGPoint mBottomLineCenter;

@end

@implementation ShearPhotographView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.mImageView];
        [self addSubview:self.mCropView];
        [self addSubview:self.mTopLineView];
        [self addSubview:self.mLeftLineView];
        [self addSubview:self.mRightLineView];
        [self addSubview:self.mBottomLineView];
        [self addSubview:self.mTopLeftCorner];
        [self addSubview:self.mTopRightCorner];
        [self addSubview:self.mBottomLeftCorner];
        [self addSubview:self.mBottomRightCorner];
    }
    return self;
}



#pragma mark --setter and getter--
- (UIImageView *)mImageView
{
    if (!_mImageView)
    {
        _mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
        _mImageView.backgroundColor = [UIColor lightGrayColor];
        _mImageView.contentMode = UIViewContentModeCenter;
    }
    return _mImageView;
}

- (UIView *)mTopLineView
{
    if (!_mTopLineView)
    {
        _mTopLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _mTopLineView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(lineViewMoved:)];
        panGesture.enabled = YES;
        [_mTopLineView setUserInteractionEnabled:YES];
        [_mTopLineView addGestureRecognizer:panGesture];
    }
    return _mTopLineView;
}

- (UIView *)mLeftLineView
{
    if (!_mLeftLineView)
    {
        _mLeftLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _mLeftLineView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(lineViewMoved:)];
        panGesture.enabled = YES;
        [_mLeftLineView setUserInteractionEnabled:YES];
        [_mLeftLineView addGestureRecognizer:panGesture];
    }
    return _mLeftLineView;
}

- (UIView *)mRightLineView
{
    if (!_mRightLineView)
    {
        _mRightLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _mRightLineView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(lineViewMoved:)];
        panGesture.enabled = YES;
        [_mRightLineView setUserInteractionEnabled:YES];
        [_mRightLineView addGestureRecognizer:panGesture];
    }
    return _mRightLineView;
}

- (UIView *)mBottomLineView
{
    if (!_mBottomLineView)
    {
        _mBottomLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _mBottomLineView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(lineViewMoved:)];
        panGesture.enabled = YES;
        [_mBottomLineView setUserInteractionEnabled:YES];
        [_mBottomLineView addGestureRecognizer:panGesture];
    }
    return _mBottomLineView;
}

- (UIImageView *)mTopLeftCorner
{
    if (!_mTopLeftCorner)
    {
        _mTopLeftCorner = [[UIImageView alloc]initWithFrame:CGRectZero];
        _mTopLeftCorner.backgroundColor = [UIColor clearColor];
        _mTopLeftCorner.image = [UIImage imageNamed:@"cropArrowTopLeft"];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cornerViewMoved:)];
        panGesture.enabled = YES;
        [_mTopLeftCorner setUserInteractionEnabled:YES];
        [_mTopLeftCorner addGestureRecognizer:panGesture];
    }
    return _mTopLeftCorner;
}

- (UIImageView *)mTopRightCorner
{
    if (!_mTopRightCorner)
    {
        _mTopRightCorner = [[UIImageView alloc]initWithFrame:CGRectZero];
        _mTopRightCorner.backgroundColor = [UIColor clearColor];
        _mTopRightCorner.image = [UIImage imageNamed:@"cropArrowTopRight"];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cornerViewMoved:)];
        panGesture.enabled = YES;
        [_mTopRightCorner setUserInteractionEnabled:YES];
        [_mTopRightCorner addGestureRecognizer:panGesture];
    }
    return _mTopRightCorner;
}

- (UIImageView *)mBottomLeftCorner
{
    if (!_mBottomLeftCorner)
    {
        _mBottomLeftCorner = [[UIImageView alloc]initWithFrame:CGRectZero];
        _mBottomLeftCorner.backgroundColor = [UIColor clearColor];
        _mBottomLeftCorner.image = [UIImage imageNamed:@"cropArrowBottomLeft"];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cornerViewMoved:)];
        panGesture.enabled = YES;
        [_mBottomLeftCorner setUserInteractionEnabled:YES];
        [_mBottomLeftCorner addGestureRecognizer:panGesture];
    }
    return _mBottomLeftCorner;
}

- (UIImageView *)mBottomRightCorner
{
    if (!_mBottomRightCorner)
    {
        _mBottomRightCorner = [[UIImageView alloc]initWithFrame:CGRectZero];
        _mBottomRightCorner.backgroundColor = [UIColor clearColor];
        _mBottomRightCorner.image = [UIImage imageNamed:@"cropArrowBottomRight"];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cornerViewMoved:)];
        panGesture.enabled= YES;
        [_mBottomRightCorner setUserInteractionEnabled:YES];
        [_mBottomRightCorner addGestureRecognizer:panGesture];
    }
    return _mBottomRightCorner;
}

- (UIView *)mCropView
{
    if (!_mCropView)
    {
        _mCropView = [[UIView alloc]initWithFrame:CGRectZero];
        _mCropView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:.2];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cropViewMoved:)];
        panGesture.enabled= YES;
        [_mCropView setUserInteractionEnabled:YES];
        [_mCropView addGestureRecognizer:panGesture];
    }
    return _mCropView;
}


#pragma mark --action funtion--
- (void)lineViewMoved:(UIPanGestureRecognizer *)pan
{
    if (pan.state==UIGestureRecognizerStateBegan)
    {
        self.mPanGestureStartPoint = pan.view.frame.origin;
    }
    
    [self moveLineView:pan.view withPoint:[pan translationInView:self]];
    [self configureLinesAndCorners];
}

- (void)cornerViewMoved:(UIPanGestureRecognizer *)pan
{
    if (pan.state==UIGestureRecognizerStateBegan)
    {
        self.mPanGestureStartPoint = pan.view.frame.origin;
    }
    
    if (pan.view == self.mTopLeftCorner)
    {
        [self moveLineView:self.mLeftLineView withPoint:[pan translationInView:self]];
        [self moveLineView:self.mTopLineView withPoint:[pan translationInView:self]];
    }
    else if (pan.view == self.mTopRightCorner)
    {
        [self moveLineView:self.mTopLineView withPoint:[pan translationInView:self]];
        [self moveLineView:self.mRightLineView withPoint:[pan translationInView:self]];
    }
    else if (pan.view == self.mBottomLeftCorner)
    {
        [self moveLineView:self.mBottomLineView withPoint:[pan translationInView:self]];
        [self moveLineView:self.mLeftLineView withPoint:[pan translationInView:self]];
    }
    else if (pan.view == self.mBottomRightCorner)
    {
        [self moveLineView:self.mBottomLineView withPoint:[pan translationInView:self]];
        [self moveLineView:self.mRightLineView withPoint:[pan translationInView:self]];
    }
    
    [self configureLinesAndCorners];
}

- (void)cropViewMoved:(UIPanGestureRecognizer *)pan
{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.mPanGestureStartPoint = pan.view.frame.origin;
        self.mTopLineCenter = self.mTopLineView.center;
        self.mLeftLineCenter = self.mLeftLineView.center;
        self.mRightLineCenter = self.mRightLineView.center;
        self.mBottomLineCenter = self.mBottomLineView.center;
    }
  
    if (pan.view == self.mCropView) {
        CGPoint point = [self moveView:pan.view withPoint:[pan translationInView:self]];
        [self.mTopLineView setCenter:CGPointMake(self.mTopLineCenter.x+point.x, self.mTopLineCenter.y+point.y)];
        [self.mLeftLineView setCenter:CGPointMake(self.mLeftLineCenter.x+point.x, self.mLeftLineCenter.y+point.y)];
        [self.mRightLineView setCenter:CGPointMake(self.mRightLineCenter.x+point.x, self.mRightLineCenter.y+point.y)];
        [self.mBottomLineView setCenter:CGPointMake(self.mBottomLineCenter.x+point.x, self.mBottomLineCenter.y+point.y)];
        
    }
    [self configureLinesAndCorners];
}

#pragma mark --help function--

- (CGPoint)moveView:(UIView *)view withPoint:(CGPoint)point
{
    CGPoint offsetPoint = point;
    
    CGSize imageSize = self.mImageView.image.size;
    CGPoint imageCenter = self.mImageView.center;
    
    CGFloat maxMoveRight =  imageSize.width / 2 - (self.mRightLineCenter.x - imageCenter.x);
    CGFloat maxMoveLeft = -(imageSize.width / 2 - (imageCenter.x - self.mLeftLineCenter.x));
    CGFloat maxMoveUp = - (imageSize.height / 2 - (imageCenter.y - self.mTopLineCenter.y));
    CGFloat maxMoveDown = imageSize.height /2 - (self.mBottomLineCenter.y - imageCenter.y);
    
    if (point.x > 0)
    {
        if (point.x > maxMoveRight) {
            offsetPoint.x = maxMoveRight;
        }
    }
    else
    {
        if (point.x < maxMoveLeft) {
            offsetPoint.x = maxMoveLeft;
        }
    }
    
    if (point.y > 0) {
        if (point.y > maxMoveDown) {
            offsetPoint.y = maxMoveDown;
        }
    }
    else{
        if (point.y < maxMoveUp) {
            offsetPoint.y = maxMoveUp;
        }
    }
    return offsetPoint;
}

- (void)moveLineView:(UIView *)lineView withPoint:(CGPoint)point
{
    CGPoint finalPoint = CGPointZero;
    if (lineView == self.mTopLineView || lineView == self.mBottomLineView)
    {
        point = CGPointMake(lineView.frame.origin.x,point.y);
        finalPoint = CGPointMake(point.x,point.y + self.mPanGestureStartPoint.y);
    }
    else if (lineView == self.mLeftLineView || lineView == self.mRightLineView)
    {
        point = CGPointMake(point.x, lineView.frame.origin.y);
        finalPoint = CGPointMake(point.x + self.mPanGestureStartPoint.x,point.y);
    }
    else
    {
    
    }
    
    CGRect frame = lineView.frame;
    CGPoint imageCenter = self.mImageView.center;
    CGSize imageSize = self.mImageView.image.size;
    CGFloat halfWidth = CornerWidth / 2;
    
    if (lineView == self.mTopLineView)
    {
        CGFloat y = finalPoint.y;
        if (finalPoint.y < imageCenter.y - imageSize.height / 2 - CornerHeight / 2)
        {
            y = (imageCenter.y - imageSize.height / 2 - CornerHeight / 2);
        }
        else if (finalPoint.y > self.mBottomLineView.center.y - halfWidth * 3)
        {
            y = self.mBottomLineView.center.y - halfWidth * 3;
        }
        frame.origin.y = y;
    }
    else if (lineView == self.mBottomLineView)
    {
        CGFloat y = finalPoint.y;
        if (y > imageCenter.y + imageSize.height / 2 - CornerHeight / 2)
        {
            y = imageCenter.y + imageSize.height / 2 - CornerHeight / 2;
        }
        else if (y < self.mTopLineView.center.y + halfWidth)
        {
            y = self.mTopLineView.center.y + halfWidth;
        }
        frame.origin.y = y;
    }
    else if (lineView == self.mLeftLineView)
    {
        CGFloat x = finalPoint.x;
        if (x < imageCenter.x - imageSize.width / 2 - CornerWidth / 2)
        {
            x = imageCenter.x - imageSize.width / 2 - CornerWidth / 2;
        }
        else if (x > self.mRightLineView.center.x - 3 * halfWidth)
        {
            x =  self.mRightLineView.center.x - 3 * halfWidth;
        }
        frame.origin.x = x;
    }
    else if (lineView == self.mRightLineView)
    {
        CGFloat x = finalPoint.x;
        if (x < self.mLeftLineView.center.x + halfWidth)
        {
            x = self.mLeftLineView.center.x + halfWidth;
        }
        else if (x > imageCenter.x + imageSize.width / 2 - CornerWidth / 2)
        {
            x = imageCenter.x + imageSize.width / 2 - CornerWidth / 2;
        }
        frame.origin.x = x;
    }
    else{
        
    }
    
    lineView.frame = frame;
}

-(void)configureLinesAndCorners
{
    self.mTopLineView.frame= CGRectMake(self.mLeftLineView.center.x, self.mTopLineView.frame.origin.y, self.mRightLineView.center.x-self.mLeftLineView.center.x,self.mTopLineView.frame.size.height);
    self.mBottomLineView.frame= CGRectMake(self.mLeftLineView.center.x, self.mBottomLineView.frame.origin.y, self.mRightLineView.center.x-self.mLeftLineView.center.x,self.mBottomLineView.frame.size.height);
    self.mLeftLineView.frame = CGRectMake(self.mLeftLineView.frame.origin.x, self.mTopLineView.center.y, self.mLeftLineView.frame.size.width, self.mBottomLineView.center.y-self.mTopLineView.center.y);
    self.mRightLineView.frame = CGRectMake(self.mRightLineView.frame.origin.x, self.mTopLineView.center.y, self.mRightLineView.frame.size.width, self.mBottomLineView.center.y-self.mTopLineView.center.y);
    [self.mTopLeftCorner setCenter:CGPointMake(self.mLeftLineView.center.x, self.mTopLineView.center.y)];
    [self.mTopRightCorner setCenter:CGPointMake(self.mRightLineView.center.x, self.mTopLineView.center.y)];
    [self.mBottomLeftCorner setCenter:CGPointMake(self.mLeftLineView.center.x, self.mBottomLineView.center.y)];
    [self.mBottomRightCorner setCenter:CGPointMake(self.mRightLineView.center.x, self.mBottomLineView.center.y)];
    [self.mCropView setFrame:CGRectMake(self.mTopLeftCorner.center.x, self.mTopLeftCorner.center.y, self.mTopLineView.frame.size.width, self.mRightLineView.frame.size.height)];
}

- (CGRect) visibleRect{
    CGRect visibleRect;
    CGSize imageSize = self.mImageView.image.size;
    CGPoint imageCenter = self.mImageView.center;
    
    visibleRect.origin = CGPointMake(self.mLeftLineView.center.x - (imageCenter.x - imageSize.width / 2) ,self.mTopLineView.center.y - (imageCenter.y - imageSize.height / 2));
    visibleRect.size = CGSizeMake(self.mRightLineView.center.x-self.mLeftLineView.center.x, self.mBottomLineView.center.y-self.mTopLineView.center.y);
    return visibleRect;
}

#pragma mark --public function--
- (void)setSourceImage:(UIImage *)sourceImage
{
    if (sourceImage)
    {
        CGSize imageSize;
        self.originalImage = sourceImage;
        if (self.mImageView) {
            UIImage *scaleImage = [UIImage image:sourceImage ScaleToSize:self.mImageView.frame.size];
            self.mImageView.image = scaleImage;
            imageSize = scaleImage.size;
        }
        
        CGPoint imageCenter = self.mImageView.center;
        [self.mTopLineView setFrame:CGRectMake(imageCenter.x - imageSize.width / 2 - CornerWidth / 2, imageCenter.y - imageSize.height / 2 - CornerHeight / 2,imageSize.width , CornerHeight)];
        [self.mLeftLineView setFrame:CGRectMake(imageCenter.x - imageSize.width / 2 - CornerWidth / 2, imageCenter.y - imageSize.height / 2 - CornerHeight / 2, CornerWidth, imageSize.height)];
        [self.mRightLineView setFrame:CGRectMake(imageCenter.x + imageSize.width / 2 - CornerWidth / 2, imageCenter.y - imageSize.height / 2 - CornerHeight / 2 , CornerWidth, imageSize.height)];
        [self.mBottomLineView setFrame:CGRectMake(imageCenter.x + imageSize.width / 2 - CornerWidth / 2, imageCenter.y + imageSize.height / 2 - CornerHeight / 2, imageSize.width, CornerHeight)];
        
        [self.mTopLeftCorner setFrame:CGRectMake(imageCenter.x - imageSize.width / 2- CornerWidth / 2, imageCenter.y - imageSize.height / 2 - CornerHeight / 2,CornerWidth,CornerHeight)];
        [self.mTopRightCorner setFrame:CGRectMake(imageCenter.x + imageSize.width / 2 - CornerWidth / 2, imageCenter.y - imageSize.height / 2 - CornerHeight / 2, CornerWidth, CornerHeight)];
        [self.mBottomLeftCorner setFrame:CGRectMake(imageCenter.x - imageSize.width / 2 - CornerWidth / 2, imageCenter.y + imageSize.height / 2 - CornerHeight / 2, CornerWidth, CornerHeight)];
        [self.mBottomRightCorner setFrame:CGRectMake(imageCenter.x + imageSize.width /2 - CornerWidth / 2, imageCenter.y + imageSize.height /2 - CornerHeight / 2, CornerWidth, CornerHeight)];
        
        [self.mCropView setFrame:CGRectMake(self.mTopLeftCorner.center.x, self.mTopLeftCorner.center.y, self.mTopLineView.frame.size.width, self.mRightLineView.frame.size.height)];
    }
    else
    {
        
    }
}

- (UIImage *)getShearedImage
{
    CGRect rect = [self visibleRect];
    CGFloat koef_x =  self.originalImage.size.width/self.mImageView.image.size.width;
    CGFloat koef_y = self.originalImage.size.height/self.mImageView.image.size.height;
    CGRect finalImageRect = CGRectMake(rect.origin.x*koef_x, rect.origin.y*koef_y, rect.size.width*koef_x, rect.size.height*koef_y);
    UIImage *croppedImage = [self.originalImage imageAtRect:finalImageRect];
    return croppedImage;

}

@end
