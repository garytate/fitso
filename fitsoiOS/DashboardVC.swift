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
import MKRingProgressView
import TextFieldEffects

class dashboardVC: UIViewController {

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func drawRingProgress() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        ringProgress.progress = 0.74
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
