/* MainDocument.h
 * Chris Saldanha, June 1999
 * Class to display fortunes in a simple window.
 */

#import <AppKit/AppKit.h>
#import "FortuneTextView.h"

@class PreferencesController;

@interface MainDocument : NSObject
{
   IBOutlet NSWindow *mainWindow;
   IBOutlet NSPanel *prefsPanel;
   IBOutlet NSPanel *infoPanel;
   IBOutlet PreferencesController *prefsController;
   FortuneTextView *text;
}

- (void)activateMainWindow:(id)sender;
- (void)loadNewFortuneAndUpdateWindow:(id)sender;
- (void)copyFortune:(id)sender;
- (void)showPrefs:(id)sender;
- (void)showInfo:(id)sender;
- (void)printFortune:(id)sender;

- (NSString *)fortuneLocation;
- (NSString *)datfilesLocation;
- (NSFont*)fortuneFont;
- (BOOL)showOffensive;

@end
