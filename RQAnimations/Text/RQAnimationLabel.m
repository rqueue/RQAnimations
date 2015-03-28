#import "RQAnimationLabel.h"
#import "NSMutableAttributedString+Utility.h"

@interface RQAnimationLabel()

@property (nonatomic) NSAttributedString *originalText;
@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) NSArray *characterDelays;
@property (nonatomic) CFTimeInterval animationStartTime;
@property (nonatomic) BOOL isShowing;
@property (nonatomic, copy) void(^completionBlock)();
@property (nonatomic, copy) void(^preAnimationBlock)(NSAttributedString *);
@property (nonatomic, copy) AnimationBlock animationBlock;

@end

@implementation RQAnimationLabel

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    self.animationDuration = 2.5;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAttributedDisplayTextForDisplayLink)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.paused = YES;
    [self setUp];
}

- (void)setUp {
    // Subclasses should override this method with set up code that should be run upon label initialization.
}

#pragma mark - Public

- (void)hideTextWithAnimation:(BOOL)animated completion:(void (^)())completion {
    [self updateTextWithText:nil animated:animated show:NO completion:completion];
}

- (void)showTextWithAnimation:(BOOL)animated completion:(void (^)())completion {
    [self updateTextWithText:self.originalText animated:animated show:YES completion:completion];
}

- (void)setPreAnimationBlock:(void (^)(NSAttributedString *))preAnimationBlock animationBlock:(AnimationBlock)animationBlock {
    self.preAnimationBlock = preAnimationBlock;
    self.animationBlock = animationBlock;
}

#pragma mark - Internal Helpers

- (void)updateTextWithText:(NSAttributedString *)text animated:(BOOL)animated show:(BOOL)show completion:(void (^)())completion {
    self.completionBlock = completion;

    if (animated) {
        if (self.preAnimationBlock) {
            self.preAnimationBlock(self.originalText);
        }
        NSAttributedString *startingText = show ? nil : self.originalText;
        [super setAttributedText:startingText];
        self.isShowing = show;
        self.animationStartTime = CACurrentMediaTime();
        self.displayLink.paused = NO;
    } else {
        [super setAttributedText:text];
        if (self.completionBlock) {
            self.completionBlock();
        }
    }
}

- (void)updateAttributedDisplayTextForDisplayLink {
    CFTimeInterval delta = self.displayLink.timestamp - self.animationStartTime;
    if (delta >= self.animationDuration) {
        NSAttributedString *text = self.isShowing ? self.originalText : nil;
        [super setAttributedText:text];
        self.displayLink.paused = YES;
        if (self.completionBlock) {
            self.completionBlock();
        }
        return;
    }
    NSMutableAttributedString *mutableAttributedText = [self.originalText mutableCopy];
    CGFloat normalizedTimeElapsed = delta / self.animationDuration;
    if (self.animationBlock) {
        self.animationBlock(mutableAttributedText, self.isShowing, normalizedTimeElapsed);
    }
    [super setAttributedText:[mutableAttributedText copy]];
}

#pragma mark - Getters & Setters

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];

    self.originalText = attributedText;
}

@end
