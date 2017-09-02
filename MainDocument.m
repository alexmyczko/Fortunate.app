/* MainDocument.m
 * Chris Saldanha, June 1999 (modified April 2001 for MacOS X 10.0)
 * Class to display fortunes in a simple window.
 * Can copy the fortune into the pasteboard from a menu option.
 * Clicking in the window's content view makes it go away.
 * For MacOS X - now using swanky classes NSTask/NSFileHandle/NSPipe instead of UNIX calls
 */

#import <Foundation/NSException.h>
#import "MainDocument.h"
#import "PreferencesController.h"

@implementation MainDocument

- (id)init
{
   if ((self = [super init]))
   {
      text = nil;
   }

   return self;
}

- (void)activateMainWindow:(id)sender
{
    [self loadNewFortuneAndUpdateWindow:nil];
}

- (void) loadNewFortuneAndUpdateWindow:(id)sender
{
    NSPipe *pipe;
    NSFileHandle *fortuneHandle, *errorHandle;
    NSTask *fortuneTask;
    NSData *fortuneData;
    NSMutableArray *arguments;
    int ret;

    [text autorelease];
    text = [[FortuneTextView alloc] initWithFrame: NSMakeRect(0, 0, 10, 10)];
    [text setFont: [self fortuneFont]];
    [text setEditable: NO];
    [text setRichText: NO];
    [text setDrawsBackground: YES];
    [text setBackgroundColor: [NSColor lightGrayColor]];
    [text setMaxSize:(NSSize){1e7, 1e7}];
    [text setHorizontallyResizable: YES];
    [text setVerticallyResizable: YES];
    [[text textContainer] setContainerSize: (NSSize){1e7, 1e7}];
    [[text textContainer] setWidthTracksTextView:NO];
    [text setTextContainerInset: (NSSize){5, 1}];

    fortuneTask = [[NSTask alloc] init];
    [fortuneTask setLaunchPath: [self fortuneLocation]];

    arguments = [NSMutableArray array];
    if ([self showOffensive])
        [arguments addObject: @"-a"];

    if ([self datfilesLocation])
        [arguments addObject: [self datfilesLocation]];

    [fortuneTask setArguments: arguments];
    
    pipe = [NSPipe pipe];
    fortuneHandle = [pipe fileHandleForReading];
    [fortuneTask setStandardOutput: pipe];
    pipe = [NSPipe pipe];
    errorHandle = [pipe fileHandleForReading];
    [fortuneTask setStandardError: pipe];
    
    ret = 0;
    NS_DURING
        [fortuneTask launch];
    NS_HANDLER
        [text setString: [NSString stringWithFormat: @"Got no fortune from %@.\nUse the preferences panel to chose the location of the fortune program.", [self fortuneLocation]]];
        ret = 1;
    NS_ENDHANDLER
    
    if (ret != 1)
    {
       [fortuneTask waitUntilExit];
       ret = [fortuneTask terminationStatus];
       if (ret != 0)	//failed to get a fortune...
       {
          fortuneData = [errorHandle readDataToEndOfFile];
          [text setString: [NSString stringWithFormat: @"Got an error from fortune:\n%@",
                                     [NSString stringWithCString: [fortuneData bytes] length: [fortuneData length]]]];
       }
       else		//we succeeded in getting a fortune
       {
          fortuneData = [fortuneHandle readDataToEndOfFile];
          [text setString: [NSString stringWithCString: [fortuneData bytes]
                                     length: [fortuneData length]]];
       }
    }
    [fortuneTask release];

    [text sizeToFit];
    [mainWindow setContentSize: [text frame].size];
    [mainWindow setContentView: text];
    [mainWindow center];	//Americans don't know how to spel centre
    [mainWindow makeKeyAndOrderFront: self];
}

- (void)copyFortune:(id)sender
{
    [(NSTextView *)[mainWindow contentView] selectAll: nil];
    [(NSTextView *)[mainWindow contentView] copy: nil];
    [(NSTextView *)[mainWindow contentView] setSelectedRange: NSMakeRange(0, 0)];
}

- (void)showPrefs:(id)sender
{
    if (!prefsPanel)
        if(![NSBundle loadNibNamed: @"Preferences" owner: self])
            return;
    [prefsController showPrefs: nil];
}

- (void)showInfo:(id)sender
{
    if (!infoPanel)
        if(![NSBundle loadNibNamed: @"Info" owner: self])
            return;
    [infoPanel makeKeyAndOrderFront: nil];
}

- (void)printFortune:(id)sender
{
    [text print: nil];
}

- (NSString *)fortuneLocation
{
   BOOL useBundled;

   useBundled = [[NSUserDefaults standardUserDefaults] boolForKey: kUseBundledFortune];
   if (useBundled)
   {
      return [[NSBundle mainBundle] pathForResource: @"fortune" ofType: @""];
   }
   return [[NSUserDefaults standardUserDefaults] stringForKey: kFortuneLocation];
}

- (NSString *)datfilesLocation
{
   BOOL useBundled;

   useBundled = [[NSUserDefaults standardUserDefaults] boolForKey: kUseBundledDatfiles];
   if (useBundled)
   {
      return [[NSBundle mainBundle] pathForResource: @"datfiles" ofType: @""];
   }
   return [[NSUserDefaults standardUserDefaults] stringForKey: kDatfilesLocation];
}

- (NSFont *)fortuneFont
{
   NSString* fontName;
   float     fontSize;

   fontSize = [[NSUserDefaults standardUserDefaults] floatForKey: kFortuneFontSize];
   fontName = [[NSUserDefaults standardUserDefaults] stringForKey: kFortuneFontName];
   
   if ((fontName == nil) || (fontSize == 0.0))
   {
      return [NSFont userFixedPitchFontOfSize: 12.0];
   }
   else
   {
      return [NSFont fontWithName: fontName size: fontSize];
   }
}

- (BOOL)showOffensive
{
   return [[NSUserDefaults standardUserDefaults] boolForKey: kShowOffensive];
}

- (void)dealloc
{
    [super dealloc];
}

@end
