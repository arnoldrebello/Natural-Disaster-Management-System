//
//  LoginViewController.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 6/9/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.errorMessage.text = e.localizedDescription
            }
            else {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.tabBarController?.hidesBottomBarWhenPushed = true
        }
        
        }
    }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.text = ""
        // Do any additional setup after loading the view.
        tabBarController?.tabBar.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
