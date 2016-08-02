//
//  RemotePanelViewController.swift
//  UDRemoteControl
//
//  Created by UDLab on 06/12/15.
//  Copyright © 2015 UDLab. All rights reserved.
//

import UIKit
import CoreMotion
import CocoaMQTT

class RemotePanelViewController: UIViewController, SettingDelegates{
    
    var delegate : DataSendDelegate?
    var delegateRetrive : SettingDataRetrive?
    
    //Forward button is present in left and right only present when gyro is on
    @IBOutlet weak var Reverse_right_btn: UIButton!
    @IBOutlet weak var Reverse_left_btn: UIButton!
    @IBOutlet weak var geschwindigketLabel: UILabel!
    @IBOutlet weak var startStopBtn: UIButton!

    @IBOutlet weak var Gyro_Manual: UISwitch!

    //Useful to send a constant data about the vorward speed negleting all the gyro and hand gesture
    @IBOutlet weak var istKonstantBeschleunigung: UISwitch!
    
    @IBOutlet weak var Up_Down: UIView!
    @IBOutlet weak var Left_Right: UIView!

    @IBOutlet weak var Beschleunigen_btn: UIImageView!
    @IBOutlet weak var Lengkung_btn: UIImageView!
    
    
    
    //Data from the SettingViewController
    var isAccelerationGyroRV:Bool = true
    var isSteeringGyroRV:Bool = true
    var gyroupdateinterval:NSTimeInterval = 0.5
    
    //Function to display output
    
    var ID:Int64 = 1
    var pre_center_b:CGFloat = 0
    var pre_center_l:CGFloat = 0
    
    var timer = NSTimer()
    var startcommandisactive = false
    var thisisfirsttime = true
    
    //Motion manager
    var motionManager = CMMotionManager()
    
    var mqtt:CocoaMQTT? = nil
    
    @IBAction func GyroOption(sender: UISwitch) {
        
        
        
        if sender.on{
            
            
            if startcommandisactive{
                timer.invalidate()
        
            }
            
          
            Beschleunigen_btn.hidden = true
            Lengkung_btn.hidden = true
            Up_Down.hidden = true
            Left_Right.hidden = true
        
            
            
            //Getting the Time interval for the update
            motionManager.accelerometerUpdateInterval = gyroupdateinterval
            motionManager.gyroUpdateInterval = gyroupdateinterval
            
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
            
            
            reset()

        }

    }
    
    func Forward_gyro(){
        
    }
    
    //Reset Function to set the property to when gyro is not available
    func reset(){
        startStopBtn.setTitle("Start", forState: UIControlState.Normal)
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        thisisfirsttime = true
        
        //hid the the button for forwards and reverse in gyro
        Reverse_left_btn.hidden = true
        Reverse_right_btn.hidden = true
        
        Lengkung_btn.hidden = false
        Beschleunigen_btn.hidden = false
        Up_Down.hidden = false
        Left_Right.hidden = false
        Gyro_Manual.on = false
        
        timer.invalidate()
        
        Beschleunigen_btn.center.y = Up_Down.bounds.height/2
        Lengkung_btn.center.x = Left_Right.bounds.width/2
    }
    
    //Use this to calibrate the gyro before use
    func calibrate(){
    
    }

    
    //funtion to deal with the acceleration data
    func outputAccelerationData(acceleration: CMAcceleration){
            
            if motionManager.accelerometerActive{
                let x_acceleration = Float(round(1000*acceleration.x)/1000)
                let y_acceleration = Float(round(1000*acceleration.y)/1000)
                let z_acceleration = Float(round(1000*acceleration.z)/1000)
                
                mqttSendInfo(dataX: x_acceleration, dataY: y_acceleration)
                
            }
        
        
    }
    
    
    //funtion to deal with Gyro data
    func outputRotationData(rotation:CMRotationRate){
            
        if motionManager.gyroActive{
            let x_rotation = Float(round(1000*rotation.x)/1000)
            let y_rotation = Float(round(1000*rotation.y)/1000)
            let z_rotation = Float(round(1000*rotation.z)/1000)
            
            
            //UnComment This part to allow the gyro msg send to the server
            //tcpsendinfo(dataX: x_rotation , dataY: y_rotation, dataZ: z_rotation)
        }
        
    }
    
    
    //The Funtion to get the data from SettingsViewController
    func settings(gyro_senstivitiy: NSTimeInterval, isAccelerationGyro: Bool, isSteeringGyro: Bool) {
        isAccelerationGyroRV = isAccelerationGyro
        isSteeringGyroRV = isSteeringGyro
        gyroupdateinterval = gyro_senstivitiy
    }
    
