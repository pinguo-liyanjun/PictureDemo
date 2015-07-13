//
//  StickerPhotographView.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/12.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "StickerPhotographView.h"
#import "UIImage+Custom.h"


@interface StickerPhotographView ()

@property (strong, nonatomic)UIImageView *mImageView;
@property (strong, nonatomic)UIView *mTopLineView;
@property (strong, nonatomic)UIView *mLeftLineView;
@property (strong, nonatomic)UIView *mRightLineView;
@property (strong, nonatomic)UIView *mBottomLineView;
@property (strong, nonatomic)UIView *mRectangleCropView;

@property (strong, nonatomic)UIImageView *mTopLeftCorner;
@property (strong, nonatomic)UIImageView *mTopRightCorner;
@property (strong, nonatomic)UIImageView *mBottomLeftCorner;
@property (strong, nonatomic)UIImageView *mBottomRightCorner;

@property (strong, nonatomic)UIView *mCircleCropView;

@property (assign, nonatomic)CGPoint mPanGestureStartPoint;
@property (assign, nonatomic)BOOL mDidSetupConstraints;
@property (assign, nonatomic)CGPoint mTopLineCenter;
@property (assign, nonatomic)CGPoint mLeftLineCenter;
@property (assign, nonatomic)CGPoint mRightLineCenter;
@property (assign, nonatomic)CGPoint mBottomLineCenter;

@end

@implementation StickerPhotographView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mImageView];
        [self addSubview:self.mRectangleCropView];
        [self addSubview:self.mCircleCropView];
        [self addSubview:self.mTopLineView];
        [self addSubview:self.mLeftLineView];
        [self addSubview:self.mRightLineView];
        [self addSubview:self.mBottomLineView];
        [self addSubview:self.mTopLeftCorner];
        [self addSubview:self.mTopRightCorner];
        [self addSubview:self.mBottomLeftCorner];
        [self addSubview:self.mBottomRightCorner];
    }
    [self setNeedsUpdateConstraints];
    
    return self;
}

- (void)updateConstraints
{
    
    [super updateConstraints];
}

#pragma mark --setter and getter--
- (UIImageView *)mImageView
{
    if (!_mImageView)
    {
        _mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _mImageView.backgroundColor = [UIColor whiteColor];
    }
    return _mImageView;
}

- (UIView *)mTopLineView
{
    if (!_mTopLineView)
    {
        _mTopLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
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
        _mLeftLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(self.mImageView.frame))];
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
        _mRightLineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-40, 0, 40, CGRectGetHeight(self.mImageView.frame))];
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
        _mBottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.mImageView.frame)-40, CGRectGetWidth(self.frame), 40)];
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
        _mTopLeftCorner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
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
        _mTopRightCorner = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-40, 0, 40, 40)];
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
        _mBottomLeftCorner = [[UIImageView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.mImageView.frame)-40, 40, 40)];
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
        _mBottomRightCorner = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-40, CGRectGetHeight(self.mImageView.frame)-40, 40, 40)];
        _mBottomRightCorner.backgroundColor = [UIColor clearColor];
        _mBottomRightCorner.image = [UIImage imageNamed:@"cropArrowBottomRight"];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cornerViewMoved:)];
        panGesture.enabled= YES;
        [_mBottomRightCorner setUserInteractionEnabled:YES];
        [_mBottomRightCorner addGestureRecognizer:panGesture];
    }
    return _mBottomRightCorner;
}

- (UIView *)mRectangleCropView
{
    if (!_mRectangleCropView)
    {
        _mRectangleCropView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.mImageView.frame)-20)];
        _mRectangleCropView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cropViewMoved:)];
        panGesture.enabled= YES;
        [_mRectangleCropView setUserInteractionEnabled:YES];
        [_mRectangleCropView addGestureRecognizer:panGesture];
    }
    return _mRectangleCropView;
}

- (UIView *)mCircleCropView
{
    if (!_mCircleCropView) {
        _mCircleCropView = [[UIView alloc]initWithFrame:CGRectMake(10, 10,CGRectGetWidth(self.frame)-20 , CGRectGetHeight(self.mImageView.frame)-20)];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cropViewMoved:)];
        panGesture.enabled= YES;
        [_mCircleCropView setUserInteractionEnabled:YES];
        [_mCircleCropView addGestureRecognizer:panGesture];
    }
    return _mCircleCropView;
}

