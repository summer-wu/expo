//  Copyright © 2019 650 Industries. All rights reserved.

#import <ABI39_0_0EXUpdates/ABI39_0_0EXUpdatesConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI39_0_0EXUpdatesConfig ()

@property (nonatomic, readwrite, assign) BOOL isEnabled;
@property (nonatomic, readwrite, assign) BOOL expectsSignedManifest;
@property (nonatomic, readwrite, strong) NSString *scopeKey;
@property (nonatomic, readwrite, strong) NSURL *updateUrl;
@property (nonatomic, readwrite, strong) NSDictionary *requestHeaders;
@property (nonatomic, readwrite, strong) NSString *releaseChannel;
@property (nonatomic, readwrite, strong) NSNumber *launchWaitMs;
@property (nonatomic, readwrite, assign) ABI39_0_0EXUpdatesCheckAutomaticallyConfig checkOnLaunch;

@property (nullable, nonatomic, readwrite, strong) NSString *sdkVersion;
@property (nullable, nonatomic, readwrite, strong) NSString *runtimeVersion;

@end

static NSString * const ABI39_0_0EXUpdatesDefaultReleaseChannelName = @"default";

static NSString * const ABI39_0_0EXUpdatesConfigEnabledKey = @"ABI39_0_0EXUpdatesEnabled";
static NSString * const ABI39_0_0EXUpdatesConfigScopeKeyKey = @"ABI39_0_0EXUpdatesScopeKey";
static NSString * const ABI39_0_0EXUpdatesConfigUpdateUrlKey = @"ABI39_0_0EXUpdatesURL";
static NSString * const ABI39_0_0EXUpdatesConfigRequestHeadersKey = @"ABI39_0_0EXUpdatesRequestHeaders";
static NSString * const ABI39_0_0EXUpdatesConfigReleaseChannelKey = @"ABI39_0_0EXUpdatesReleaseChannel";
static NSString * const ABI39_0_0EXUpdatesConfigLaunchWaitMsKey = @"ABI39_0_0EXUpdatesLaunchWaitMs";
static NSString * const ABI39_0_0EXUpdatesConfigCheckOnLaunchKey = @"ABI39_0_0EXUpdatesCheckOnLaunch";
static NSString * const ABI39_0_0EXUpdatesConfigSDKVersionKey = @"ABI39_0_0EXUpdatesSDKVersion";
static NSString * const ABI39_0_0EXUpdatesConfigRuntimeVersionKey = @"ABI39_0_0EXUpdatesRuntimeVersion";
static NSString * const ABI39_0_0EXUpdatesConfigHasEmbeddedUpdateKey = @"ABI39_0_0EXUpdatesHasEmbeddedUpdate";

static NSString * const ABI39_0_0EXUpdatesConfigAlwaysString = @"ALWAYS";
static NSString * const ABI39_0_0EXUpdatesConfigWifiOnlyString = @"WIFI_ONLY";
static NSString * const ABI39_0_0EXUpdatesConfigNeverString = @"NEVER";

@implementation ABI39_0_0EXUpdatesConfig

- (instancetype)init
{
  if (self = [super init]) {
    _isEnabled = YES;
    _expectsSignedManifest = NO;
    _requestHeaders = @{};
    _releaseChannel = ABI39_0_0EXUpdatesDefaultReleaseChannelName;
    _launchWaitMs = @(0);
    _checkOnLaunch = ABI39_0_0EXUpdatesCheckAutomaticallyConfigAlways;
    _hasEmbeddedUpdate = YES;
  }
  return self;
}

+ (instancetype)configWithDictionary:(NSDictionary *)config
{
  ABI39_0_0EXUpdatesConfig *updatesConfig = [[ABI39_0_0EXUpdatesConfig alloc] init];
  [updatesConfig loadConfigFromDictionary:config];
  return updatesConfig;
}

