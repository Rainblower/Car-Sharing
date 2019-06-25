//
//  HistoryViewController.swift
//  Deno
//
//  Created by WSR on 25/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    var cells: [cell] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        table.tableFooterView = UIView()
        
        cells.append(cell(name: "Kia Rio", price: "$15", time: "15 min"))
        cells.append(cell(name: "Kia Rio", price: "$15", time: "15 min"))

        cells.append(cell(name: "Kia Rio", price: "$15", time: "15 min"))

        table.delegate = self
        table.dataSource = self
        
        table.reloadData()
        // Do any additional setup after loading the view.
    }
    
    struct cell {
        let name: String
        let price: String
        let time: String
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
        return cells.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.name.text = cells[indexPath.row].name
        cell.time.text = cells[indexPath.row].time
        cell.price.text = cells[indexPath.row].price
        // Configure the cell...
        
        return cell
    }
    
}
