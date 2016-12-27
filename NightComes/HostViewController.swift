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
    @IBOutlet weak var Label_Instructions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get my identity
        self.ref.child(self.SessionId!).child("Clients").child("Host").child("Identity").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            self.MyIdentity = snapshot.value as? String
            
        })
        
        self.IsGameEnd { (rc) in
            if rc > 0 {
                
                if rc == 1 {
                    self.Label_Instructions.text = "Game is over, Villager wins"
                    self.ref.child(self.SessionId!).child("Instructions").updateChildValues(["Next": "Game is over, Villager wins"])
                }
                else if rc == 2 {
                    self.Label_Instructions.text = "Game is over, Wolf wins"
                    self.ref.child(self.SessionId!).child("Instructions").updateChildValues(["Next": "Game is over, Wolf wins"])
                }
                
                return
            }
        }
        
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

    // Check if game ends
    func IsGameEnd(completion: @escaping (Int) -> ()) {
        
        var NumOfVil = 0
        var NumOfWolf = 0
        var NumOfSaint = 0
        
        self.ref.child(self.SessionId!).child("Clients").observeSingleEvent(of: FIRDataEventType.value, with: {
            
            snapshot in
            
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                
                if rest.childSnapshot(forPath: "Identity").value as! String == "Villager" {
                    print("found a vil")
                    NumOfVil += 1
                }
                else if rest.childSnapshot(forPath: "Identity").value as! String == "Wolf" {
                    print("found a wolf")
                    NumOfWolf += 1
                    print("Number of actual wolves : ", NumOfWolf)
                }
                else {
                    print("found a saint")
                    NumOfSaint += 1
                }
            }
            
            
            print("Number of wolves : ", NumOfWolf)
            
            if NumOfWolf == 0 {
                
                // Game finished, villa wins
                completion(1)
            }
            else if NumOfVil == 0 || NumOfSaint == 0
            {
                // Wolf wins
                completion(2)
            }
            else
            {
                // Not yet
                completion(-1)
            }
            
        })
        
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
