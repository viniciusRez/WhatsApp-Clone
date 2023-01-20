//
//  ChatViewController.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import UIKit
import Kingfisher
class ChatViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var listOfMessage:[Dictionary<String,Any>] = []
    var imagePicker:UIImagePickerController!
    var idContato:String!
    var contacInfo: Dictionary<String, Any>!
    var chatViewModel:ChatViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.tableViewMessage.backgroundView = UIImageView(image: UIImage(named: "bg"))
        if let id = (self.contacInfo["id"] as? String){
            self.idContato = id
            print(id)
        }else{
            self.idContato = ""
        }
        
        self.chatViewModel = ChatViewModel(idContato: self.idContato)
        self.reloadData()
    }
    func reloadData(){
        self.chatViewModel.getMessage() { result in
            self.listOfMessage = result
            self.tableViewMessage.reloadData()
            
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageRecover = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
      
            self.chatViewModel.sendImage(selectedImage: imageRecover)
            self.chatViewModel.lastMessage(contato: contacInfo,conteudo: nil,urlImage: "not nil")
            self.imagePicker.dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        if let nome = self.contacInfo["nome"]{
            self.title  = nome as? String

        }
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBOutlet var message: UITextField!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfMessage.isEmpty
        {
            return 0
        }else{
            return listOfMessage.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellEnviada = tableView.dequeueReusableCell(withIdentifier: "cellMessageRight", for: indexPath)  as! MensagemTableViewCell
        let cellRecebida = tableView.dequeueReusableCell(withIdentifier: "cellMessageLeft", for: indexPath)  as! MensagemTableViewCell
        let cellImagemEnviada = tableView.dequeueReusableCell(withIdentifier: "cellForImageRight", for: indexPath)  as! MensagemTableViewCell
        let cellImagemRecebida = tableView.dequeueReusableCell(withIdentifier: "cellForImageLeft", for: indexPath)  as! MensagemTableViewCell
        
        let indice = indexPath.row
        let mensagem = self.listOfMessage[indice]
        if !self.listOfMessage.isEmpty{
            if mensagem["urlImage"] == nil{
                if (mensagem["idUsuario"] as! String) != self.chatViewModel.idUser{
                    cellRecebida.mensagemRecebida.text = mensagem["texto"] as? String
                    return cellRecebida
                }else{
                    cellEnviada.mensagemEnviada.text = mensagem["texto"] as? String
                    return cellEnviada
                }
            }else{
                if (mensagem["idUsuario"] as! String) != self.chatViewModel.idUser{
                    if let url = URL(string: mensagem["urlImage"] as! String) {
                        cellImagemRecebida.fotoRecebida.kf.setImage(with: url)
                    } else {
                        cellImagemRecebida.fotoRecebida.image = UIImage(named: "padrao")

                    }
                    return cellImagemRecebida
                }else{
                    if let url = URL(string: mensagem["urlImage"] as! String) {
                        cellImagemEnviada.fotoEnviada.kf.setImage(with: url)
                    } else {
                        cellImagemEnviada.fotoEnviada.image = UIImage(named: "padrao")

                    }
                    return cellImagemEnviada
                }
            }
        }else{
            return cellEnviada
        }
        
    }
    @IBOutlet var tableViewMessage: UITableView!
    @IBAction func sendImage(_ sender: Any) {
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)

    }
    @IBAction func sendMessage(_ sender: Any) {
        if let message = self.message.text{
            if !message.isEmpty{
                self.chatViewModel.sendMessage(conteudo: self.message.text!,urlImage: nil)
                self.message.text = ""
                self.reloadData()
                self.chatViewModel.lastMessage(contato: contacInfo,conteudo: self.message.text!,urlImage: nil)

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
