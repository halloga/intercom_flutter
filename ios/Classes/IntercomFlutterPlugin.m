#import "IntercomFlutterPlugin.h"
#import "Intercom.h"

@implementation IntercomFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    IntercomFlutterPlugin* instance = [[IntercomFlutterPlugin alloc] init];
    FlutterMethodChannel* channel =
    [FlutterMethodChannel methodChannelWithName:@"maido.io/intercom"
                                binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void) handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    if([@"initialize" isEqualToString:call.method]) {
        NSString *iosApiKey = call.arguments[@"iosApiKey"];
        NSString *appId = call.arguments[@"appId"];
        [Intercom setApiKey:iosApiKey forAppId:appId];
        result(@"Initialized Intercom");
    } else if([@"sendTokenToIntercom" isEqualToString:call.method]) {
        NSString *token = call.arguments[@"token"];
        NSData *data = [token dataUsingEncoding:NSUTF8StringEncoding];
        [Intercom setDeviceToken:data];
        result(@"Token sent to Intercom");
    }
    else if([@"registerUnidentifiedUser" isEqualToString:call.method]) {
        [Intercom registerUnidentifiedUser];
        result(@"Registered unidentified user");
    }
    else if([@"setUserHash" isEqualToString:call.method]) {
        NSString *userHash = call.arguments[@"userHash"];
        [Intercom setUserHash:userHash];
        result(@"User hash added");
    }
    else if([@"registerIdentifiedUserWithUserId" isEqualToString:call.method]) {
        NSString *userId = call.arguments[@"userId"];
        [Intercom registerUserWithUserId:userId];
        result(@"Registered user");
    }
    else if([@"registerIdentifiedUserWithEmail" isEqualToString:call.method]) {
        NSString *email = call.arguments[@"email"];
        [Intercom registerUserWithEmail:email];
        result(@"Registered user");
    }
    else if([@"setLauncherVisibility" isEqualToString:call.method]) {
        NSString *visibility = call.arguments[@"visibility"];
        [Intercom setLauncherVisible:[@"VISIBLE" isEqualToString:visibility]];
        result(@"Setting launcher visibility");
    }
    else if([@"setInAppMessagesVisibility" isEqualToString:call.method]) {
        NSString *visibility = call.arguments[@"visibility"];
        [Intercom setInAppMessagesVisible:[@"VISIBLE" isEqualToString:visibility]];
        result(@"Setting in app messages visibility");
    }
    else if([@"unreadConversationCount" isEqualToString:call.method]) {
        NSUInteger count = [Intercom unreadConversationCount];
        result(@(count));
    }
    else if([@"displayMessenger" isEqualToString:call.method]) {
        [Intercom presentMessenger];
        result(@"Presented messenger");
    }
    else if([@"hideMessenger" isEqualToString:call.method]) {
        [Intercom hideMessenger];
        result(@"Messenger hidden");
    }
    else if([@"displayHelpCenter" isEqualToString:call.method]) {
        [Intercom presentHelpCenter];
        result(@"Presented help center");
    }
    else if([@"updateUser" isEqualToString:call.method]) {
        ICMUserAttributes *attributes = [ICMUserAttributes new];
        NSString *email = call.arguments[@"email"];
        if(email != (id)[NSNull null]) {
            attributes.email = email;
        }
        NSString *name = call.arguments[@"name"];
        if(name != (id)[NSNull null]) {
            attributes.name = name;
        }
        NSString *phone = call.arguments[@"phone"];
        if(phone != (id)[NSNull null]) {
            attributes.phone = phone;
        }
        NSString *userId = call.arguments[@"userId"];
        if(userId != (id)[NSNull null]) {
            attributes.userId = userId;
        }
        NSString *companyName = call.arguments[@"company"];
        NSString *companyId = call.arguments[@"companyId"];
        if(companyName != (id)[NSNull null] && companyId != (id)[NSNull null]) {
            ICMCompany *company = [ICMCompany new];
            company.name = companyName;
            company.companyId = companyId;
            attributes.companies = @[company];
        }
        NSDictionary *customAttributes = call.arguments[@"customAttributes"];
        if(customAttributes != (id)[NSNull null]) {
            attributes.customAttributes = customAttributes;
        }
        [Intercom updateUser:attributes];
        result(@"Updated user");
    }
    else if([@"logout" isEqualToString:call.method]) {
        [Intercom logout];
        result(@"Logged out");
    }
    else if ([@"logEvent" isEqualToString:call.method]) {
        NSString *name = call.arguments[@"name"];
        NSDictionary *metaData = call.arguments[@"metaData"];
        if(name != (id)[NSNull null] && name != nil) {
            if(metaData != (id)[NSNull null] && metaData != nil) {
                [Intercom logEventWithName:name metaData:metaData];
            } else {
                [Intercom logEventWithName:name];
            }
            result(@"Logged event");
        }
    }
    else if([@"handlePushMessage" isEqualToString:call.method]) {
        result(@"No op");
    }
    else if([@"displayMessageComposer" isEqualToString:call.method]) {
        NSString *message = call.arguments[@"message"];
        if(message != (id)[NSNull null]) {
            [Intercom presentMessageComposerWithInitialMessage:message];
        }else{
            [Intercom presentMessageComposer];
        }
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}
@end
