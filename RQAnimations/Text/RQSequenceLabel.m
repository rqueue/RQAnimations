#import "RQSequenceLabel.h"
#import "NSMutableAttributedString+Utility.h"

@interface RQSequenceLabel()

@property (nonatomic) NSArray *characterDelays;

@end

@implementation RQSequenceLabel

#pragma mark - Initialization

- (void)setUp {
    self.maxAnimatingCharacters = 10.0;
}

#pragma mark - Public

- (void)hideTextWithAnimation:(BOOL)animated completion:(void (^)())completion {
    [super hideTextWithAnimation:animated completion:completion];
}

- (void)showTextWithAnimation:(BOOL)animated completion:(void (^)())completion {
    [super showTextWithAnimation:animated completion:completion];
}

#pragma mark - Internal Helpers

- (void)setUpAnimation {
    __weak RQSequenceLabel *weakSelf = self;
    [self setPreAnimationBlock:^(NSAttributedString *text) {
        CGFloat characterAnimationTime = weakSelf.animationDuration / [[text string] length];
        NSMutableArray *mutableCharacterDelays = [NSMutableArray array];
        for (NSUInteger i = 0; i < [[text string] length]; i++) {
            [mutableCharacterDelays addObject:@(i * characterAnimationTime)];
        }
        weakSelf.characterDelays = [mutableCharacterDelays copy];
    } animationBlock:^(NSMutableAttributedString *mutableAttributedText, BOOL show, CGFloat timeElapsed) {
        CGFloat characterAnimationTime = weakSelf.maxAnimatingCharacters * weakSelf.animationDuration / [[mutableAttributedText string] length];
        CGFloat delta = weakSelf.animationDuration * timeElapsed;
        [mutableAttributedText modifyEachCharacterAttribute:^(NSUInteger characterIndex, NSMutableDictionary *mutableAttributes) {
            CGFloat characterDelay = [weakSelf.characterDelays[characterIndex] floatValue];
            CGFloat characterAnimationDurationElapsed = show ? delta - characterDelay : delta - (weakSelf.animationDuration - characterDelay - characterAnimationTime);
            CGFloat alpha = characterAnimationDurationElapsed / characterAnimationTime;
            alpha = MIN(MAX(0.0, alpha), 1.0);
            alpha = show ? alpha : 1.0 - alpha;

            UIColor *color = mutableAttributes[NSForegroundColorAttributeName];
            mutableAttributes[NSForegroundColorAttributeName] = [color colorWithAlphaComponent:alpha];
        }];
    }];
}

#pragma mark - Getters & Setters

- (void)setMaxAnimatingCharacters:(NSUInteger)maxAnimatingCharacters {
    _maxAnimatingCharacters = maxAnimatingCharacters;
    [self setUpAnimation];
}

@end
