//
//  HostConfigViewController.swift
//  NightComes
//
//  Created by LiuKangping on 21/12/2016.
//  Copyright © 2016 leomac. All rights reserved.
//

import UIKit
import FirebaseDatabase

// 1 is village, 2 is wolf, 3 is witch, 4 is hunter, 5 is guard ,6 is prophet, 7 is elders

class HostConfigViewController: UIViewController {
    
    
    @IBOutlet weak var BTN_READY: UIButton!
    
    @IBOutlet weak var LBL_Villager: UILabel!
    @IBOutlet weak var LBL_Wolf: UILabel!
    
    // Member Configs
    @IBOutlet weak var Switch_Witch: UISwitch!
    @IBOutlet weak var Switch_Hunter: UISwitch!
    @IBOutlet weak var Switch_Guard: UISwitch!
    @IBOutlet weak var Switch_Prophet: UISwitch!
    @IBOutlet weak var Switch_Elders: UISwitch!
    
    // Session ID label
    @IBOutlet weak var Label_SessionId: UILabel!
    
    
    var AllMembers = [String]()
    var SessionId : String? = nil
    var counter : Int = 1
    var totoal = [Int]()
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.BTN_READY.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Back button event handler
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil && self.SessionId != nil {
            self.ref.child(self.SessionId!).removeValue()
        }
    }
    
    @IBAction func Action_Config_Read(_ sender: Any) {
        
        var rc : Int = 0
        
        let session = self.ref.childByAutoId()
        session.child("Instructions").updateChildValues(["Next" : "Waiting for clients"])
        session.child("Clients").child("Host").updateChildValues(["Identity" : "nil", "Alive" : "yes", "Info" : "nil"])
        self.SessionId = session.key
        
        self.BTN_READY.isEnabled = false
        
        self.Label_SessionId.text = self.SessionId
        
        // Get totally number of clients
        self.totoal.removeAll()
        rc = Int(self.LBL_Villager.text!)!
        
        while rc != 0 {
            self.totoal.append(1)
            
            rc -= 1
        }
        
        rc = Int(self.LBL_Wolf.text!)!
        
        while rc != 0 {
            self.totoal.append(2)
            
            rc -= 1
        }
        
        if self.Switch_Guard.isOn {
            self.totoal.append(5)
        }
        
        if self.Switch_Witch.isOn {
            self.totoal.append(3)
        }
        
        if self.Switch_Elders.isOn {
            self.totoal.append(7)
        }
        
        if self.Switch_Prophet.isOn {
            self.totoal.append(6)
        }
        
        if self.Switch_Hunter.isOn {
            self.totoal.append(4)
        }
        
        print("total is : ", self.totoal.count)
        
        self.AllMembers.removeAll()
        self.AllMembers.append("Host")
        
        self.counter = 1
        self.ref.child(self.SessionId!).child("Clients").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            
            if snapshot.key != "Host" {
                self.counter += 1
                self.AllMembers.append(snapshot.key)
            }
            
            if self.counter == self.totoal.count {
                self.performSegue(withIdentifier: "ShowHostView", sender: nil)
            }
            
        })
    }
    
    @IBAction func Action_Test(_ sender: Any) {
        
        if self.SessionId != nil {
            self.ref.child(self.SessionId!).child("Clients").child("leo").updateChildValues(["Identity" : "nil", "Alive" : "yes", "Info" : "nil"])
            self.ref.child(self.SessionId!).child("Clients").child("clove").updateChildValues(["Identity" : "nil", "Alive" : "yes", "Info" : "nil"])
            self.ref.child(self.SessionId!).child("Clients").child("eric").updateChildValues(["Identity" : "nil", "Alive" : "yes", "Info" : "nil"])
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var rc : Int? = nil
        
        self.BTN_READY.isEnabled = true
        
        // Loop throught our members
        for aMember in self.AllMembers {
            
            // Get an identity
            rc = Int(arc4random_uniform(UInt32(self.totoal.count)))
            
            print("client ", aMember, " is : ", GetIdentity(index: self.totoal[rc!]))
            
            self.ref.child(self.SessionId!).child("Clients").child(aMember).updateChildValues(["Identity" : GetIdentity(index: self.totoal[rc!])])
            
            if self.totoal[rc!] == 3 {
                // 1 has both, 2 only has cure, 3 only has poison
                self.ref.child(self.SessionId!).child("Clients").child(aMember).updateChildValues(["Info" : "1"])
            }
            
            
            self.totoal.remove(at: rc!)
            
        }
        
        self.ref.removeAllObservers()
        
        if segue.identifier == "ShowHostView" {
            let target = segue.destination as! HostViewController
            target.SessionId = self.SessionId!
        }
    }

    // Steppers!!!
    @IBAction func Action_Stepper_Villager(_ sender: UIStepper) {
        
        self.LBL_Villager.text = String(Int(sender.value))
    }
    
    @IBAction func Action_Stepper_Wolf(_ sender: UIStepper) {
        self.LBL_Wolf.text = String(Int(sender.value))
    }
    
    // Map identity and numbers
    func GetIdentity(index : Int) -> String {
        
        if index == 1 {
            return "Villager"
        }
        else if index == 2 {
            return "Wolf"
        }
        else if index == 3 {
            return "Witch"
        }
        else if index == 4 {
            return "Hunter"
        }
        else if index == 5 {
            return "Guard"
        }
        else if index == 6 {
            return "Prophet"
        }
        else if index == 7 {
            return "Elders"
        }
        
        return "nil"
    }

    
}



