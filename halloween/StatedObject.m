//
//  StatedObject.m
//  StrangeParcel
//

#import "StatedObject.h"
#import "Utils.h"
#import "NNKObjectState.h"
#import "NNKObjectAction.h"

CGFloat defaultAnimationDuration = 1;

NSString *const NNKSoundFormat = @"mp3";
extern NSString *const NNKSelector;
extern NSString *const NNKRiseActionObjectId;

@interface StatedObject () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NNKObjectState *currentState;

@property (assign, nonatomic) NSInteger currentStateIndex;
@property (assign, nonatomic) NSInteger currentImageIndex;
@property (assign, nonatomic) NSInteger repeatCount;

@property (strong, nonatomic) NSTimer *animationTimer;

@property (assign, nonatomic) BOOL playAnimationForward;
@property (assign, nonatomic) BOOL soundStateOn;

@property (strong, nonatomic) AVAudioPlayer *animationSoundPlayer;

@property (assign, nonatomic) CGFloat lastScale;
@property (assign, nonatomic) CGFloat lastRotation;
@property (assign, nonatomic) CGFloat firstX;
@property (assign, nonatomic) CGFloat firstY;

@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation StatedObject

#pragma mark - Life Cycle

- (id)initWithParameters:(NNKObjectParameters *)parameters delegate:(UIViewController<StatedObjectDelegate> *)aDelegate {
    CGRect frame = parameters.frame;
    if (self = [super initWithFrame:frame]) {
        self.adjustsImageWhenHighlighted = NO;
        _parameters = parameters;
        _delegate = aDelegate;
        _currentStateIndex = 0;
        [self setupStateSettingsToDefault];

        [_delegate.view addSubview:self];
        
    }

    return self;
}


#pragma mark - Custom Accesors

- (NNKObjectState *)currentState {
    if ([self.parameters.states count] > self.currentStateIndex) {
        return self.parameters.states[self.currentStateIndex];
    } else {
        return nil;
    }
}


- (AVAudioPlayer *)animationSoundPlayer {
    if (_animationSoundPlayer) return _animationSoundPlayer;
    NSString *soundName = self.currentState.soundPath;
    if (!soundName) return nil;

    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:NNKSoundFormat];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    _animationSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    _animationSoundPlayer.volume = self.soundStateOn ? 1 : 0;
    [_animationSoundPlayer prepareToPlay];

    return _animationSoundPlayer;
}


- (UIPinchGestureRecognizer *)pinchRecognizer {
    if (!_pinchRecognizer) {
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        _pinchRecognizer.delegate = self;
    }

    return _pinchRecognizer;
}


- (UIPanGestureRecognizer *)panRecognizer {
    if (!_panRecognizer) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        _panRecognizer.minimumNumberOfTouches = 1;
        _panRecognizer.maximumNumberOfTouches = 1;
        _panRecognizer.delegate = self;
    }

    return _panRecognizer;
}


- (UIRotationGestureRecognizer *)rotationRecognizer {
    if (!_rotationRecognizer) {
        _rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
        _rotationRecognizer.delegate = self;
    }

    return _rotationRecognizer;
}


- (UITapGestureRecognizer *)tapRecognizer {
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _tapRecognizer.numberOfTapsRequired = 1;
        _tapRecognizer.delegate = self;
    }

    return _tapRecognizer;
}


#pragma  mark - Actions

- (void)scale:(UIPinchGestureRecognizer *)sender {
    [self.delegate objectInteracted:self];
    [self.delegate.view bringSubviewToFront:self];
    [self resetAnimationTimer];
    if ([sender state] == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
    }
    [self setupHighlightedImageIfExists];

    CGFloat scale = 1.0 - (self.lastScale - [sender scale]);
    CGAffineTransform currentTransform = self.transform;

    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    if (newTransform.a > 2.f) {
        newTransform.a = 2.f;
        newTransform.d = 2.f;
    }
    if (newTransform.a < 0.5f) {
        newTransform.a = 0.5f;
        newTransform.d = 0.5f;
    }
    [self setTransform:newTransform];
    
    self.lastScale = [sender scale];
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self performActions];
    }
}


