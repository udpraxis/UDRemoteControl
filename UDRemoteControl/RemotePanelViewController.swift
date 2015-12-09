//
//  RemotePanelViewController.swift
//  UDRemoteControl
//
//  Created by UDLab on 06/12/15.
//  Copyright © 2015 UDLab. All rights reserved.
//

import UIKit
import CoreMotion

class RemotePanelViewController: UIViewController, SettingDelegates{
    
    var delegate : DataSendDelegate?
    
    
    
    //Motion manager
    var motionManager = CMMotionManager()
    
    @IBOutlet weak var Gyro_Manual: UISwitch!
    
    @IBOutlet weak var Acceleration_label: UILabel!
    @IBOutlet weak var Rotation_labe: UILabel!
    
    @IBOutlet weak var Up_Down: UIView!
    @IBOutlet weak var Left_Right: UIView!
    
    //Function to display output
    @IBOutlet weak var x_acce: UILabel!
    @IBOutlet weak var y_acce: UILabel!
    @IBOutlet weak var z_acce: UILabel!
    
    @IBOutlet weak var x_rota: UILabel!
    @IBOutlet weak var y_rota: UILabel!
    @IBOutlet weak var z_rota: UILabel!
    
    @IBOutlet weak var Constant_Acceleration: UILabel!
    @IBOutlet weak var StaticAccelerationDuringNonGyro: UISwitch!
    
    
    @IBOutlet weak var Beschleunigen_btn: UIImageView!
    @IBOutlet weak var Lengkung_btn: UIImageView!
    
    
    
