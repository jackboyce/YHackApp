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
    @IBAction func LoginButtonPressed(_ sender: Any) {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! ViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }

}
