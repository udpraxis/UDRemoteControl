//
//  SettingsViewController.swift
//  UDRemoteControl
//
//  Created by UDLab on 06/12/15.
//  Copyright © 2015 UDLab. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingDataRetrive {

    var delegate:SettingDelegates?
    
    @IBOutlet weak var GyroSentivity: UISlider!
    
    @IBOutlet weak var GyroForAcceleration: UISwitch!
    @IBOutlet weak var GyroForSteering: UISwitch!
    
    
   
    
    func sendDataToRemoteViewController(){
        let gyro_Senstivity = NSTimeInterval(GyroSentivity.value)
        let implementAccelerationGyro = GyroForAcceleration.on
        let implementSteeringGyro = GyroForSteering.on
        
        delegate?.settings(gyro_Senstivity,isAccelerationGyro: implementAccelerationGyro,isSteeringGyro: implementSteeringGyro)
    }
    
    
    func activateDelegateCommunication() {
        sendDataToRemoteViewController()
    }
    
}

protocol SettingDelegates: class{
    func settings(gyro_senstivitiy:NSTimeInterval, isAccelerationGyro:Bool,isSteeringGyro:Bool)
}
