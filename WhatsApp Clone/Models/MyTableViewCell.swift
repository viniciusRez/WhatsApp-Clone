//
//  MyTableViewCell.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var imageViewContato: UIImageView!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblNome: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