- (void)loadConfigFromDictionary:(NSDictionary *)config
{
  id isEnabled = config[ABI39_0_0EXUpdatesConfigEnabledKey];
  if (isEnabled && [isEnabled isKindOfClass:[NSNumber class]]) {
    _isEnabled = [(NSNumber *)isEnabled boolValue];
  }
  
  id expectsSignedManifest = config[@"ABI39_0_0EXUpdatesExpectsSignedManifest"];
  if (expectsSignedManifest && [expectsSignedManifest isKindOfClass:[NSNumber class]]) {
    _expectsSignedManifest = [(NSNumber *)expectsSignedManifest boolValue];
  }
  
  id updateUrl = config[ABI39_0_0EXUpdatesConfigUpdateUrlKey];
  if (updateUrl && [updateUrl isKindOfClass:[NSString class]]) {
    NSURL *url = [NSURL URLWithString:(NSString *)updateUrl];
    _updateUrl = url;
  }

  id scopeKey = config[ABI39_0_0EXUpdatesConfigScopeKeyKey];
  if (scopeKey && [scopeKey isKindOfClass:[NSString class]]) {
    _scopeKey = (NSString *)scopeKey;
  }

  // set updateUrl as the default value if none is provided
  if (!_scopeKey) {
    if (_updateUrl) {
      _scopeKey = [[self class] normalizedURLOrigin:_updateUrl];
    } else {
      @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                     reason:@"expo-updates must be configured with a valid update URL or scope key."
                                   userInfo:@{}];
    }
  }

  id requestHeaders = config[ABI39_0_0EXUpdatesConfigRequestHeadersKey];
  if (requestHeaders) {
    if(![requestHeaders isKindOfClass:[NSDictionary class]]){
      @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                     reason:[NSString stringWithFormat:@"PList key '%@' must be a string valued Dictionary.", ABI39_0_0EXUpdatesConfigRequestHeadersKey]
                                   userInfo:@{}];
    }
    _requestHeaders = (NSDictionary *)requestHeaders;
    
    for (id key in _requestHeaders){
      if (![_requestHeaders[key] isKindOfClass:[NSString class]]){
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"PList key '%@' must be a string valued Dictionary.", ABI39_0_0EXUpdatesConfigRequestHeadersKey]
                                     userInfo:@{}];
      }
    }
  }

  id releaseChannel = config[ABI39_0_0EXUpdatesConfigReleaseChannelKey];
  if (releaseChannel && [releaseChannel isKindOfClass:[NSString class]]) {
    _releaseChannel = (NSString *)releaseChannel;
  }

  id launchWaitMs = config[ABI39_0_0EXUpdatesConfigLaunchWaitMsKey];
  if (launchWaitMs && [launchWaitMs isKindOfClass:[NSNumber class]]) {
    _launchWaitMs = (NSNumber *)launchWaitMs;
  } else if (launchWaitMs && [launchWaitMs isKindOfClass:[NSString class]]) {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    _launchWaitMs = [formatter numberFromString:(NSString *)launchWaitMs];
  }

  id checkOnLaunch = config[ABI39_0_0EXUpdatesConfigCheckOnLaunchKey];
  if (checkOnLaunch && [checkOnLaunch isKindOfClass:[NSString class]]) {
    if ([ABI39_0_0EXUpdatesConfigNeverString isEqualToString:(NSString *)checkOnLaunch]) {
      _checkOnLaunch = ABI39_0_0EXUpdatesCheckAutomaticallyConfigNever;
    } else if ([ABI39_0_0EXUpdatesConfigWifiOnlyString isEqualToString:(NSString *)checkOnLaunch]) {
      _checkOnLaunch = ABI39_0_0EXUpdatesCheckAutomaticallyConfigWifiOnly;
    } else if ([ABI39_0_0EXUpdatesConfigAlwaysString isEqualToString:(NSString *)checkOnLaunch]) {
      _checkOnLaunch = ABI39_0_0EXUpdatesCheckAutomaticallyConfigAlways;
    }
  }

  id sdkVersion = config[ABI39_0_0EXUpdatesConfigSDKVersionKey];
  if (sdkVersion && [sdkVersion isKindOfClass:[NSString class]]) {
    _sdkVersion = (NSString *)sdkVersion;
  }

  id runtimeVersion = config[ABI39_0_0EXUpdatesConfigRuntimeVersionKey];
  if (runtimeVersion && [runtimeVersion isKindOfClass:[NSString class]]) {
    _runtimeVersion = (NSString *)runtimeVersion;
  }

  id hasEmbeddedUpdate = config[ABI39_0_0EXUpdatesConfigHasEmbeddedUpdateKey];
  if (hasEmbeddedUpdate && [hasEmbeddedUpdate isKindOfClass:[NSNumber class]]) {
    _hasEmbeddedUpdate = [(NSNumber *)hasEmbeddedUpdate boolValue];
  }
}

- (BOOL)isMissingRuntimeVersion
{
  return (!_runtimeVersion || !_runtimeVersion.length) && (!_sdkVersion || !_sdkVersion.length);
}

+ (NSString *)normalizedURLOrigin:(NSURL *)url
{
  NSString *scheme = url.scheme;
  NSNumber *port = url.port;
  if (port && port.integerValue > -1 && [port isEqual:[[self class] defaultPortForScheme:scheme]]) {
    port = nil;
  }

  return (port && port.integerValue > -1)
    ? [NSString stringWithFormat:@"%@://%@:%ld", scheme, url.host, (long)port.integerValue]
    : [NSString stringWithFormat:@"%@://%@", scheme, url.host];
}

+ (nullable NSNumber *)defaultPortForScheme:(NSString *)scheme
{
  if ([@"http" isEqualToString:scheme] || [@"ws" isEqualToString:scheme]) {
    return @(80);
  } else if ([@"https" isEqualToString:scheme] || [@"wss" isEqualToString:scheme]) {
    return @(443);
  } else if ([@"ftp" isEqualToString:scheme]) {
    return @(21);
  }
  return nil;
}

@end

NS_ASSUME_NONNULL_END
