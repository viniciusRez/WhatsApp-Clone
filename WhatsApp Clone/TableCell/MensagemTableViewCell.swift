//
//  MensagemTableViewCell.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import UIKit

class MensagemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet var mensagemEnviada: UILabel!
    
    @IBOutlet var fotoEnviada: UIImageView!
    @IBOutlet var fotoRecebida: UIImageView!
    
    @IBOutlet var mensagemRecebida: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
