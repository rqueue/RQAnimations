#import "NSMutableAttributedString+Utility.h"

@implementation NSMutableAttributedString (Utility)

- (void)modifyEachCharacterAttribute:(void (^)(NSUInteger , NSMutableDictionary *))block {
    if (!block) {
        return;
    }

    for (NSUInteger i = 0; i < [[self string] length]; i++) {
        NSRange range;
        NSMutableDictionary *mutableAttributes = [[self attributesAtIndex:i effectiveRange:&range] mutableCopy];
        block(i, mutableAttributes);
        [self setAttributes:[mutableAttributes copy] range:NSMakeRange(i, 1)];
    }
}

@end
