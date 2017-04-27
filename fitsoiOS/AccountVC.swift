//
//  NewAccountVC.swift
//  fitsoiOS
//
//  Created by Gary Tate on 23/03/2017.
//  Copyright © 2017 Gary Tate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import TextFieldEffects

class AccountVC: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    
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
            self.label.text = displayname
        })

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
