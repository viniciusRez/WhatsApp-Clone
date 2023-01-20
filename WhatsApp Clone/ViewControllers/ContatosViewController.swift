//
//  ContatosViewController.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import UIKit
import Kingfisher
class ContatosViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
    
    var listOfContatos:[Dictionary<String,Any>] = []
    var contatosViewModel:ContatosViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contatosViewModel = ContatosViewModel(controller: self)
        self.searchBarUser.delegate = self
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBarUser: UISearchBar!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.contatosViewModel.getContatos { result in
            self.listOfContatos = result
            self.tableView.reloadData()
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textSearch = searchBar.text{
            if textSearch != ""{
                self.contatosViewModel.searchContatos(text: textSearch) { result in
                    self.listOfContatos = result
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfContatos.isEmpty
        {
            return 1
        }else{
            return listOfContatos.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContatos", for: indexPath) as! MyTableViewCell
        
        if listOfContatos.isEmpty
        {   cell.lblNome!.text = "Nenhuma usuario encontrado."
            cell.lblEmail.text = ""
            cell.imageViewContato.isHidden = true
        }else {
            cell.imageViewContato.isHidden = false
            let contato = self.listOfContatos[indexPath.row]
            cell.lblNome!.text = contato["nome"] as? String
            cell.lblEmail!.text = contato["email"] as? String
            let url = URL(string: contato["urlImage"] as! String)
            cell.imageViewContato.kf.setImage(with: url){result in
                switch result {
                case .success:
                    print("sucesso")
                case .failure(let error):
                    print(error)
                    cell.imageViewContato.image = UIImage(named: "padrao")
                }
                
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contatoSelecionado = self.listOfContatos[indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.contatosViewModel.router(identifier: "showMensage", sender: contatoSelecionado)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     */
    @IBAction func btnNovoContato(_ sender: Any) {
        self.contatosViewModel.router(identifier: "newContact", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMensage" {
            let viewdestination = segue.destination as!  ChatViewController
            viewdestination.contacInfo = sender as? Dictionary<String, Any>
        }

    }
}
