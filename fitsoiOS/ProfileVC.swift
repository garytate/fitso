//
//  ProfileVC.swift
//  fitsoiOS
//
//  Created by Gary Tate on 24/03/2017.
//  Copyright © 2017 Gary Tate. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ProfileVC: UIViewController {


    @IBOutlet weak var displaynameLabel: UILabel!
    @IBOutlet weak var goldmedalsLabel: UILabel!
    @IBOutlet weak var silvermedalsLabel: UILabel!
    @IBOutlet weak var bronzemedalsLabel: UILabel!
    @IBOutlet weak var totaldistanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        /*
        Pulls the data from the online databse and displays it
        in the empty slots to show the user how they are doing
        */
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("user").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["nickname"] as? String ?? "cool"
            let gold = value?["goldMedals"] as? Int ?? -1
            let silver = value?["silverMedals"] as? Int ?? -1
            let bronze = value?["bronzeMedals"] as? Int ?? -1
            let total = (bronze + silver + gold)
            // ...
            
            self.displaynameLabel.text = ("USERNAME: \(username)")
            self.goldmedalsLabel.text = ("GOLD: \(gold)")
            self.silvermedalsLabel.text =  ("SILVER: \(silver)")
            self.bronzemedalsLabel.text = ("BRONZE: \(bronze)")
            self.totaldistanceLabel.text = ("TOTAL: \(total)")
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

}
