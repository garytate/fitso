//
//  ForgotPasswordVC.swift
//  fitsoiOS
//
//  Created by Gary Tate on 21/03/2017.
//  Copyright © 2017 Gary Tate. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class ForgotPasswordVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var emailField: UITextField!
    @IBAction func forgotButton(_ sender: Any) {
        /*
        This is a built in function to the Firebase framework
        which allows me to pull an email as a parameter
        and the framework will send the user a password reset email
        */
        FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!) { error in
            print("Password reset has been sent.")
        }
    }
    
    @IBAction func pressLogin(_ sender: UIButton) {
        //Sends the user back to the login screen
        performSegue(withIdentifier: "segueLoginFromForgot", sender: self)
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
