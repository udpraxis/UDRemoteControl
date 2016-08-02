//
//  DefaultEnum.swift
//  UDRemoteControl
//
//  Created by UDLab on 02/08/16.
//  Copyright © 2016 UDLab. All rights reserved.
//

import Foundation

enum ButtonState:String {
    case Disconnect = "Disconnect"
    case Connect = "Verbinden"
}


enum DefaultKey:String {
    case UserName = "driverName"
    case AnonymouseOption = "anonymous"
    case QOS = "qos"
    case Password = "password"
    case IpAddress = "Ip"
    case LastPort = "port"
    case GyroSensitivitySetting = "gyroSens"
    case GyroAccelerateSetting = "gyroacc"
    case GyroSteerSetting = "gyroturn"
    case ISCONNECTED = "connection"
    case ClientExist = "MqttClient"
}

enum UDTopic:String{
    case SpeedSteering = "/control/speedSteering/value"
    case speedReading = "/sensor/speed/value"
}

enum StartStopTitle:String{
    case Start = "Start"
    case Stop = "Stop"
}


