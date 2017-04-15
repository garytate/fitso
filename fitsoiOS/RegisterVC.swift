//
//  RegisterVC.swift
//  fitsoiOS
//
//  Created by Gary Tate on 21/03/2017.
//  Copyright © 2017 Gary Tate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import TextFieldEffects

class RegisterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nicknameField: AkiraTextField!
    @IBOutlet weak var ageField: AkiraTextField!
    @IBOutlet weak var confirmpasswordField: AkiraTextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func createAccount(_ sender: Any) {
        if (emailField.text == "" || passwordField.text == "" || confirmpasswordField.text == "" || nicknameField.text == "" || ageField.text == "") {
            errorLabel.text = "You left a field blank."
            errorLabel.isHidden = false
        } else if (passwordField.text != confirmpasswordField.text) {
            errorLabel.text = "Your passwords do not match."
            errorLabel.isHidden = false
        }
        
        else {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if error == nil {
                    let userConstructor = ["nickname": self.nicknameField.text ?? "no nickname set",
                                           "age": self.ageField.text ?? "unknown age",
                                           "bronzeMedals": 0,
                                           "silverMedals": 0,
                                           "goldMedals": 0,
                                           "totalDistance": 0] as [String : Any]
                    let ref = FIRDatabase.database().reference()
                    ref.child("user").child(user!.uid).setValue(userConstructor)
                    ref.child("exercises").setValue("pushups")
                    print("Account has been created.")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    self.errorLabel.text = error?.localizedDescription
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func PressLoginButon(_ sender: UIButton) {
        performSegue(withIdentifier: "segueLoginFromRegister", sender: self)
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
