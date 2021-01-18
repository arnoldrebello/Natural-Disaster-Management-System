//
//  ChatViewController.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 7/2/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    let db = Database.database().reference(withPath: "general")
    var messages: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Emergency Helpline"
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadMessages()
        // Do any additional setup after loading the view.
    }
    
    func loadMessages()
    {self.messages = []
        var messageBody:String = ""
        var loggedUser:String = ""
        db.queryOrdered(byChild: "timestamp").observe(.childAdded) { (Snapshot) in
            
            let data = Snapshot.value as? NSDictionary

            messageBody = data?["message"] as? String ?? ""
            loggedUser = data?["user"] as? String ?? ""

               let newMessage = Message(user: loggedUser, message: messageBody)
            print(newMessage)
                self.messages.append(newMessage)
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            tabBarController?.tabBar.isHidden = false
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
        @IBAction func sendPressed(_ sender: Any) {
            if let messageBody = messageTextField.text,let messageSender = Auth.auth().currentUser?.email {
                let timestamp = Double(Date().timeIntervalSince1970*1000)
                messageTextField.text = ""
                db.childByAutoId().setValue(["user":messageSender, "message": messageBody, "timestamp": timestamp.rounded()])
//                db.collection("messages").addDocument(data: ["sender":messageSender, "body": messageBody, "date": Date().timeIntervalSince1970]) { (error) in
//                    if let e = error {
//                        print("There was an issue saving data to firestore, \(e)")
//                    }
//                    else {
//                        print("Successful")
//
    
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

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label.text = message.message
        
        //This is a message from the current user.
        if message.user == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            cell.label.textColor = UIColor.white
        }
            //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor.lightGray
            cell.label.textColor = UIColor.black
        }
        
        return cell
    }
    
    
}

