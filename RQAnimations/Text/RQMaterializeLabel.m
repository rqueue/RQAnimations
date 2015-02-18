#import "RQMaterializeLabel.h"
#import "NSMutableAttributedString+Utility.h"

@interface RQMaterializeLabel()

@property (nonatomic) NSAttributedString *originalText;
@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) NSArray *characterDelays;
@property (nonatomic) CFTimeInterval animationStartTime;
@property (nonatomic) BOOL fadeIn;
@property (nonatomic, copy) void(^completionBlock)();

@end

@implementation RQMaterializeLabel

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    self.animationDuration = 2.5;
    self.maxDelay = 1.0;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAttributedDisplayTextForDisplayLink)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink.paused = YES;
}

#pragma mark - Public

- (void)hideTextWithAnimation:(BOOL)animated completion:(void (^)())completion {
    [self updateTextWithText:nil animated:animated fadeIn:NO completion:completion];
}

- (void)showTextWithAnimation:(BOOL)animated completion:(void (^)())completion {
    [self updateTextWithText:self.originalText animated:animated fadeIn:YES completion:completion];
}

#pragma mark - Internal Helpers

- (void)updateTextWithText:(NSAttributedString *)text animated:(BOOL)animated fadeIn:(BOOL)fadeIn completion:(void (^)())completion {
    self.completionBlock = completion;

    if (animated) {
        NSString *startingText = fadeIn ? nil : self.originalText;
        [super setAttributedText:startingText];
        self.fadeIn = fadeIn;
        self.animationStartTime = CACurrentMediaTime();
        self.displayLink.paused = NO;
    } else {
        [super setAttributedText:text];
        if (self.completionBlock) {
            self.completionBlock();
        }
    }
}

- (void)updateCharacterDelays {
    CGFloat maxDelay = self.animationDuration * self.maxDelay;
    NSMutableArray *mutableCharacterDelays = [NSMutableArray array];
    for (NSUInteger i = 0; i < [[self.attributedText string] length]; i++) {
        CGFloat normalizedRandomNumber = arc4random_uniform(10000) / 10000.0;
        [mutableCharacterDelays addObject:@(normalizedRandomNumber * maxDelay)];
    }
    self.characterDelays = [mutableCharacterDelays copy];
}

- (void)updateAttributedDisplayTextForDisplayLink {
    CFTimeInterval delta = self.displayLink.timestamp - self.animationStartTime;
    if (delta >= self.animationDuration) {
        self.attributedText = self.originalText;
        self.displayLink.paused = YES;
        if (self.completionBlock) {
            self.completionBlock();
        }
        return;
    }
    NSMutableAttributedString *mutableAttributedText = [self.originalText mutableCopy];
    [mutableAttributedText modifyEachCharacterAttribute:^(NSUInteger characterIndex, NSMutableDictionary *mutableAttributes) {
        CGFloat characterDelay = [self.characterDelays[characterIndex] floatValue];
        CGFloat characterAnimationDurationTotal = self.fadeIn ? self.animationDuration - characterDelay : characterDelay;
        CGFloat characterAnimationDurationElapsed = self.fadeIn ? delta - characterDelay : delta;
        CGFloat alpha = characterAnimationDurationElapsed / characterAnimationDurationTotal;
        alpha = MIN(MAX(0.0, alpha), 1.0);
        alpha = self.fadeIn ? alpha : 1.0 - alpha;

        UIColor *color = mutableAttributes[NSForegroundColorAttributeName];
        mutableAttributes[NSForegroundColorAttributeName] = [color colorWithAlphaComponent:alpha];
    }];
    [super setAttributedText:[mutableAttributedText copy]];
}

#pragma mark - Getters & Setters

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];

    self.originalText = attributedText;
    [self updateCharacterDelays];
}

- (void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;

    [self updateCharacterDelays];
}

- (void)setMaxDelay:(CGFloat)maxDelay {
    _maxDelay = maxDelay;

    [self updateCharacterDelays];
}

@end
