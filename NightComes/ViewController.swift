//
//  ViewController.swift
//  NightComes
//
//  Created by LiuKangping on 21/12/2016.
//  Copyright © 2016 leomac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITextFieldDelegate {
        
    // Text fields
    @IBOutlet weak var TextField_RoomID: UITextField!
    @IBOutlet weak var TextField_Name: UITextField!
    
    // Label
    @IBOutlet weak var Label_Info: UILabel!
    
    // Button
    @IBOutlet weak var BTN_Join_Game: UIButton!
    @IBOutlet weak var BTN_Create_Game: UIButton!
    
    var ref : FIRDatabaseReference? = nil

    var MyIdentity : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.TextField_RoomID.delegate = self
        self.TextField_Name.delegate = self
        
        self.Label_Info.text = ""
        self.BTN_Join_Game.isEnabled = true
        self.BTN_Create_Game.isEnabled = true
        self.TextField_Name.text = ""
        self.TextField_RoomID.text = ""
        
        self.ref = FIRDatabase.database().reference()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Button Actions
    @IBAction func Action_Create_Game(_ sender: Any) {
        

    }
    
    @IBAction func Action_Join_Game(_ sender: Any) {
        
        if self.TextField_Name.text != nil {
                        
            if self.TextField_Name.text == "Host" {
                
                self.Label_Info.text = "Invalid user name : Host"
                self.TextField_Name.text = ""
                return
            }
            
            
            self.ref?.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                
                if snapshot.hasChild(self.TextField_RoomID.text!) {
                    self.Label_Info.text = "Waiting for other users"
                    self.BTN_Join_Game.isEnabled = false
                    self.BTN_Create_Game.isEnabled = false
                    
                    if snapshot.childSnapshot(forPath: self.TextField_RoomID.text!).childSnapshot(forPath: "Clients").hasChild(self.TextField_Name.text!) == false {
                        self.ref?.child(self.TextField_RoomID.text!).child("Clients").child(self.TextField_Name.text!).updateChildValues(["Identity" : "nil", "Alive" : "yes", "Info" : "nil"])
                    }
                    else
                    {
                        self.performSegue(withIdentifier: "ShowClientView", sender: nil)
                        return
                    }
                    
                }
                else
                {
                    self.Label_Info.text = "Invalid Session ID"
                    self.TextField_RoomID.text = ""
                }
                
            })
            
            // Listen if I got identity
            self.ref?.child(self.TextField_RoomID.text!).child("Clients").child(self.TextField_Name.text!).observeSingleEvent(of: FIRDataEventType.childChanged, with: { (snapshot) in
                
                if snapshot.key == "Identity" {
                    self.MyIdentity = snapshot.value as! String?
                    print("My identity is ", snapshot.value ?? "nil")
                    self.performSegue(withIdentifier: "ShowClientView", sender: nil)
                }
                
            })
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.BTN_Join_Game.isEnabled = true
        self.BTN_Create_Game.isEnabled = true
        
        if segue.identifier == "ShowClientView" {
            let target = segue.destination as! ClientViewController
            
            target.SessionId = self.TextField_RoomID.text
            target.MyIdentity = self.MyIdentity
        }
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

