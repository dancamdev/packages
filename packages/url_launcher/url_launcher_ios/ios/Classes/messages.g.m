// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v9.2.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import "messages.g.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}
static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

NSObject<FlutterMessageCodec> *FULUrlLauncherApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

void FULUrlLauncherApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                            NSObject<FULUrlLauncherApi> *api) {
  /// Returns true if the URL can definitely be launched.
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.UrlLauncherApi.canLaunchUrl"
        binaryMessenger:binaryMessenger
                  codec:FULUrlLauncherApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(canLaunchURL:error:)],
                @"FULUrlLauncherApi api (%@) doesn't respond to @selector(canLaunchURL:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_url = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api canLaunchURL:arg_url error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  /// Opens the URL externally, returning true if successful.
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.UrlLauncherApi.launchUrl"
        binaryMessenger:binaryMessenger
                  codec:FULUrlLauncherApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(launchURL:universalLinksOnly:completion:)],
                @"FULUrlLauncherApi api (%@) doesn't respond to "
                @"@selector(launchURL:universalLinksOnly:completion:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_url = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_universalLinksOnly = GetNullableObjectAtIndex(args, 1);
        [api launchURL:arg_url
            universalLinksOnly:arg_universalLinksOnly
                    completion:^(NSNumber *_Nullable output, FlutterError *_Nullable error) {
                      callback(wrapResult(output, error));
                    }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  /// Opens the URL in an in-app SFSafariViewController, returning true
  /// when it has loaded successfully.
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.UrlLauncherApi.openUrlInSafariViewController"
        binaryMessenger:binaryMessenger
                  codec:FULUrlLauncherApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(openSafariViewControllerWithURL:completion:)],
                @"FULUrlLauncherApi api (%@) doesn't respond to "
                @"@selector(openSafariViewControllerWithURL:completion:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_url = GetNullableObjectAtIndex(args, 0);
        [api openSafariViewControllerWithURL:arg_url
                                  completion:^(NSNumber *_Nullable output,
                                               FlutterError *_Nullable error) {
                                    callback(wrapResult(output, error));
                                  }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  /// Closes the view controller opened by [openUrlInSafariViewController].
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.UrlLauncherApi.closeSafariViewController"
        binaryMessenger:binaryMessenger
                  codec:FULUrlLauncherApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(closeSafariViewControllerWithError:)],
                @"FULUrlLauncherApi api (%@) doesn't respond to "
                @"@selector(closeSafariViewControllerWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api closeSafariViewControllerWithError:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}