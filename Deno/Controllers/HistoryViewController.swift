//
//  HistoryViewController.swift
//  Deno
//
//  Created by WSR on 25/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    var drives: [History] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "http://cars.areas.su/history") else { return }

        
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        
        
        let params: Parameters = ["token" : UserDefaults.standard.string(forKey: "Token")]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(value)
             
                
                do {
                    
                    self.drives = try JSONDecoder().decode([History].self, from: response.data!)
                    self.table.reloadData()
                } catch {
                    print(error)
                }
                
                
                
            case .failure(let error):
                print(error)
            }
        }
        
      



        // Do any additional setup after loading the view.
    }
    
  
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drives.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.name.text = drives[indexPath.row].car_model
        cell.time.text = String(Int(drives[indexPath.row].timeDrive_seconds)! / 60) + " min"
        cell.price.text = "$" + drives[indexPath.row].cash
        // Configure the cell...
        
        return cell
    }
    
}
