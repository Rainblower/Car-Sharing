//
//  SignUpViewController.swift
//  Deno
//
//  Created by WSR on 25/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {

    @IBOutlet weak var passwordFiel: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var repasswordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordFiel.delegate  = self
        repasswordField.delegate = self
        loginField.delegate = self
        repasswordField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "Back", sender: self)
    }
    
   
    @IBAction func signUp(_ sender: Any) {
        guard let url = URL(string: "http://cars.areas.su/signup") else { return }
        
        if loginField.text == "" {
            let alert = UIAlertController(title: "Empty usermane" , message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        if emailField.text == "" {
            let alert = UIAlertController(title: "Empty email", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        if passwordFiel.text != repasswordField.text {
            let alert = UIAlertController(title: "Passwords must be same", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        let params: Parameters = ["username" : loginField.text, "email" : emailField.text, "password" : passwordFiel.text]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(value)
                let answer = json["notice"]["answer"].stringValue
                
                if answer != "Success" {
                    let alert = UIAlertController(title: answer.capitalized, message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
                
                

               
                
                self.performSegue(withIdentifier: "Back", sender: self)
                let alert = UIAlertController(title: answer.capitalized, message: nil, preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: .cancel)
                                alert.addAction(action)
                            self.present(alert, animated: true)
            case .failure(let error):
                print(error)
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

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUp(self)
        return true
    }
}
