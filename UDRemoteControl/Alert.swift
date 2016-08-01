//
//  Alert.swift
//  UDRemoteControl
//
//  Created by UDLab on 01/08/16.
//  Copyright © 2016 UDLab. All rights reserved.
//

import UIKit

class Alert: NSObject {
  
    static func show(title:String,message:String,vc:UIViewController){
        //Create the Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create Aleart action
        let okAc = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(alert:UIAlertAction) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //Add Alert Actions to Alert Controller
        alertController.addAction(okAc)
        
        //Display Alert Controller
        vc.presentViewController(alertController, animated: true, completion: nil)
    }


}
