/* FontomaticPanel.m created by chris on Sat 26-Jun-1999 */
/* FontomaticPanel.m
 * Chris Saldanha, June, 1999
 * Subclass of NSPanel that catches changeFont: event from the font panel.
 */

#import "FontomaticPanel.h"

@implementation FontomaticPanel

- (void)changeFont:(id)fontManager
{
   [prefsController changeFont: fontManager];
}

@end
