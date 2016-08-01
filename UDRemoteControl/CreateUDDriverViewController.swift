//
//  CreateUDDriverViewController.swift
//  UDRemoteControl
//
//  Created by UDLab on 01/08/16.
//  Copyright © 2016 UDLab. All rights reserved.
//

import UIKit

class CreateUDDriverViewController: UIViewController {
    
    
    let driverNameKey = "driverName"
    let AnonymousOption = "anonymous"
    let qos = "qos"
    let password = "password"
    let lastIp = "Ip"
    let lastPort = "port"
    let gyroSensitivity = "gyroSens"
    let gyroAccelerate = "gyroacc"
    let gyroSteer = "gyroturn"
    
    let toJoinSegue:String = "FromUserCreateToJoin"
    
    let userDefault = NSUserDefaults.standardUserDefaults()
    var isChangesMade = false

    @IBOutlet weak var driverNameTextView: UITextField!
    @IBOutlet weak var anonymousOption: UISwitch!
    @IBOutlet weak var qosChoice: UISegmentedControl!
    @IBOutlet weak var mqttClientLabel: UILabel!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var mqttConfig: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        udViewChange()
    }
    
    override func viewDidAppear(animated: Bool) {
        udViewChange()
    }
    
    
    //repeated view check funtions
    func udViewChange() {
        
        if let drivername = userDefault.valueForKey(driverNameKey){
            mqttClientLabel.text = drivername as? String
            
            driverNameTextView.text = drivername as? String
            
            
            // making View Mqtt Config hidden or appear
            let onOff = userDefault.boolForKey(AnonymousOption)
            
            if(onOff){
                mqttConfig.hidden = false
                anonymousOption.setOn(true, animated: true)
            }else{
                mqttConfig.hidden = true
                anonymousOption.setOn(false, animated: true)
            }
            
            qosChoice.selectedSegmentIndex = userDefault.integerForKey(qos)
        }else{
            driverNameTextView.placeholder = "Neue Benutzer erstellen"
            mqttClientLabel.text = "Bitte neue Benutzer erstellen"
        }


    }
    
    
    func test() {
        print(userDefault.valueForKey(driverNameKey))
        print(userDefault.valueForKey(gyroSensitivity))
        print(userDefault.valueForKey(gyroSteer))
        print(userDefault.valueForKey(gyroAccelerate))
    }
    
    func checkForValueChanges(){
        if(((!(driverNameTextView.text?.isEmpty)! && !driverNameTextView.text!.containsString(userDefault.valueForKey(driverNameKey) as! String)))){
            userDefault.setValue(driverNameTextView.text, forKey: driverNameKey)
            isChangesMade = true
            print("driver name is changed")
        }
        if(anonymousOption.on != userDefault.boolForKey(AnonymousOption)){
            userDefault.setBool(anonymousOption.on, forKey: AnonymousOption)
            isChangesMade = true
            print("anonymousoption is changed")
        }
        
        if(qosChoice.selectedSegmentIndex != userDefault.integerForKey(qos)){
            userDefault.setInteger(qosChoice.selectedSegmentIndex, forKey: qos)
            isChangesMade = true
            print("QOS is changed")
        }

        
        if(anonymousOption.on){
            if(!passwordTextView.text!.containsString(userDefault.valueForKey(password) as! String)){
                userDefault.setValue(passwordTextView.text, forKey: password)
                print("password is changed")
            }
        }
    }
    
    
    // toggle the Mqtt config view making it available or not
    @IBAction func anonymousChanged(sender: UISwitch) {
        if( sender.on){
            mqttConfig.hidden = false
        }else{
            mqttConfig.hidden = true
        }
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if(driverNameTextView.text!.isEmpty){
            if(userDefault.valueForKey(driverNameKey)?.empty != nil){
                Alert.show("Kein Benutzer", message: "Bitte ein Benutzer erstellen", vc: self)
                return false
            }
        }
        checkForValueChanges()
        if(isChangesMade){
            userDefault.synchronize()
        }
        
        
        
        return true
        
        
        }
    
    
}
    


