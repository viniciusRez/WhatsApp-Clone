//
//  NovoContatoViewController.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import UIKit

class NovoContatoViewController: UIViewController {
    var novoContatoViewModel:NovoContatoViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.novoContatoViewModel = NovoContatoViewModel(controller: self)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var emailText: UITextField!
    
    @IBOutlet var lblErro: UILabel!
    @IBAction func btnAdd(_ sender: Any) {
        self.novoContatoViewModel.addContact(email: emailText.text!) { AlertModel in
            self.present(AlertModel.makeAlert(), animated:true)
            self.lblErro.text = AlertModel.mensagem
            self.lblErro.isHidden = false
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
