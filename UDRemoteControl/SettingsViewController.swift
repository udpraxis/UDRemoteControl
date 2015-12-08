//
//  SettingsViewController.swift
//  UDRemoteControl
//
//  Created by UDLab on 06/12/15.
//  Copyright © 2015 UDLab. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var delegate:SettingDelegates?
    
    @IBOutlet weak var GyroSentivity: UISlider!
    
    @IBOutlet weak var GyroForAcceleration: UISwitch!
    @IBOutlet weak var GyroForSteering: UISwitch!
    
    
   
    
    func sendDataToRemoteViewController(){
        let gyro_Senstivity = GyroSentivity.value
        let implementAccelerationGyro = GyroForAcceleration.on
        let implementSteeringGyro = GyroForSteering.on
        
        delegate?.settings(gyro_Senstivity,isAccelerationGyro: implementAccelerationGyro,isSteeringGyro: implementSteeringGyro)
    }
    
    
}

protocol SettingDelegates: class{
    func settings(gyro_senstivitiy:Float, isAccelerationGyro:Bool,isSteeringGyro:Bool)
}
