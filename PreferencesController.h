/* PreferencesController.h created by chris on Wed 30-Jun-1999 */

#import <AppKit/AppKit.h>
#import "MainDocument.h"

extern NSString* kUseBundledFortune;
extern NSString* kFortuneLocation;
extern NSString* kUseBundledDatfiles;
extern NSString* kDatfilesLocation;
extern NSString* kShowOffensive;
extern NSString* kFortuneFontName;
extern NSString* kFortuneFontSize;

@interface PreferencesController : NSObject
{
    IBOutlet NSPanel *prefsPanel;
    IBOutlet NSTextField *pathField;
    IBOutlet NSTextField *datfilesPathField;
    IBOutlet NSButton* useBundledFortuneCheckBox;
    IBOutlet NSButton* useBundledDatfilesCheckBox;
    IBOutlet NSTextField *fontField;
    IBOutlet NSButton *offensiveCheckBox;
    IBOutlet NSButton *selectFortuneButton;
    IBOutlet NSButton *selectDatfilesButton;
    IBOutlet MainDocument *mainDoc;

    NSFont *newFont;
    BOOL fontChanged;
}

- (void)showPrefs:(id)sender;
- (void)resetPrefs:(id)sender;
- (void)savePrefs:(id)sender;
- (void)cancelPrefs:(id)sender;
- (void)showOpenFortunePanel:(id)sender;
- (void)showOpenDatfilesPanel:(id)sender;
- (void)showFontPanel:(id)sender;
- (void)changeFont:(id)fontManager;
- (void)offensiveClicked:(id)sender;
- (void)useBundledFortuneClicked:(id)sender;
- (void)useBundledDatfilesClicked:(id)sender;

@end
