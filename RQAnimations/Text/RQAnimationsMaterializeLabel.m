#import "RQAnimationsMaterializeLabel.h"
#import "NSMutableAttributedString+Utility.h"

@interface RQAnimationsMaterializeLabel()

@property (nonatomic) NSAttributedString *originalText;
@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) NSArray *characterDelays;
@property (nonatomic) CFTimeInterval animationStartTime;

@end

@implementation RQAnimationsMaterializeLabel

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
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAttributedDisplayTextForDisplayLink)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink.paused = YES;
}

#pragma mark - Public

- (void)hideText {
    [super setAttributedText:nil];
}

- (void)showTextWithAnimation:(BOOL)animated {
    if (animated) {
        self.animationStartTime = CACurrentMediaTime();
        self.displayLink.paused = NO;
    } else {
        [super setAttributedText:self.originalText];
    }
}

#pragma mark - Internal Helpers

- (void)updateCharacterDelays {
    CGFloat maxDelay = self.animationDuration / 2.0;
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
    }
    NSMutableAttributedString *mutableAttributedText = [self.originalText mutableCopy];
    [mutableAttributedText modifyEachCharacterAttribute:^(NSUInteger characterIndex, NSMutableDictionary *mutableAttributes) {
        CGFloat characterDelay = [self.characterDelays[characterIndex] floatValue];
        CGFloat characterAnimationDuration = self.animationDuration - characterDelay;
        CGFloat alpha = (delta - characterDelay) / characterAnimationDuration;
        alpha = MAX(0.0, alpha);

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

@end
