#import "RQMaterializeLabel.h"
#import "NSMutableAttributedString+Utility.h"

@interface RQMaterializeLabel()

@property (nonatomic) NSArray *characterDelays;

@end

@implementation RQMaterializeLabel

#pragma mark - Initialization

- (void)setUp {
    self.maxDelay = 1.0;
    [self setUpAnimation];
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
    __weak RQMaterializeLabel *weakSelf = self;
    [self setPreAnimationBlock:^(NSAttributedString *text) {
        CGFloat maxDelay = weakSelf.animationDuration * weakSelf.maxDelay;
        NSMutableArray *mutableCharacterDelays = [NSMutableArray array];
        for (NSUInteger i = 0; i < [[text string] length]; i++) {
            CGFloat normalizedRandomNumber = arc4random_uniform(10000) / 10000.0;
            [mutableCharacterDelays addObject:@(normalizedRandomNumber * maxDelay)];
        }
        weakSelf.characterDelays = [mutableCharacterDelays copy];
    } animationBlock:^(NSMutableAttributedString *mutableAttributedText, BOOL show, CGFloat timeElapsed) {
        CGFloat delta = weakSelf.animationDuration * timeElapsed;
        [mutableAttributedText modifyEachCharacterAttribute:^(NSUInteger characterIndex, NSMutableDictionary *mutableAttributes) {
            CGFloat characterDelay = [weakSelf.characterDelays[characterIndex] floatValue];
            CGFloat characterAnimationDurationTotal = show ? weakSelf.animationDuration - characterDelay : characterDelay;
            CGFloat characterAnimationDurationElapsed = show ? delta - characterDelay : delta;
            CGFloat alpha = characterAnimationDurationElapsed / characterAnimationDurationTotal;
            alpha = MIN(MAX(0.0, alpha), 1.0);
            alpha = show ? alpha : 1.0 - alpha;

            UIColor *color = mutableAttributes[NSForegroundColorAttributeName];
            mutableAttributes[NSForegroundColorAttributeName] = [color colorWithAlphaComponent:alpha];
        }];
    }];
}

@end
