//
//  SettingsViewController.swift
//  Deno
//
//  Created by WSR on 25/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var emailField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emailField.text = UserDefaults.standard.string(forKey: "Login")
    }
    
    @IBAction func exitClick(_ sender: Any) {
        performSegue(withIdentifier: "Login", sender: self)
    }
    
    
    @IBAction func privacyClick(_ sender: Any) {
        
        guard let url = URL(string: "https://anytimecar.ru/files/docs/anytime.confidence.pdf") else { return }
        UIApplication.shared.open(url)
        
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
