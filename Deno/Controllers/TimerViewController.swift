//
//  TimerViewController.swift
//  Deno
//
//  Created by WSR on 25/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TimerViewController: UIViewController {

    @IBOutlet weak var timerLable: UILabel!
    var minutes = 14
    var seconds = 59
    override func viewDidLoad() {
        super.viewDidLoad()

        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        guard let url = URL(string: "http://cars.areas.su/bookcancel") else { return }
        
        
        let params: Parameters = ["idBook" : UserDefaults.standard.string(forKey: "idBook") , "token" : UserDefaults.standard.string(forKey: "Token")]
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                
                let alert = UIAlertController(title: "Thank you!", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true, completion: {
                    self.performSegue(withIdentifier: "Map", sender: self)
                })
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func stop(_ sender: Any) {
        self.performSegue(withIdentifier: "Drive", sender: self)

    
        
       
    }
    
    @objc func fireTimer() {
        
        seconds -= 1
        if seconds == 0 {
            minutes -= 1
            seconds = 60
        }
        if minutes == 0 {
            stop(self)
        }
        
        if seconds < 10 {
            if minutes < 10 {
                timerLable.text = "00:0\(minutes):0\(seconds)"
            } else {
                timerLable.text = "00:\(minutes):0\(seconds)"
            }
        } else {
            if minutes < 10 {
                timerLable.text = "00:0\(minutes):\(seconds)"
            } else {
                timerLable.text = "00:\(minutes):\(seconds)"
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
