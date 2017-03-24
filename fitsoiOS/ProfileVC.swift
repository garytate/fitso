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
        let ref = FIRDatabase.database().reference()
        let UserID = FIRAuth.auth()?.currentUser?.uid
        ref.child("user").child(UserID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayname = value?["nickname"] as? String ?? "Nickname Missing"
            let bronzeMedals = value?["bronzeMedals"] as? String ?? "--"
            let silverMedals = value?["silverMedals"] as? String ?? "--"
            let goldMedals = value?["goldMedals"] as? String ?? "--"
            print(bronzeMedals, silverMedals, goldMedals)
            self.displaynameLabel.text = displayname
            self.goldmedalsLabel.text = goldMedals
            self.silvermedalsLabel.text = silverMedals
            self.bronzemedalsLabel.text = bronzeMedals
            self.totaldistanceLabel.text = "Meeds writing to DB"
        })
        
    }

}
