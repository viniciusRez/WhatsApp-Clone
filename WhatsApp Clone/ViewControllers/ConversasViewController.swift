//
//  ConversasViewController.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 20/01/23.
//

import UIKit
import Kingfisher
class ConversasViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var listOfConversas:[Dictionary<String,Any>] = []
    var conversasViewModel:ConversasViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conversasViewModel = ConversasViewModel(controller: self)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()

    }
    func reloadData(){
        self.conversasViewModel.getMessage{ result in
            self.listOfConversas = result
            print(result)
            self.tableViewMessage.reloadData()
            
            
        }
    }
    @IBOutlet var tableViewMessage: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfConversas.isEmpty
        {
            return 0
        }else{
            return listOfConversas.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellConversas", for: indexPath)  as! ConversasTableViewCell
        let indice = indexPath.row
        let contato = self.listOfConversas[indice]
        cell.lblNome.text = (contato["nome"] as? String)
        cell.lblLastMessage.text = (contato["UltimaMensagem"] as? String)
        if let urlImage = contato["urlImage"]{
            if let url = URL(string: (urlImage as! String)) {
                cell.imageViewConversa.kf.setImage(with: url)
            } else {
                cell.imageViewConversa.image = UIImage(named: "padrao")

            }
        }else{
            cell.imageViewConversa.image = UIImage(named: "padrao")

        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contatoSelecionado = self.listOfConversas[indexPath.row]
        self.tableViewMessage.deselectRow(at: indexPath, animated: true)
        self.conversasViewModel.router(identifier: "showChat", sender: contatoSelecionado)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            let viewdestination = segue.destination as!  ChatViewController
            viewdestination.contacInfo = sender as? Dictionary<String, Any>
        }

    }
}
