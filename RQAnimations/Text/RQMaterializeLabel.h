#import "RQAnimationLabel.h"

@interface RQMaterializeLabel : RQAnimationLabel

/*
 Animation duration in seconds.
*/
@property (nonatomic) CGFloat animationDuration;

/*
 This should be a number between 0.0 and 1.0, which represents the
 percentage of the animationDuration the maximum delay for a single
 character can be before it fades in.
*/
@property (nonatomic) CGFloat maxDelay;

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
