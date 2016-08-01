//
//  JoinViewController.swift
//  UDRemoteControl
//
//  Created by UDLab on 06/12/15.
//  Copyright © 2015 UDLab. All rights reserved.
//

import UIKit

//This is the main part of the App. It deals with the connection and setting the protocol for the sending msg from the remote and retreving data


class JoinViewController: UIViewController , DataSendDelegate{
    
 
    
    @IBOutlet weak var AddressInput: UITextField!
    @IBOutlet weak var PortInput: UITextField!
    @IBOutlet weak var Status: UILabel!

    
    //Variable to enable hiding the button
    @IBOutlet weak var Disconnect_btn: UIButton!
    @IBOutlet weak var Verbinden_btn: UIButton!
    
    
    // Connect to Server with the given Address and Port
    @IBAction func Verbinden_btn(sender: UIButton) {
        
        //Checking For Empty Address
        if !AddressInput.text!.isEmpty{
            
            if !PortInput.text!.isEmpty{
                let portstring = PortInput.text
                
                //Checks if portInput is only Number
                if let port = Int(portstring!){
                    
                    //tcpConnect(Address: AddressInput.text!, Port: port )
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
    
    func MqttConnect(ipAddress:String, port:Int) -> Bool {
        return false
    }

    
   
    

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromJoinToRemote"{
            let remoteVC:RemotePanelViewController = segue.destinationViewController as! RemotePanelViewController
            remoteVC.delegate  = self
        }
    }
    
    
    override func viewDidLoad() {
        
    }

    
    
    
    func dataSend(data:String){
        
        //please add the funtion to send data
        print("sending")
    }
}