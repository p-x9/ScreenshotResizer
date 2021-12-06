#include "SSRRootListController.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>

#define PREF_PATH @"/var/mobile/Library/Preferences/com.p-x9.screenshotresizer.pref.plist"
#define NOTIFY "com.p-x9.screenshotresizer.prefschanged"

@implementation SSRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	[_specifiers enumerateObjectsUsingBlock:^(PSSpecifier *spec, NSUInteger idx, BOOL *stop){
        [spec setProperty:@NOTIFY forKey:@"PostNotification"];
    }];

	return _specifiers;
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:PREF_PATH];
     return [prefs objectForKey:[specifier.properties objectForKey:@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PREF_PATH]?:[NSMutableDictionary dictionary];
    
    [prefs setObject:value forKey:[specifier.properties objectForKey:@"key"]];
    
    [prefs writeToFile:PREF_PATH atomically:YES];

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR(NOTIFY),NULL, NULL, YES);
}


- (void)twitter{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/p_x9"]];
} 
@end
