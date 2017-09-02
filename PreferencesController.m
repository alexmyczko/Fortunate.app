/* PreferencesController.m created by chris on Wed 30-Jun-1999 */

#import "PreferencesController.h"

NSString* kUseBundledFortune   = @"UseBundledFortune";
NSString* kFortuneLocation     = @"FortuneLocation";
NSString* kUseBundledDatfiles  = @"UseBundledDatfiles";
NSString* kDatfilesLocation    = @"DatfilesLocation";
NSString* kShowOffensive       = @"ShowOffensive";
NSString* kFortuneFontName     = @"FontName";
NSString* kFortuneFontSize     = @"FontSize";

@implementation PreferencesController

+ (void)initialize
{
   NSMutableDictionary* standardDefs;
   NSUserDefaults*      defaults;

   [super initialize];

   // setup user defaults
   defaults = [NSUserDefaults standardUserDefaults];
   standardDefs = [NSMutableDictionary dictionary];

   [standardDefs setObject: @"YES" forKey: kUseBundledDatfiles];
   [standardDefs setObject: @"/usr/games/fortune" forKey: kFortuneLocation];
#ifdef WITH_FORTUNE_PROGRAM
   [standardDefs setObject: @"YES" forKey: kUseBundledFortune];
#else
   [standardDefs setObject: @"NO" forKey: kUseBundledFortune];
#endif
   [standardDefs setObject: @"YES" forKey: kShowOffensive];

   [defaults registerDefaults: standardDefs];
}

- (void)showPrefs:(id)sender
{
    [prefsPanel setFloatingPanel: YES];
    [self resetPrefs: nil];
    [prefsPanel makeKeyAndOrderFront: nil];
}

- (void)resetPrefs:(id)sender
{
   NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
   BOOL useBundledFortune;
   BOOL useBundledDatfiles;

   useBundledFortune = [defaults boolForKey: kUseBundledFortune];
   [useBundledFortuneCheckBox setState: (useBundledFortune ? NSOnState : NSOffState)];
   [self useBundledFortuneClicked: nil];

   useBundledDatfiles = [defaults boolForKey: kUseBundledDatfiles];
   [useBundledDatfilesCheckBox setState: (useBundledDatfiles ? NSOnState : NSOffState)];
   [self useBundledDatfilesClicked: nil];

   [offensiveCheckBox setState: 
      ([defaults boolForKey: kShowOffensive] ? NSOnState : NSOffState)];
      
   fontChanged = NO;
   newFont = nil;
   [fontField setStringValue: [NSString stringWithFormat:@"%@ %g",
        [[mainDoc fortuneFont] fontName], [[mainDoc fortuneFont] pointSize]]];
}

- (void)savePrefs:(id)sender
{
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSMutableString *errors = [NSMutableString string];
   NSString *datfilesLocation = nil;
   NSString *fortuneLocation = nil;
   BOOL ok = YES;
   BOOL showOffensive;
   
   fortuneLocation = [pathField stringValue];
   datfilesLocation = [datfilesPathField stringValue];

   // check settings
   if ([useBundledFortuneCheckBox state] == NSOffState &&
       ![[NSFileManager defaultManager] fileExistsAtPath: fortuneLocation])
   {
      [errors appendString: @"\nInvalid fortune program location."];
      ok = NO;
   }

   if ([useBundledDatfilesCheckBox state] == NSOffState &&
       ![[NSFileManager defaultManager] fileExistsAtPath: datfilesLocation])
   {
      [errors appendString: @"\nInvalid datafiles location."];
      ok = NO;
   }

   if (!ok)
   {
      [errors deleteCharactersInRange: NSMakeRange(0, 1)];
      NSRunAlertPanel(@"Un-Fortunate Error",
                      errors,
                      @"Ok",
                      nil,
                      nil);
      return;
   }

   // save settings
   if ([useBundledFortuneCheckBox state] == NSOnState)
   {
      [defaults setBool: YES forKey: kUseBundledFortune];
   }
   else
   {
      [defaults setBool: NO forKey: kUseBundledFortune];
      [defaults setObject: fortuneLocation forKey: kFortuneLocation];
   }

   if ([useBundledDatfilesCheckBox state] == NSOnState)
   {
      [defaults setBool: YES forKey: kUseBundledDatfiles];
   }
   else
   {
      [defaults setBool: NO forKey: kUseBundledDatfiles];
      [defaults setObject: datfilesLocation forKey: kDatfilesLocation];
   }
   
   showOffensive = ([offensiveCheckBox state] == NSOnState ? YES : NO);
   [defaults setBool: showOffensive forKey: kShowOffensive];
   
   if (fontChanged)
   {
      [defaults setObject: [newFont fontName] forKey: kFortuneFontName];
      [defaults setFloat: [newFont pointSize] forKey: kFortuneFontSize];
   }
   
   [[[NSFontManager sharedFontManager] fontPanel: NO] close];
   [prefsPanel close];
}

