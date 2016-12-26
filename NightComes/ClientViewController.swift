//
//  ClientViewController.swift
//  NightComes
//
//  Created by LiuKangping on 21/12/2016.
//  Copyright © 2016 leomac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClientViewController: UIViewController {

    var SessionId : String? = nil
    var MyIdentity : String? = nil
    
    @IBOutlet weak var BTN_Identity: UIButton!
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("My identity is : ", self.MyIdentity ?? "nil")
        
        
//        self.ref.observeSingleEvent(of: FIRDataEventType.childRemoved, with: { (snapshot) in
//            
//            if snapshot.key == self.SessionId {
//                self.navigationController?.popToRootViewController(animated: true)
//                return
//            }
//            
//        })
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
                    self.ref.observeSingleEvent(of: FIRDataEventType.childRemoved, with: { (snapshot) in
            
                        if snapshot.key == self.SessionId {
                            self.navigationController?.popToRootViewController(animated: true)
                            return
                        }
                        
                    })
            
            DispatchQueue.main.async {
                self.ref.child(self.SessionId!).child("Instructions").observe(FIRDataEventType.childChanged, with: { (snapshot) in
                    
                    
                    print("Next instruction is : ", snapshot.value ?? "nil")
                })            }
        }
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Action_BTN_Identity(_ sender: Any) {
        
        if self.BTN_Identity.titleLabel?.text == "Identity"{
            self.BTN_Identity.setTitle(self.MyIdentity, for: .normal)
        }
        else
        {
            self.BTN_Identity.setTitle("Identity", for: .normal)
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
