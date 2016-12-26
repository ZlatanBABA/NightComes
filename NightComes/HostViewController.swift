//
//  HostViewController.swift
//  NightComes
//
//  Created by LiuKangping on 21/12/2016.
//  Copyright © 2016 leomac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HostViewController: UIViewController {

    var SessionId : String? = nil
    var MyIdentity : String? = nil
    
    let ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var BTN_Identity: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get my identity
        self.ref.child(self.SessionId!).child("Clients").child("Host").child("Identity").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            self.MyIdentity = snapshot.value as? String
            
        })
        
    }
    
    @IBAction func Action_BTN_Identity(_ sender: Any) {
        
        if self.BTN_Identity.titleLabel?.text == "Identity" {
            self.BTN_Identity.setTitle(self.MyIdentity, for: .normal)
        }
        else
        {
            self.BTN_Identity.setTitle("Identity", for: .normal)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            self.ref.child(self.SessionId!).removeValue()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
