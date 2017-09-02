/* FortuneTextView.m created by chris on Sat 26-Jun-1999 */
/* FortuneTextView.m
 * Chris Saldanha, June, 1999
 * Subclass of  NSTextView that quits the app on a mouse click.
 */

#import "FortuneTextView.h"

@implementation FortuneTextView

- (void)mouseDown: (NSEvent *)theEvent
{
    [NSApp terminate: nil];
}

@end
