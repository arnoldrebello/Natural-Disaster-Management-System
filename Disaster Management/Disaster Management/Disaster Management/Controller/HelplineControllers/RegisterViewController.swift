//
//  RegisterViewController.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 6/9/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var RegErrorLabel: UILabel!
    
    @IBAction func registerPressed(_ sender: UIButton) {
          
           if let email = emailTextField.text, let password = passwordTextField.text {
               Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                   if let e = error {
                       print(e)
                    self.RegErrorLabel.text = e.localizedDescription
                   } else {
                       //Navigate to the ChatViewController
                       self.performSegue(withIdentifier: "registerSegue", sender: self)
                   }
               }
           }
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
