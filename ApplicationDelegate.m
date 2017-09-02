/* ApplicationDelegate.m created by chris on Sat 19-Jun-1999 */

#import "ApplicationDelegate.h"
#import "MainDocument.h"

@implementation ApplicationDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [mainDocument activateMainWindow:self];
    //[NSApp activateIgnoringOtherApps: YES];
}


- (void)activateMainDocument:(id)sender
{
    [mainDocument activateMainWindow:self];
}

@end