    @IBAction func GyroOption(sender: UISwitch) {
        
        if sender.on{
            
            Beschleunigen_btn.hidden = true
            Lengkung_btn.hidden = true
            Up_Down.hidden = true
            Left_Right.hidden = true
        
            Acceleration_label.hidden = false
            Rotation_labe.hidden = false
            
            //Getting the Time interval for the update
            motionManager.accelerometerUpdateInterval = 0.5
            motionManager.gyroUpdateInterval = 0.5
            
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {(accelerometerData: CMAccelerometerData? , error: NSError?) -> Void in
                self.outputAccelerationData(accelerometerData!.acceleration)
                if (error != nil){
                    print("\(error)")
                }
            })
            
            
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {(gyroData: CMGyroData?, error: NSError?) -> Void in
                self.outputRotationData(gyroData!.rotationRate)
                if (error != nil){
                    print("\(error)")
                }
                
            })
            
            
        }else{
            
            motionManager.stopAccelerometerUpdates()
            motionManager.stopGyroUpdates()
            reset()

        }

    }
    
    
    
    //Reset Function to set the property to when gyro is not available
    func reset(){
        
        
        Acceleration_label.hidden = true
        Rotation_labe.hidden = true
        
        Lengkung_btn.hidden = false
        Beschleunigen_btn.hidden = false
        Up_Down.hidden = false
        Left_Right.hidden = false
        
        x_acce.text = ""
        y_acce.text = ""
        z_acce.text = ""
        
        x_rota.text = ""
        y_rota.text = ""
        z_rota.text = ""
        
    }
    
    //Use this to calibrate the gyro before use
    func calibrate(){
    
    }

    
    //funtion to deal with the acceleration data
    func outputAccelerationData(acceleration: CMAcceleration){
        
        if motionManager.accelerometerActive{
            
            let x_acceleration:Float
            let y_acceleration:Float
            let z_acceleration:Float
            
            if motionManager.accelerometerActive{
                x_acceleration = Float(round(1000*acceleration.x)/1000)
                y_acceleration = Float(round(1000*acceleration.y)/1000)
                z_acceleration = Float(round(1000*acceleration.z)/1000)
                
                //Display acceleration value
                x_acce.text = String(x_acceleration)
                y_acce.text = String(y_acceleration)
                z_acce.text = String(z_acceleration)
                
                tcpsendinfo(dataX: x_acceleration, dataY: y_acceleration, dataZ: z_acceleration)
                
            }
        }
        
    }
    
    
    //funtion to deal with Gyro data
    func outputRotationData(rotation:CMRotationRate){
        
        if motionManager.gyroActive{
            let x_rotation:Float
            let y_rotation:Float
            let z_rotation:Float
            
            if motionManager.gyroActive{
                x_rotation = Float(round(1000*rotation.x)/1000)
                y_rotation = Float(round(1000*rotation.y)/1000)
                z_rotation = Float(round(1000*rotation.z)/1000)
                
                //Display acceleration value
                x_rota.text = String(x_rotation)
                y_rota.text = String(y_rotation)
                z_rota.text = String(z_rotation)
                
                //UnComment This part to allow the gyro msg send to the server 
                //tcpsendinfo(dataX: x_rotation , dataY: y_rotation, dataZ: z_rotation)
            }
        }
    }
    
    
    //The Funtion to get the data from SettingsViewController
    func settings(gyro_senstivitiy: Float, isAccelerationGyro: Bool, isSteeringGyro: Bool) {
        
    }
    
    func tcpsendinfo(dataX dataX: Float,dataY:Float,dataZ:Float){
        
        let s_datax = plusminussign(dataX);
        let s_datay = plusminussign(dataY);
        let s_dataz = plusminussign(dataZ);
        
        let accumulated_Data = "CM" + ":" + s_datax + ":" + s_datay + ":" + s_dataz
        //This is where the Delegate to send data appear
        delegate?.dataSend(accumulated_Data)
        
    }
    
    //Require to add in "+" and "-" symbol in to the data sent to server
    func plusminussign(data: Float) -> String{
        var Str_data:String = " "
        var Str_data_temp:String = " "
        
        if data >= 0{
            Str_data_temp = "+\(data)"
            Str_data = checkdata(Str_data_temp)
            
        }else if data < 0{
            Str_data_temp = "\(data)"
            Str_data = checkdata(Str_data_temp)
        }
        
        return Str_data
    }
    
    // ensure the number of byte is always very useful if eg 0.120 is the value
    // then the last zero will be omitted by the compiler so to avoid error in arduino side "0" 
    // is replaces with "0"
    func checkdata(var s_data:String) -> String{
        if(s_data.characters.count < 6){
            repeat{
                s_data.insert("1", atIndex: s_data.endIndex)
            }while s_data.characters.count < 6
        }
        return s_data
    }
    
    override func viewDidDisappear(animated: Bool) {
        motionManager.stopAccelerometerUpdates()
        motionManager.startGyroUpdates()
        Gyro_Manual.on = false
        
        
        
        
    }
    
    override func viewDidLoad() {
       
    }
    
    @IBAction func LengkungPan(sender: UIPanGestureRecognizer) {
   
        //Why this Left_Righ(View) and the Lengkung_btn is checked because
        //deactivating the gyro will produce error
        if Left_Right.hidden == false && Lengkung_btn.hidden == false{
            let translation = sender.translationInView(self.view)
            print(translation)
                if let view = sender.view{
                    
                  if (Lengkung_btn.center.x > Left_Right.bounds.minX + 5 )&&(Lengkung_btn.center.x < Left_Right.bounds.maxX  ){
                    view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
                  }
            
            }
                sender.setTranslation(CGPointZero, inView: self.view)
            
        }
        
     
        if sender.state == UIGestureRecognizerState.Ended{
            Lengkung_btn.center.x = Left_Right.bounds.width/2
        }
        
    }
    
    @IBAction func BeschleunigungPan(sender: UIPanGestureRecognizer) {
        
        //Why this Left_Righ(View) and the Lengkung_btn is checked because
        //deactivating the gyro will produce error
        if Up_Down.hidden == false && Beschleunigen_btn.hidden == false{
            let translation = sender.translationInView(self.view)
            print(translation)
            if let view = sender.view{
                
                if (Beschleunigen_btn.center.y > Up_Down.bounds.minY )&&(Beschleunigen_btn.center.y < Up_Down.bounds.maxY){
                    view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                }
                
            }
            sender.setTranslation(CGPointZero, inView: self.view)
            
        }
        
        
        if sender.state == UIGestureRecognizerState.Ended{
            Beschleunigen_btn.center.y = Up_Down.bounds.height/2
        }
        
    }

    
    
    
      
}



//Delegate to send data to TcpConnection in JoinViewController
protocol DataSendDelegate: class{
    func dataSend(data:String)
}
