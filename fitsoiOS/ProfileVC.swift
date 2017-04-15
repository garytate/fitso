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
        let ref = FIRDatabase.database().reference()
        let UserID = FIRAuth.auth()?.currentUser?.uid
        ref.child("user").child(UserID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayname = value?["nickname"] as? String ?? "Nickname Missing"
            let bronzeMedals = value?["bronzeMedals"] as? String ?? "no bronze in db"
            let silverMedals = value?["silverMedals"] as? String ?? "no silver in db"
            let goldMedals = value?["goldMedals"] as? String ?? "no gold in db"
            let totalDistance = value?["totalDistance"] as? String ?? "no total in db"
            
            print(bronzeMedals, silverMedals, goldMedals)

            self.displaynameLabel.text = ("Username: \(displayname)")
            self.goldmedalsLabel.text = ("Gold medals: \(goldMedals)")
            self.silvermedalsLabel.text = ("Silver medals: \(silverMedals)")
            self.bronzemedalsLabel.text = ("Bronze medals: \(bronzeMedals)")
            self.totaldistanceLabel.text = ("Total distance: \(totalDistance)")
        })
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
            let total = value?["totalDistance"] as? Int ?? -1
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