- (void)rotate:(UIRotationGestureRecognizer *)sender {
    [self.delegate objectInteracted:self];
    [self.delegate.view bringSubviewToFront:self];
    [self resetAnimationTimer];
    if ([sender state] == UIGestureRecognizerStateBegan) {
    }
    [self setupHighlightedImageIfExists];
    if ([sender state] == UIGestureRecognizerStateEnded) {
        self.lastRotation = 0.0;
        [self performActions];
        return;
    }

    
    CGFloat rotation = 0.0 - (self.lastRotation - [sender rotation]);

    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);

    [self setTransform:newTransform];
    
    self.lastRotation = [sender rotation];

}


- (void)move:(UIPanGestureRecognizer *)sender {
    [self.delegate objectInteracted:self];
    [self.delegate.view bringSubviewToFront:self];
    [self resetAnimationTimer];
    CGPoint translatedPoint = [sender translationInView:self.superview];
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        self.firstX = [self center].x;
        self.firstY = [self center].y;
    }
    [self setupHighlightedImageIfExists];

    translatedPoint = CGPointMake(self.firstX + translatedPoint.x, self.firstY + translatedPoint.y);
    
    [self setCenter:translatedPoint];
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self performActions];
    }

}


- (void)tapped:(UITapGestureRecognizer *)sender {
    [self performActions];
    [self.delegate.view bringSubviewToFront:self];
}


- (void)nextState:(NSDictionary *)actionDictionary {
    [self nextState];
}


- (void)playAnimation:(NSDictionary *)actionDictionary {
    [self playAnimation];
}


- (void)fireActionInObject:(NSDictionary *)actionDictionary {
    [self.delegate fireSelector:actionDictionary[NNKSelector] inObjectId:actionDictionary[NNKRiseActionObjectId]];
}


#pragma mark - Public Methods

- (void)cleanResources {
    self.parameters.animationImages = nil;
    [self resetAnimationTimer];
    [self resetAnimationSoundPlayer];
    [self removeFromSuperview];
}


- (void)stopAnimation {
    [self resetAnimationDefaults];
    [self resetAnimationSoundPlayer];
    [self resetAnimationTimer];
    [self setupImageToCurrentImageIndex];
}


#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}


#pragma mark - Custom Setups

- (void)setupStateSettingsToDefault {
    self.repeatCount = self.currentState.repeatCount;
    [self resetAnimationDefaults];
    [self setupGesturesRecognizer];
    [self resetAnimationSoundPlayer];
    self.animationSoundPlayer = [self createSoundPlayer];
    [self setupBackgroundImage];
    [self parseActions:self.currentState.actionsOnInitState];
    [self setupImageToCurrentImageIndex];
    
    self.userInteractionEnabled = self.currentState.interactive;
    self.hidden = self.currentState.hidden;
    
    if (self.currentState.animateOnStart) [self playAnimationCycle];
    if (self.currentState.animateWithDelay) {
        [self performSelector:@selector(playAnimationCycle) withObject:nil afterDelay:0.7];
    }
}


- (void)setupGesturesRecognizer {
    [self addGestureRecognizer:self.tapRecognizer];
    
    if (self.currentState.scaleble) {
        [self addGestureRecognizer:self.pinchRecognizer];
    } else {
        [self removeGestureRecognizer:self.pinchRecognizer];
    }
    
    if (self.currentState.rotateble) {
        [self addGestureRecognizer:self.rotationRecognizer];
    } else {
        [self removeGestureRecognizer:self.rotationRecognizer];
    }
    
    if (self.currentState.dragable) {
        [self addGestureRecognizer:self.panRecognizer];
    } else {
        [self removeGestureRecognizer:self.panRecognizer];
    }
}


- (void)setupBackgroundImage {
    NSString *backgroundImageName = self.currentState.backgroundImage;
    if (backgroundImageName) {
        UIImage *backgroundImage = [UIImage imageNamed:backgroundImageName];
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
}


- (void)setupImageToCurrentImageIndex {
    UIImage *image = self.parameters.animationImages[self.currentImageIndex];
    [self setImage:image forState:UIControlStateNormal];
}


- (void)setupHighlightedImageIfExists {
    if (self.currentState.highlightedImage) {
        UIImage *image = [UIImage imageNamed:self.currentState.highlightedImage];
        [self setImage:image forState:UIControlStateNormal];
    }
}


#pragma mark - Private Methods

- (void)resetAnimationSoundPlayer {
    [self.animationSoundPlayer stop];
}


- (AVAudioPlayer *)createSoundPlayer {
    NSString *soundName = self.currentState.soundPath;
    if (!soundName) return nil;
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:NNKSoundFormat];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    [player prepareToPlay];
	
	return player;
}


