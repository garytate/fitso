//
//  LoginVC.swift
//  fitsoiOS
//
//  Created by Gary Tate on 21/03/2017.
//  Copyright © 2017 Gary Tate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import TextFieldEffects

class LoginVC: UIViewController {

    @IBOutlet var tapBackground: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var isPasswordShown:Bool = false
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emptyWarning: UILabel!
    
    //Button to show the password
    @IBAction func eyeButton(_ sender: UIButton) {
        if (!isPasswordShown) {
            passwordField.isSecureTextEntry = false
            isPasswordShown = true
        } else {
            passwordField.isSecureTextEntry = true
            isPasswordShown = false
        }
    }
    
    @IBAction func tappedBackground(_ sender: Any) {
        
    }
    @IBAction func pressRegisterButton(_ sender: UIButton) {
        performSegue(withIdentifier: "segueRegisterFromLogin", sender: self)
    }
    
    @IBAction func pressForgotButton(_ sender: UIButton) {
        performSegue(withIdentifier: "segueForgotFromLogin", sender: self)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if (emailField.text! == "" || passwordField.text! == "") {
            emptyWarning.text = "A field was left empty"
            emptyWarning.isHidden = false
        } else {
            emptyWarning.isHidden = true
            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if error == nil {
                    print("Login was a success.")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    self.emptyWarning.isHidden = false
                    self.emptyWarning.text = "Invalid Username or Password"
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
