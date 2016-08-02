//
//  UDdriverUserViewController.swift
//  UDRemoteControl
//
//  Created by UDLab on 01/08/16.
//  Copyright © 2016 UDLab. All rights reserved.
//

import UIKit

class UDdriverUserViewController: UIViewController {

    let userDefault = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var anonymousLabel: UILabel!
    @IBOutlet weak var qosLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        driverNameLabel.text = userDefault.valueForKey(DefaultKey.UserName.rawValue) as? String
        if let anonymous:Bool =  userDefault.boolForKey(DefaultKey.AnonymouseOption.rawValue){
            if(anonymous){
                anonymousLabel.text = "Username or password is required for the Mqtt server"
            }else{
                anonymousLabel.text = "No username or password is required for the Mqtt server"

            }
            
            if let qosInt:Int = userDefault.integerForKey(DefaultKey.QOS.rawValue){
                qosLabel.text = String(qosInt)
            }
                
            
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