    func mqttSendInfo(dataX dataX: Float,dataY:Float){
        
        let s_datax = plusminussign(dataX)
        let s_datay = plusminussign(dataY)
       
        
        let accumulated_Data:String = "CM" + ":" + s_datax + ":" + s_datay
        
        //Adding ID functionally
        //let finaldata = accumulated_Data + "ID" + String(ID) + "@\n"
        let finaldata = "ID=" + String(ID) + ":" + accumulated_Data + "\n"
        
        ID = ID + 1
        
        //This is where the Delegate to send data appear
        mqtt?.publish(UDTopic.SpeedSteering.rawValue, withString: finaldata)
        
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
    func checkdata(s_data:String) -> String{
        var data = s_data
        if(s_data.characters.count < 6){
            repeat{
                data.insert("1", atIndex: s_data.endIndex)
            }while s_data.characters.count < 6
        }
        return s_data
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        
        //This is important to stop the motionupdate if the user change the page
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        reset()
        
        //Do not delete the above code
    }
    
    override func viewDidLoad() {
        mqtt?.ping()
    }
    
    override func viewDidAppear(animated: Bool) {
        mqtt?.ping()
    }
    
    @IBAction func LengkungPan(sender: UIPanGestureRecognizer) {
        //Why this Left_Righ(View) and the Lengkung_btn is checked because
        //deactivating the gyro will produce error
        if Left_Right.hidden == false && Lengkung_btn.hidden == false{
            let translation = sender.translationInView(self.view)
            if let view = sender.view{
                if (Lengkung_btn.center.x > 3.0 )&&(Lengkung_btn.center.x < 258.0 ){
                    view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
                }
                //Avoid the possibile of jamming the button
                if(Lengkung_btn.center.x >= 258.0){
                    if(translation.x <= 0.0){
                        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
                    }
                }
                if(Lengkung_btn.center.x <= 3.0){
                    if(translation.x >= 0.0)
                    {
                        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
                    }
                }
            }
                sender.setTranslation(CGPointZero, inView: self.view)
        }
        if sender.state == UIGestureRecognizerState.Ended{
            Lengkung_btn.center.x = Left_Right.bounds.width/2
        }
        
    }
    
    
    
    @IBAction func BeschleunigungPan(sender: UIPanGestureRecognizer) {
        if Up_Down.hidden == false && Beschleunigen_btn.hidden == false{
            let translation = sender.translationInView(self.view)
            if let view  = sender.view{
                if(Beschleunigen_btn.center.y > 3.0) && (Beschleunigen_btn.center.y < 258.0 ) {
                    view.center = CGPoint(x: view.center.x , y: view.center.y + translation.y)
                }else if(Beschleunigen_btn.center.y >= 258.0){
                    if(translation.y <= 0.0){
                        view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                    }
                }else if(Beschleunigen_btn.center.y <= 3.0){
                    if(translation.y >= 0.0){
                        view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                    }
                }
            }
            sender.setTranslation(CGPointZero, inView: self.view)
        }
        if istKonstantBeschleunigung.on == false{
            //try to bring the button to center each time the first time
            //This will ensure the center of the btn is back to initial position a msg is also sent to the server
            if sender.state == UIGestureRecognizerState.Ended || thisisfirsttime == true{
                thisisfirsttime = false
                Beschleunigen_btn.center.y = Up_Down.bounds.height/2
            }
        }else {
            thisisfirsttime = true
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromRemoteToSettting"{
            let settingVC:SettingsViewController = segue.destinationViewController as! SettingsViewController
            settingVC.delegate  = self
        }
    }
    
    
    
    @IBAction func StartStop(sender: UIButton) {
        let stopMessage = "ID=" + String(ID) + ":ST:0:0\n"
        if(startStopBtn.currentTitle!.containsString(StartStopTitle.Start.rawValue)){
            startcommandisactive = true
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(RemotePanelViewController.dataManagerIfNonGyroDataIssend), userInfo: nil, repeats: true)
            startStopBtn.setTitle(StartStopTitle.Stop.rawValue, forState: UIControlState.Normal)

        }else{
            mqtt?.publish(UDTopic.SpeedSteering.rawValue, withString: stopMessage)
            timer.invalidate()
            startcommandisactive = false
            startStopBtn.setTitle(StartStopTitle.Start.rawValue, forState: UIControlState.Normal)
        }
    }

    

    
    
    func dataManagerIfNonGyroDataIssend(){
        
        let dataSpeed = String((260 - Int(Beschleunigen_btn.center.y))-130)
        let dataSteering = String(Int(Lengkung_btn.center.x - 130))
        
        
        
        let accumulatedData:String = "MC" + ":" + dataSpeed + ":" + dataSteering

        print("This is the speed", dataSpeed)
        print("This is the Turning",dataSteering)
        
        //Adding ID functionality
        //let finaldata:String = accumulatedData + ":ID" + String(ID) + "@\n"
        let finaldata:String = "ID=" + String(ID) + ":" + accumulatedData + "\n"
        ID = ID + 1
        
    
        mqtt?.publish(UDTopic.SpeedSteering.rawValue, withString: finaldata)    }
}



//Delegate to send data to TcpConnection in JoinViewController
protocol DataSendDelegate: class{
    func dataSend(data:String)
}


//Protocol to make the communication to retrieve
protocol SettingDataRetrive: class{
    func activateDelegateCommunication()
}

extension RemotePanelViewController : CocoaMQTTDelegate{
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        //print("didConnectAck \(ack.rawValue)")
        if ack == .ACCEPT {
            mqtt.subscribe(UDTopic.speedReading.rawValue, qos: CocoaMQTTQOS.QOS1)
            mqtt.ping()
  
        }
        
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceivedMessage: \(message.string) with id \(id)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }
    
    func mqttDidPing(mqtt: CocoaMQTT) {
        print("didPing")
        
    }
    
    func mqttDidReceivePong(mqtt: CocoaMQTT) {
        _console("didReceivePong")
        
    }
    
    func mqttDidDisconnect(mqtt: CocoaMQTT, withError err: NSError?) {
        _console("mqttDidDisconnect")
  
    }
    
    func _console(info: String) {
        print("Delegate: \(info)")
    }
    
    

}
