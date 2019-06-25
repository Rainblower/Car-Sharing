//
//  CustomTableViewCell.swift
//  Deno
//
//  Created by WSR on 25/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var nameT = ""
    var timeT = ""
    var priceT = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        name.text = nameT
        price.text = priceT
        time.text = timeT
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
