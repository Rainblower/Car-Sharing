//
//  DriveViewController.swift
//  Deno
//
//  Created by WSR on 25/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriveViewController: UIViewController {

    
    @IBOutlet weak var timerLable: UILabel!
    var seconds = 0
    var minutes = 0
    override func viewDidLoad() {
        super.viewDidLoad()

          let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        performSegue(withIdentifier: "Maps", sender: self)
        
        guard let url = URL(string: "http://cars.areas.su/drive") else { return }
        
        
        let params: Parameters = ["token" : UserDefaults.standard.string(forKey: "Token")]
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
            
                
                
            case .failure(let error):
                print(error)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func stop(_ sender: Any) {
      
        
        
        guard let urls = URL(string: "http://cars.areas.su/drivestop") else { return }
        
        
        let paramss: Parameters = ["token" : UserDefaults.standard.string(forKey: "Token")]
        
        
        Alamofire.request(urls, method: .post, parameters: paramss, encoding: JSONEncoding.default).validate().responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                
              
                
                
            case .failure(let error):
                print(error)
            }
        }
        
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
                    self.performSegue(withIdentifier: "Maps", sender: self)
                })
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func fireTimer() {
        
        seconds += 1
        if seconds == 60 {
            minutes += 1
            seconds = 0
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
