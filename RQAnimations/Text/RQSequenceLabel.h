#import "RQAnimationLabel.h"

@interface RQSequenceLabel : RQAnimationLabel

/*
 Animation duration in seconds.
 */
@property (nonatomic) CGFloat animationDuration;

/*
 Maxmimum number of characters to be animating at once.
*/
@property (nonatomic) NSUInteger maxAnimatingCharacters;

/**
 Hides the text.

 @param animated Boolean to indicate whether hiding the text should be animated.
 @param completion The completion block to run after the text has been hidden.
 */
- (void)hideTextWithAnimation:(BOOL)animated completion:(void(^)())completion;

/**
 Shows the text.

 @param animated Boolean to indicate whether showing the text should be animated.
 @param completion The completion block to run after the text has been shown.
 */
- (void)showTextWithAnimation:(BOOL)animated completion:(void(^)())completion;

@end
