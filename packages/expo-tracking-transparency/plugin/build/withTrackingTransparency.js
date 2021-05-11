"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.withUserTrackingPermission = exports.DEFAULT_NSUserTrackingUsageDescription = void 0;
const config_plugins_1 = require("@expo/config-plugins");
const pkg = require('expo-tracking-transparency/package.json');
exports.DEFAULT_NSUserTrackingUsageDescription = 'Allow this app to collect app-related data that can be used for tracking you or your device.';
const withTrackingTransparency = (config, props) => {
    config = exports.withUserTrackingPermission(config, props);
    return config;
};
exports.withUserTrackingPermission = (config, { userTrackingPermission } = {}) => {
    var _a;
    if (userTrackingPermission === false || userTrackingPermission === 'false') {
        if ((_a = config === null || config === void 0 ? void 0 : config.ios) === null || _a === void 0 ? void 0 : _a.infoPlist) {
            delete config.ios.infoPlist.NSUserTrackingUsageDescription;
        }
    }
    else {
        if (!config.ios)
            config.ios = {};
        if (!config.ios.infoPlist)
            config.ios.infoPlist = {};
        config.ios.infoPlist.NSUserTrackingUsageDescription =
            userTrackingPermission ||
                config.ios.infoPlist.NSUserTrackingUsageDescription ||
                exports.DEFAULT_NSUserTrackingUsageDescription;
    }
    return config;
};
exports.default = config_plugins_1.createRunOncePlugin(withTrackingTransparency, pkg.name, pkg.version);
