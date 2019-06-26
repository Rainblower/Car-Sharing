//
//  ViewController.swift
//  Deno
//
//  Created by WSR on 25/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  
        loginField.delegate = self
        passField.delegate = self
    }

    @IBAction func signInClick(_ sender: Any) {
      login()
    }
    
    func login() {
        guard let url = URL(string: "http://cars.areas.su/login") else { return }
        
        let params: Parameters = ["username" : loginField.text, "password" : passField.text]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(value)
                let answer = json["notice"]["answer"].stringValue
                
                if answer == "User is active" {
                    self.logout()
                    return
                }
                
                if answer == "Error username or password" {
                    let alert = UIAlertController(title: "Error username or password", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
                
                let token = json["notice"]["token"].stringValue
                
                UserDefaults.standard.set(self.loginField.text, forKey: "Login")
                UserDefaults.standard.set(self.passField.text, forKey: "Password")
                UserDefaults.standard.set(token, forKey: "Token")
                
                self.performSegue(withIdentifier: "Main", sender: self)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func logout() {
        guard let url = URL(string: "http://cars.areas.su/logout") else { return }
        
        let params: Parameters = ["username" : loginField.text]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(value)
                
                self.login()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func createClick(_ sender: Any) {
    }
    
    @IBAction func forgotClick(_ sender: Any) {
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        login()
        return true
    }
}
