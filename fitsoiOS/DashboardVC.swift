//
//  DashboardVC.swift
//  fitsoiOS
//
//  Created by Gary Tate on 21/03/2017.
//  Copyright © 2017 Gary Tate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MKRingProgressView
import TextFieldEffects

class dashboardVC: UIViewController {

    var situpNumberVule: Int = 0
    var pressupNumberVule: Int = 0
    var starjumpNumberVule: Int = 0
    
    @IBOutlet weak var objectiveLabel: UILabel!

    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var ringProgress: MKRingProgressView!
    
    @IBAction func logoutButton(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        performSegue(withIdentifier: "segueLoginFromDashboard", sender: self)
        
    }
    
    @IBOutlet weak var numberProgress: UILabel!
    
    
    func doesUserHavePersonalGoal() {
        
    }
    
    func setDailyProgressPercentage() -> Double {
        var testValue:Int = 0
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("user").child(userID!).child("daily").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let situp:Int = value?["situp"] as? Int ?? 0
            let pressup:Int = value?["pressup"] as? Int ?? 0
            let starjumps:Int = value?["starjump"] as? Int ?? 0
            self.situpNumberVule = situp
            self.pressupNumberVule = pressup
            self.starjumpNumberVule = starjumps
        }) { (error) in
            print(error.localizedDescription)
        }
        let mathNumber: Int = ((self.situpNumberVule + self.pressupNumberVule + self.starjumpNumberVule) / 3)
        
        self.numberProgress.text = ("\(mathNumber)%")
        return Double(mathNumber / 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func drawRingProgress() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        ringProgress.progress = setDailyProgressPercentage()
        CATransaction.commit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drawRingProgress()
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