- (void)resetAnimationTimer {
    [self.animationTimer invalidate];
}


- (void)resetAnimationDefaults {
    self.playAnimationForward = !self.currentState.backward;
    if (self.playAnimationForward) {
        self.currentImageIndex = self.currentState.firstFrameIndex;
    } else {
        self.currentImageIndex = self.currentState.lastFrameIndex;
    }
}


- (void)performActions {
    if ([self shouldRemoveFromScreen:self.center]) {
        [self cleanResources];
        return;
    }
    [self parseActions:self.currentState.actions];
}


- (void)parseActions:(NSArray *)actionsArray {
    if (!actionsArray) {
        return;
    }
    for (NNKObjectAction *action in actionsArray) {
        [self performSelectorOnMainThread:NSSelectorFromString(action.actionBehavior)
                               withObject:action
                            waitUntilDone:NO];
    }
}


- (void)playAnimation {
    [self playAnimationCycle];
}


- (void)playAnimationCycle {
    [self resetAnimationDefaults];
    [self resetAnimationTimer];
    [self startAnimationTimer];
    [self playAnimationSound];
}


- (void)startAnimationTimer {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentState.frameDuration
                                                           target:self
                                                         selector:@selector(changeFrame)
                                                         userInfo:nil
                                                          repeats:YES];
}


- (void)playAnimationSound {
    [self.animationSoundPlayer setCurrentTime:0.0f];
    [self.animationSoundPlayer play];
}


- (void)changeFrame {
    if ((!self.playAnimationForward || self.currentImageIndex  <= self.currentState.lastFrameIndex) &&
        (self.playAnimationForward || self.currentImageIndex  > 1)) {
        [self makeStep];

        return;
    }

    if (self.currentState.autoreverse && self.playAnimationForward == !self.currentState.backward) {
        self.playAnimationForward = self.currentState.backward;
        [self makeStep];
        if (self.currentState.autoreverseSound) [self playAnimationSound];
    } else {
        [self checkAndRunAnimationCycle];
    }
}


- (void)makeStep {
    self.playAnimationForward ? self.currentImageIndex++ : self.currentImageIndex--;
    UIImage *image = self.parameters.animationImages[self.currentImageIndex - 1];
    [self setImage:image forState:UIControlStateNormal];
}


- (void)checkAndRunAnimationCycle {
    if (!self.currentState.idle) {
        self.repeatCount--;
    }

    if (self.repeatCount > 0) {
        [self playAnimationCycle];
        return;
    }

    if (self.currentState.autoTransition) {
        [self nextState];
        [self resetAnimationTimer];
        return;
    }
    
    self.repeatCount = self.currentState.repeatCount;
    if (self.currentState.setDefaultImageAfterFinishAnimation) {
        [self resetAnimationDefaults];
        [self setupImageToCurrentImageIndex];
    }
    [self resetAnimationTimer];
}


- (void)nextState {
    NSString *directTransitionState = self.currentState.transitionState;
    if (directTransitionState) {
        self.currentStateIndex = [directTransitionState integerValue];
        [self setupStateSettingsToDefault];
    } else {
        self.currentStateIndex++;
        if ([self isNextStateNotExist]) {
            self.currentStateIndex = 0;
        }
        [self setupStateSettingsToDefault];
    }
}


- (BOOL)shouldRemoveFromScreen:(CGPoint)point {
    NSInteger magicValue = isIphone() ? 50 : 100;
    if (point.x < magicValue) {
        return YES;
    }
    if (point.x > [UIScreen mainScreen].bounds.size.height - magicValue) {
        return YES;
    }
    if (point.y > [UIScreen mainScreen].bounds.size.width - magicValue / 2) {
        return YES;
    }
    return NO;
}


#pragma mark - Local Helps

- (BOOL)isNextStateNotExist {
    return [self.parameters.states count] - 1< self.currentStateIndex;
}

@end