- (void)setStickerType:(StickerPhotographType)stickerType
{
    if (_stickerType != stickerType)
    {
        _stickerType = stickerType;
    }
    
    if (stickerType == StickerPhotographType_Circle)
    {
        self.mRectangleCropView.hidden = YES;
        self.mCircleCropView.hidden = NO;
    }
    else if (stickerType == StickerPhotographType_Ractangle)
    {
        self.mRectangleCropView.hidden = NO;
        self.mCircleCropView.hidden = YES;
    }
    else if (stickerType == StickerPhotographType_Circle_Ractangle)
    {
        self.mCircleCropView.hidden = NO;
        self.mRectangleCropView.hidden = NO;
    }
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
    NSLog(@"origin point :%f,%f",self.mPanGestureStartPoint.x,self.mPanGestureStartPoint.y);
    
    if (pan.view == self.mRectangleCropView || pan.view == self.mCircleCropView) {
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
    CGFloat maxMoveRight = CGRectGetMaxX(self.mImageView.frame)-self.mRightLineCenter.x;
    CGFloat maxMoveLeft = -self.mLeftLineCenter.x;
    CGFloat maxMoveUp = -self.mTopLineCenter.y;
    CGFloat maxMoveDown = CGRectGetMaxY(self.mImageView.frame)-self.mBottomLineCenter.y;
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
    CGPoint finalPoint;
    if (lineView == self.mTopLineView || lineView == self.mBottomLineView)
    {
        point = CGPointMake(lineView.frame.origin.x,point.y);
        finalPoint = CGPointMake(point.x,point.y+self.mPanGestureStartPoint.y);
    }
    else if (lineView == self.mLeftLineView || lineView == self.mRightLineView)
    {
        point = CGPointMake(point.x, lineView.frame.origin.y);
        finalPoint = CGPointMake(point.x+self.mPanGestureStartPoint.x,point.y);
    }
    
    CGRect frame = lineView.frame;
    CGFloat halfWidth = self.mLeftLineView.frame.size.width/2;
    if (lineView == self.mTopLineView)
    {
        CGFloat y = finalPoint.y;
        if (finalPoint.y < -halfWidth)
        {
            y = -halfWidth;
        }
        else if (finalPoint.y > self.mBottomLineView.center.y-halfWidth*3)
        {
            y = self.mBottomLineView.center.y-halfWidth*3;
        }
        frame.origin.y = y;
    }
    else if (lineView == self.mBottomLineView)
    {
        CGFloat y = finalPoint.y;
        if (y > self.mImageView.frame.size.height - halfWidth)
        {
            y = self.mImageView.frame.size.height - halfWidth;
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
        if (x < -halfWidth)
        {
            x = -halfWidth;
        }
        else if (x > self.mRightLineView.center.x-3*halfWidth)
        {
            x =  self.mRightLineView.center.x-3*halfWidth;
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
        else if (x > self.mImageView.frame.size.width - halfWidth)
        {
            x = self.mImageView.frame.size.width - halfWidth;
        }
        frame.origin.x = x;
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
    
    if (self.stickerType == StickerPhotographType_Circle)
    {
        [self.mCircleCropView setFrame:CGRectMake(self.mTopLeftCorner.center.x, self.mTopLeftCorner.center.y, self.mTopLineView.frame.size.width, self.mRightLineView.frame.size.height)];
    }
    else if (self.stickerType == StickerPhotographType_Ractangle)
    {
        [self.mRectangleCropView setFrame:CGRectMake(self.mTopLeftCorner.center.x, self.mTopLeftCorner.center.y, self.mTopLineView.frame.size.width, self.mRightLineView.frame.size.height)];
    }
    else
    {
        
    }
    
}

#pragma mark --public function--

- (void)setSourceImage:(UIImage *)sourceImage
{
    if (sourceImage)
    {
        self.originalImage = sourceImage;
        if (self.mImageView) {
            self.mImageView.image = sourceImage;
        }
    }
}

- (UIImage *)getStickerPhotographImage
{
    UIImage *image ;
    CGFloat koef_x =  self.originalImage.size.width/self.mImageView.frame.size.width;
    CGFloat koef_y = self.originalImage.size.height/self.mImageView.frame.size.height;
    if (self.stickerType == StickerPhotographType_Circle)
    {
        CGFloat circleRadius = MIN(self.mCircleCropView.frame.size.width * koef_x, self.mCircleCropView.frame.size.height * koef_y) * 0.5;
        image = [UIImage circleImageWithName:self.originalImage circleCenter:CGPointMake(self.mCircleCropView.center.x * koef_x, self.mCircleCropView.center.y * koef_y)  circleRadius:circleRadius  borderWidth:2 borderColor:[UIColor greenColor]];
    }
    else if (self.stickerType == StickerPhotographType_Ractangle)
    {
        image = [UIImage rectangleImageWithName:self.originalImage andWithFrame:CGRectMake(self.mRectangleCropView.frame.origin.x * koef_x, self.mRectangleCropView.frame.origin.y * koef_y, self.mRectangleCropView.frame.size.width * koef_x, self.mRectangleCropView.frame.size.height * koef_y) borderWidth:2 borderColor:[UIColor greenColor]];
    }
    else if(self.stickerType == StickerPhotographType_Circle_Ractangle)
    {
        CGFloat circleRadius = MIN(self.mCircleCropView.frame.size.width * koef_x, self.mCircleCropView.frame.size.height * koef_y) * 0.5;
        image = [UIImage circleAndRectangleImageWithName:self.originalImage circleCenter:CGPointMake(self.mCircleCropView.center.x * koef_x, self.mCircleCropView.center.y * koef_y) circleRadius:circleRadius frame:CGRectMake(self.mRectangleCropView.frame.origin.x * koef_x, self.mRectangleCropView.frame.origin.y * koef_y, self.mRectangleCropView.frame.size.width * koef_x, self.mRectangleCropView.frame.size.height * koef_y) borderWidth:2 borderColor:[UIColor greenColor]];
    }
    else{
        image = self.originalImage;
    }
    return image;
}

@end
