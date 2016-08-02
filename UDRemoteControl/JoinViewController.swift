//
//  JoinViewController.swift
//  UDRemoteControl
//
//  Created by UDLab on 06/12/15.
//  Copyright © 2015 UDLab. All rights reserved.
//

import UIKit
import CocoaMQTT

//This is the main part of the App. It deals with the connection and setting the protocol for the sending msg from the remote and retreving data


class JoinViewController: UIViewController , DataSendDelegate{
    
    var userName:String?
    var port:Int?
    var ipAddress:String?
    var qos:Int?
    var password:String?
    var checkState:Bool! = false
    

    var mqtt:CocoaMQTT?
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var AddressInput: UITextField!
    @IBOutlet weak var PortInput: UITextField!
    @IBOutlet weak var Status: UILabel!
    //Variable to enable hiding the button
    @IBOutlet weak var Verbinden_btn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    
    // Connect OR Disconnect to Server with the given Address and Port
    @IBAction func Verbinden_btn(sender: UIButton) {
        
        //Checking in which State the Button is on to carry out connect or Disconnect action
        if(Verbinden_btn.currentTitle!.containsString(ButtonState.Disconnect.rawValue)){
            mqtt?.disconnect()
        }else{//Checking For Empty Address
            if !AddressInput.text!.isEmpty{
                
                if !PortInput.text!.isEmpty{
                    let portstring = PortInput.text
                    
                    //Checks if portInput is only Number
                    if let portS = Int(portstring!){
                        ipAddress = AddressInput.text!
                        self.port = portS
                        userDefaults.setValue(ipAddress, forKey: DefaultKey.IpAddress.rawValue)
                        userDefaults.setInteger(port!, forKey: DefaultKey.LastPort.rawValue)
                        //tcpConnect(Address: AddressInput.text!, Port: port )
                        setup()
                        mqttConnect()
                    }else{
                        Alert.show("Port Eingabe Fehler", message: "Port soll nur nummer sein", vc: self)
                        
                    }
                    
                }else{
                    Alert.show("Port nummer", message: "Bitte geben Sie ein Port nummber von Mqtt Server", vc: self)
                    
                }
            }else{
                
                Alert.show("Ip Address Fehler", message: "Bitte geben Sie ein Mqtt Server IP Address", vc: self)
                
            }

            
        }
    }
    
    func setup(){
         
        let clientIdPid = "UDDrive-\(userName)-" + String(NSProcessInfo().processIdentifier)
        userName = userDefaults.valueForKey(DefaultKey.UserName.rawValue) as? String
        qos = userDefaults.integerForKey(DefaultKey.QOS.rawValue)
        password = userDefaults.valueForKey(DefaultKey.Password.rawValue) as? String
        
        mqtt = CocoaMQTT(clientId: clientIdPid, host: ipAddress!, port: UInt16(port!))
        if let mqtt = mqtt{
            mqtt.username = userName
            mqtt.password = password
            mqtt.willMessage = CocoaMQTTWill(topic: "will", message: "dieout")
            mqtt.keepAlive = 90
            mqtt.delegate = self
        }
        
    }
    
    func mqttConnect() {
       let connection = mqtt!.connect()
        userDefaults.setBool(connection, forKey: DefaultKey.ISCONNECTED.rawValue)
 
    }
    
    override func viewWillAppear(animated: Bool) {
        checkState = userDefaults.valueForKey(DefaultKey.ISCONNECTED.rawValue) as! Bool
        mqtt?.ping()
    }
    
    
    //Change Title of the Button to apprioprate state title
    func stateChangeInConnected(isConnected :Bool) {
        
        if(isConnected){
            Verbinden_btn.setTitle(ButtonState.Disconnect.rawValue, forState: UIControlState.Normal)
            self.reloadInputViews()
            connectionStatusLabel.text = "Connected"
            connectionStatusLabel.textColor = UIColor.blueColor()
            
        }
        else{
            Verbinden_btn.setTitle(ButtonState.Connect.rawValue, forState: UIControlState.Normal)
            self.reloadInputViews()
            connectionStatusLabel.text = "Disconnected"
            connectionStatusLabel.textColor = UIColor.redColor()
        }
     
        
        
    }
    

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromJoinToRemote"{
            let remoteVC:RemotePanelViewController = segue.destinationViewController as! RemotePanelViewController
            //first check if the valuekey reading is giving out nil value then if it is nil then the first value is added to the key and the mqtt client object is passed to theremovepanelViewcController
            if(remoteVC.mqtt == nil){
                remoteVC.mqtt = mqtt
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        connectionStatusLabel.text = ""
        userNameLabel.text = userDefaults.valueForKey(DefaultKey.UserName.rawValue) as? String
        checkState = userDefaults.valueForKey(DefaultKey.ISCONNECTED.rawValue) as! Bool
        mqtt?.ping()
    
    }
    
    
    
    func dataSend(data:String){
        
        mqtt?.publish("/control/speedsteering/value", withString: data)
        print("sending" + data)
    }
}

extension JoinViewController : CocoaMQTTDelegate{
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
        stateChangeInConnected(true)
    }

    func mqtt(mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        //print("didConnectAck \(ack.rawValue)")
        if ack == .ACCEPT {
            mqtt.subscribe("/sensor/speed/value", qos: CocoaMQTTQOS.QOS1)
            mqtt.ping()
            
            //let chatViewController = storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as? ChatViewController
            //chatViewController?.mqtt = mqtt
            //navigationController!.pushViewController(chatViewController!, animated: true)
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
        //NSNotificationCenter.defaultCenter().postNotificationName("MQTTMessageNotification" + animal!, object: self, userInfo: ["message": message.string!, "topic": message.topic])
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
        if(checkState!){
            stateChangeInConnected(true)
            checkState = false
        }
        
    }
    
    func mqttDidDisconnect(mqtt: CocoaMQTT, withError err: NSError?) {
        _console("mqttDidDisconnect")
        userDefaults.setBool(false, forKey: DefaultKey.ISCONNECTED.rawValue)
        stateChangeInConnected(false)
    }
    
    func _console(info: String) {
        print("Delegate: \(info)")
    }
    

}

