//
//  Tools.m
//  WildFireChat
//
//  2019/10/29.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "Tools.h"
#import <Security/Security.h>


#define KValue @"uuid_string"
static NSString *value;

@implementation Tools

+ (UIColor *)getThemeColor {
    return COLOR(0xC5A14A);
}

+ (NSString *)uuid {
    if (value.length == 0 || value == nil) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:KValue] == nil || ![[[NSUserDefaults standardUserDefaults] valueForKey:KValue] isKindOfClass:[NSString class]]) {
            UIPasteboard *pboard = [UIPasteboard pasteboardWithName:KValue create:YES];
            if (pboard.string == nil || pboard.string.length == 0) {
                value = [UIDevice currentDevice].identifierForVendor.UUIDString;
            } else {
                value = pboard.string;
            }
            [[NSUserDefaults standardUserDefaults] setValue:value forKey:KValue];
            pboard.string = value;
        } else {
            value = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KValue]];
        }
    }
    return value;
}


@end
