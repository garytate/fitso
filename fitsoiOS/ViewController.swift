//
//  ViewController.swift
//  fitsoiOS
//
//  Created by Gary Tate on 21/03/2017.
//  Copyright © 2017 Gary Tate. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseDatabase


/* Not Used //
class UserAccount: NSObject {
    var name = String()
    var password = String()
}
*/

let appVersion = "1.0"
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Testing the program.  This is version \(appVersion)")
        let isUserLoggedIn:Bool = false
        segueIfUserIsLoggedIn(userStatus: isUserLoggedIn)
    }

    
    func segueIfUserIsLoggedIn( userStatus: Bool ) {
        //checks to see the status of the user, sends to screen - always runs on app launch.
        if (FIRAuth.auth()?.currentUser == nil) {
            performSegue(withIdentifier: "sendToLogin", sender: self)
        } else {
            performSegue(withIdentifier: "sendToDashboard", sender: self)
        }
    }


}

