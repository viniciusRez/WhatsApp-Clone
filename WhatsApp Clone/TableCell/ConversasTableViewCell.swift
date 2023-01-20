//
//  ConversasTableViewCell.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 20/01/23.
//

import UIKit

class ConversasTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var lblLastMessage: UILabel!
    @IBOutlet var lblNome: UILabel!
    @IBOutlet var imageViewConversa: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
