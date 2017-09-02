/* ApplicationDelegate.h created by chris on Sat 19-Jun-1999 */

#import <AppKit/AppKit.h>
#import "MainDocument.h"

@interface ApplicationDelegate : NSObject
	{
    IBOutlet MainDocument *mainDocument;
	}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@end