- (void)cancelPrefs:(id)sender
{
    [prefsPanel close];
}

- (void)showOpenFortunePanel:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    int ret;
    
    [openPanel setAllowsMultipleSelection: NO];
    [openPanel setCanChooseFiles: YES];
    [openPanel setCanChooseDirectories: NO];
    [openPanel setTitle: @"Select fortune program"];

    ret = [openPanel runModalForDirectory: 
             [[NSBundle mainBundle] resourcePath] file: nil types: nil];
    
    if (ret == NSOKButton)
        [pathField setStringValue: [[openPanel filenames] objectAtIndex: 0]];
}

- (void)showOpenDatfilesPanel:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    int ret;
    
    [openPanel setAllowsMultipleSelection: NO];
    [openPanel setCanChooseFiles: NO];
    [openPanel setCanChooseDirectories: YES];
    [openPanel setTitle: @"Select directory with fortune datafiles"];
    
    ret = [openPanel runModalForDirectory: 
             [[NSBundle mainBundle] resourcePath] file: nil types: nil];
    
    if (ret == NSOKButton)
        [datfilesPathField setStringValue: [[openPanel filenames] objectAtIndex: 0]];
}

- (void)showFontPanel:(id)sender
{
   //[prefsPanel makeFirstResponder: fontField];
   [prefsPanel makeFirstResponder: prefsPanel];
   [[NSFontManager sharedFontManager] setSelectedFont: [mainDoc fortuneFont]
                                      isMultiple: NO];
   [[NSFontManager sharedFontManager] orderFrontFontPanel: self];
}

- (void)changeFont:(id)fontManager
{
    [newFont autorelease];
    newFont = [[fontManager convertFont: [fontManager selectedFont]] retain];
    fontChanged = YES;
    [fontField setStringValue: [NSString stringWithFormat:@"%@ %g",
                                  [newFont fontName], [newFont pointSize]]];
    [fontField display];
}

- (void)offensiveClicked:(id)sender
{
   return;
}

- (void)useBundledFortuneClicked:(id)sender
{
   BOOL useBundled;
   
   useBundled = (([useBundledFortuneCheckBox state] == NSOnState) ? YES : NO);

   [pathField setEditable: !useBundled];
   [pathField setSelectable: !useBundled];
   [selectFortuneButton setEnabled: !useBundled];

   if (useBundled)
   {
      NSString* whereIsFortune =
         [[NSBundle mainBundle] pathForResource: @"fortune" ofType: @""];
         
      if (!whereIsFortune)
      {
         NSRunAlertPanel(@"Un-Fortunate Error",
                         @"No fortune program bundled with Fortunate!",
                         @"Ok",
                         nil,
                         nil);
         [useBundledFortuneCheckBox setState: NSOffState];
         return;
      }
      
      [pathField setStringValue: whereIsFortune];
   }
   else
   {
      [pathField setStringValue:
          [[NSUserDefaults standardUserDefaults] stringForKey: kFortuneLocation]];
   }
}

- (void)useBundledDatfilesClicked:(id)sender
{
   BOOL useBundled;
   
   useBundled = (([useBundledDatfilesCheckBox state] == NSOnState) ? YES : NO);

   [datfilesPathField setEditable: !useBundled];
   [datfilesPathField setSelectable: !useBundled];
   [selectDatfilesButton setEnabled: !useBundled];

   if (useBundled)
   {
      NSString* whereAreDatfiles =
         [[NSBundle mainBundle] pathForResource: @"datfiles" ofType: @""];
         
      if (!whereAreDatfiles)
      {
         NSRunAlertPanel(@"Un-Fortunate Error",
                         @"No datafiles bundled with Fortunate!",
                         @"Ok",
                         nil,
                         nil);
         [useBundledDatfilesCheckBox setState: NSOffState];
         return;
      }
      
      [datfilesPathField setStringValue: whereAreDatfiles];
   }
   else
   {
      [datfilesPathField setStringValue:
          [[NSUserDefaults standardUserDefaults] stringForKey: kDatfilesLocation]];
   }
}

@end
