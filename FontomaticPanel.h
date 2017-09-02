/* FontomaticPanel.h created by chris on Sat 26-Jun-1999 */
/* FontomaticPanel.h
 * Chris Saldanha, June, 1999
 * Subclass of NSPanel that catches changeFont: event from the font panel.
 */

#import <AppKit/AppKit.h>
#import "PreferencesController.h"

@interface FontomaticPanel : NSPanel
{
   IBOutlet PreferencesController *prefsController;
}

- (void)changeFont:(id)fontManager;

@end
