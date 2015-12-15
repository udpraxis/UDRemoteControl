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
    
    @IBOutlet weak var SegueToRemote: UIBarButtonItem!
    
    var tcpClient = TCPClient()
    
    @IBOutlet weak var AddressInput: UITextField!
    @IBOutlet weak var PortInput: UITextField!
    @IBOutlet weak var Status: UILabel!
    
    //Variable to enable hiding the button
    @IBOutlet weak var Disconnect_btn: UIButton!
    @IBOutlet weak var Verbinden_btn: UIButton!
    var isConnected = false
    
    //make sure to remove this on release
    var TestingCondition = true
    
    //State of the Button Verbinden and Disconnect
    
    
    
    //Disconnect to Server
    @IBAction func Disconnect_btn(sender: UIButton) {
        
    }
    
    
    // Connect to Server with the given Address and Port
    @IBAction func Verbinden_btn(sender: UIButton) {
        
        //Checking For Empty Address
        if !AddressInput.text!.isEmpty{
            
            if !PortInput.text!.isEmpty{
                let portstring = PortInput.text
                
                //Checks if portInput is only Number
                if let port = Int(portstring!){
                    
                    tcpConnect(Address: AddressInput.text!, Port: port )
                }

            }else{
                Status.text = "Bitte geben Port ein"
            }
        }else{
            Status.text = "Bitte geben Server IP ein  "
            }
        }

    
   
    
    @IBAction func test(sender: UIButton) {
        SegueToRemote.enabled = true
    }
    
    //Function which deal to connect 
    func tcpConnect(Address addr: String, Port port:Int){
        
        tcpClient = TCPClient(addr: addr, port: port)
        
        var(success,errormsg) = tcpClient.connect(timeout: 1)
        if success{
            print(errormsg)
            isConnected = true
            Status.text = "Erfolgreiche Verbindung"
            Status.textColor = UIColor.blueColor()
            //Enabling Disconnect button
            Disconnect_btn.hidden = false
            //Enabling RemoteSegue
            SegueToRemote.enabled = true
            //Hide Verbinden btn
            Verbinden_btn.hidden = true
            
        }else{
            print(errormsg)
            Status.text = "Verbindung fehlgeschlagen"
            Status.textColor = UIColor.redColor()
            Disconnect_btn.hidden = true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromJoinToRemote"{
            let remoteVC:RemotePanelViewController = segue.destinationViewController as! RemotePanelViewController
            remoteVC.delegate  = self
        }
    }
    
    
    
    
    func dataSend(data:String){
        
        tcpClient.send(str: data)
    }
}




