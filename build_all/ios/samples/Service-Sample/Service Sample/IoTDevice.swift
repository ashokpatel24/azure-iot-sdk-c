//
//  IoTDevice.swift
//  Service Sample
//
//  Created by Mark Radbourne on 9/26/17.
//  Copyright © 2017 Mark Radbourne. All rights reserved.
//

import Foundation

class IoTDevice {
    
    let _deviceId: String
    let _primaryKey: String
    let _secondaryKey: String
    let _generationId: String
    let _eTag: String
    let _connectionState: IOTHUB_DEVICE_CONNECTION_STATE
    let _connectionStateUpdatedtime: String
    let _status: IOTHUB_DEVICE_STATUS
    let _statusReason: String
    let _statusUpdatedTime: String
    let _lastActivityTime: String
    let _cloudToDeviceMessageCount: Int
    
    var deviceId: String { get { return _deviceId } }
    var primaryKey: String { get { return _primaryKey } }
    var secondaryKey: String { get { return _secondaryKey } }
    var generationId: String { get { return _generationId } }
    var eTag: String { get { return _eTag } }
    var connectionState: IOTHUB_DEVICE_CONNECTION_STATE { get { return _connectionState } }
    var connectionStateUpdatedtime: String { get { return _connectionStateUpdatedtime } }
    var status: IOTHUB_DEVICE_STATUS { get { return _status } }
    var statusReason: String { get { return _statusReason } }
    var statusUpdatedTime: String { get { return _statusUpdatedTime } }
    var lastActivityTime: String { get { return _lastActivityTime } }
    var cloudToDeviceMessageCount: Int { get { return _cloudToDeviceMessageCount } }
    
    init(rawDevice: IOTHUB_DEVICE) {
/*
        typedef struct IOTHUB_DEVICE_TAG
        {
            const char* deviceId;
            const char* primaryKey;
            const char* secondaryKey;
            const char* generationId;
            const char* eTag;
            IOTHUB_DEVICE_CONNECTION_STATE connectionState;
            const char* connectionStateUpdatedTime;
            IOTHUB_DEVICE_STATUS status;
            const char* statusReason;
            const char* statusUpdatedTime;
            const char* lastActivityTime;
            size_t cloudToDeviceMessageCount;
            
            bool isManaged;
            const char* configuration;
            const char* deviceProperties;
            const char* serviceProperties;
            IOTHUB_REGISTRYMANAGER_AUTH_METHOD authMethod;
        } IOTHUB_DEVICE;
*/
        _deviceId = String.init(cString: rawDevice.deviceId)
        _primaryKey = String.init(cString: rawDevice.primaryKey)
        _secondaryKey = String.init(cString: rawDevice.secondaryKey)
        _generationId = String.init(cString: rawDevice.generationId)
        _eTag = String.init(cString: rawDevice.eTag)
        _connectionStateUpdatedtime = String.init(cString: rawDevice.connectionStateUpdatedTime)
        _statusUpdatedTime = (rawDevice.statusUpdatedTime != nil) ? String.init(cString: rawDevice.statusUpdatedTime) : ""
        _statusReason = (rawDevice.statusReason != nil) ? String.init(cString: rawDevice.statusReason) : ""
        _lastActivityTime = (rawDevice.lastActivityTime != nil) ? String.init(cString: rawDevice.lastActivityTime) : ""
        _connectionState = rawDevice.connectionState
        _status = rawDevice.status
        _cloudToDeviceMessageCount = rawDevice.cloudToDeviceMessageCount
    }
}
