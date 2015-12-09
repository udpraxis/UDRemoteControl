//
//  ClientServerModel.swift
//  UDRemoteControl
//
//  Created by UDLab on 08/12/15.
//  Copyright © 2015 UDLab. All rights reserved.
//

import Foundation

class TCP {
    
    var client = TCPClient()
    var successfullyConnected:Bool = false
    var errormsg: String = ""
    
    //TCP connect function
    func connect(Address addr:String,portInString:String){
        
        let port = Int(portInString)!
        
        client = TCPClient(addr: addr, port: port)
        
        (successfullyConnected,errormsg) = client.connect(timeout: 1)
        
        if successfullyConnected{
            print(errormsg)
        }else{
            print(errormsg)
        }
    }
    
    //Send message to tcp server function
    func sendmsgtoserver(accumulatedData:String){
        client.send(str: accumulatedData)
    }
    
    //disconnect from the server
    func disconnectfromserver(){
        (successfullyConnected,errormsg) = client.close()
    }
    
    
    //recieve message from the server
    func recievemessagefromserver()->String{
        var stringdata = String(client.read(20))
        return stringdata
    }
}
