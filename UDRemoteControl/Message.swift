//
//  Message.swift
//  UDRemoteControl
//
//  Created by UDLab on 01/08/16.
//  Copyright © 2016 UDLab. All rights reserved.
//

import Foundation

class Message{
    
    let speed:Int?
    let speedFloat:Float?
    let steering:Int?
    let steeringFloat:Float?
    let id:Int!
    
    init(id:Int,speed:Int,steering:Int){
        self.id = id
        self.speed = speed
        self.steering = steering
        self.speedFloat = 0.0
        self.steeringFloat = 0.0
    }
    
    init(id:Int,speed:Float,Steering:Float){
        self.id = id
        self.speedFloat = speed
        self.steeringFloat = Steering
        self.speed = 0
        self.steering = 0
    }
    
    
}