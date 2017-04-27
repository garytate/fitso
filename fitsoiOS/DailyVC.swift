//
//  DailyVC.swift
//  fitsoiOS
//
//  Created by Gary Tate on 29/03/2017.
//  Copyright © 2017 Gary Tate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DailyVC: UIViewController {
    
    var currentState:Bool = true
    var situpNumberVule: Int = 0
    var pressupNumberVule: Int = 0
    var starjumpNumberVule: Int = 0
    var lastDate: String!
    var catchGetDateError: Bool = false
    var medalsInArray: NSArray = []
    @IBOutlet weak var pressupValue: UILabel!
    @IBOutlet weak var starjumpValue: UILabel!
    
    func getCurrentMedals() {
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
            self.medalsInArray = [bronze, silver, gold]
            
        }) { (error) in
            print(error.localizedDescription)
        }
        return self.medalsInArray
    }
    
    func checkIfNewDay() -> Bool {
        let currDate = getCurrentDate()
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("user").child(userID!).child("dates").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let situp:Int = value?["lastSaveDate"] as? String ?? "Date Invalid"
            if situp != "Date Invalid" {
                self.lastDate = situp
            } else {
                print("Error, date not able to be recieved from the database")
                self.catchGetDateError = true
                saveCurrentDate(currDate)
            }
        })
        if (!self.catchGetDateError) {
            if (self.lastDate == self.currDate) {
                print("Day has not moved on.")
                return false
            } else {
                print("Day has moved on!")
                return true
            }
        }
        return true
    }
    
    func giveMedalsAndSetScoresToZero() {
        
        var giveBronzeQuantity: Int = 0
        var giveSilverQuantity: Int = 0
        var giveGoldQuantity: Int = 0
        
        //Check the amount of situps
        if (25 <= self.situpNumberVule < 50) {
            giveBronzeQuantity += 1
        } else if (50 <= self.situpNumberVule < 75) {
            giveSilverQuantity += 1
        } else if (75 <= self.situpNumberVule <= 100) {
            giveGoldQuantity += 1
        } else {
            print("score too low to give a medal.")
        }
        
        //Check the amount of pressups
        if (25 <= self.pressupNumberVule < 50) {
            giveBronzeQuantity += 1
        } else if (50 <= self.pressupNumberVule < 75) {
            giveSilverQuantity += 1
        } else if (75 <= self.pressupNumberVule <= 100) {
            giveGoldQuantity += 1
        } else {
            print("score too low to give a medal.")
        }
        
        //Check the amount of star jumps
        if (25 <= self.starjumpNumberVule < 50) {
            giveBronzeQuantity += 1
        } else if (50 <= self.starjumpNumberVule < 75) {
            giveSilverQuantity += 1
        } else if (75 <= self.starjumpNumberVule <= 100) {
            giveGoldQuantity += 1
        } else {
            print("score too low to give a medal.")
        }
        
        let currentAmounts = getCurrentMedals()
        var newBronzeAmounts: Int = currentAmounts[0] + giveBronzeQuantity
        var newSilverAmounts: Int = currentAmounts[1] + giveSilverQuantity
        var newGoldAmounts: Int = currentAmounts[2] + giveGoldQuantity
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()!.currentUser!.uid
        let key = ref.child("user").child(user).child("dates")
        ref.child("user/\(user)/bronzeMedals").setValue(newBronzeAmounts)
        ref.child("user/\(user)/silverMedals").setValue(newSilverAmounts)
        ref.child("user/\(user)/goldMedals").setValue(newGoldAmounts)
        
        //sets to zero
        self.situpNumberVule = 0
        self.pressupNumberVule = 0
        self.starjumpNumberVule = 0
        
    }
    
    func saveCurrentData(String: currentDate) {
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()!.currentUser!.uid
        let key = ref.child("user").child(user).child("dates")
        ref.child("user/\(user)/dates/lastSaveDate").setValue(currentDate)
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component (.day, from: date)
        
        let newDate:String = ("\(day)/\(month)/\(year)")
        
        return newDate
    }
    
    //Addition and Minus Buttons Outlets
    @IBOutlet weak var situpAddition: UIButton!
    @IBOutlet weak var situpMinus: UIButton!
    @IBOutlet weak var pressupAddition: UIButton!
    @IBOutlet weak var pressupMinus: UIButton!
    @IBOutlet weak var starjumpAddition: UIButton!
    @IBOutlet weak var starjumpMinus: UIButton!
    
    
    //Navigation Bar Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //Navigation Bar Functions
    @IBAction func logoutButtonFunction(_ sender: Any) {
        //Performs a logout attempt and then redirects the user to the login screen.
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        performSegue(withIdentifier: "segueLoginFromDaily", sender: self)
        

    }
    
    @IBAction func editButtonFunction(_ sender: Any) {
        //This is a complex function which will be in three parts
        
        //First part - change the title of the button
        changeEditButtonText()
        
        //Second part - enabling the plus and minus buttons if edit is pressed
        if !checkIfButtonIsEdit() {
            //This will be inverted, so using ! will ask for the not value - negating the effect
            enableTheButtons()
        } else {
            disableTheButtons()
        }
        
    }
    
    func enableTheButtons() {
        self.situpAddition.isEnabled = true
        self.situpMinus.isEnabled = true
        self.pressupAddition.isEnabled = true
        self.pressupMinus.isEnabled = true
        self.starjumpAddition.isEnabled = true
        self.starjumpMinus.isEnabled = true
    }
    
    func disableTheButtons() {
        self.situpAddition.isEnabled = false
        self.situpMinus.isEnabled = false
        self.pressupAddition.isEnabled = false
        self.pressupMinus.isEnabled = false
        self.starjumpAddition.isEnabled = false
        self.starjumpMinus.isEnabled = false
    }
    
    
    func changeEditButtonText() {
        //Changes the edit button title between two states.
        if checkIfButtonIsEdit() {
            self.editButton.title = "Save Changes"
        } else {
            self.editButton.title = "Edit"
        }
    }
    
    func checkIfButtonIsEdit() -> Bool {
        currentState = !currentState
        return !currentState
    }
    
    func getSitUpValue() {
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
            self.situpValue.text = ("\(self.situpNumberVule) / 100")
            self.pressupValue.text = ("\(self.pressupNumberVule) / 100")
            self.starjumpValue.text = ("\(self.starjumpNumberVule) / 100")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        //var changesWereASuccess = false
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()!.currentUser!.uid
        let key = ref.child("user").child(user).child("daily")
        ref.child("user/\(user)/daily/situp").setValue(self.situpNumberVule)
        ref.child("user/\(user)/daily/pressup").setValue(self.pressupNumberVule)
        ref.child("user/\(user)/daily/starjump").setValue(self.starjumpNumberVule)
        
        
    }
    @IBOutlet weak var savedChangesText: UITextField!
    
    ////SIT UP STUFF////
    //Outlets
    @IBOutlet weak var situpValue: UILabel!
    
    //Functions
    @IBAction func situpPlusValue(_ sender: Any) {
        self.situpNumberVule += 1
        self.situpValue.text = ("\(situpNumberVule) / 100")
    }
    
    @IBAction func situpMinusValue(_ sender: Any) {
        self.situpNumberVule -= 1
        self.situpValue.text = ("\(situpNumberVule) / 100")
    }
    
    @IBAction func pressupPlusValue(_ sender: Any) {
        self.pressupNumberVule += 1
        self.pressupValue.text = ("\(self.pressupNumberVule) / 100")
    }
    @IBAction func situpKeyboard(_ sender: Any) {
        let alertController = UIAlertController(title: "Value", message: "Please enter your amount of sit ups", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                let numberInString: String = String(describing: alertController.textFields?[0])
                let numberInputted: Int = Int(numberInString)!
                print(numberInputted)
                // store your data
                UserDefaults.standard.set(field.text, forKey: "userEmail")
                UserDefaults.standard.synchronize()
                
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "Enter your number."
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        var sitUpNumber = getSitUpValue()
        print("hello")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
