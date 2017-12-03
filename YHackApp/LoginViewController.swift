//
//  LoginViewController.swift
//  YHackApp
//
//  Created by Jack Boyce on 12/2/17.
//  Copyright © 2017 Jack Boyce. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        
        sleep(1)
        
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! ViewController
        mainViewController.fbid = usernameTextField.text!
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }

}
