//
//  NovoContatoViewModel.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

class NovoContatoViewModel{
    let controller: UIViewController
    init(controller: UIViewController) {
        self.controller = controller
    }
    func getContact(completion:@escaping([Dictionary<String,Any>]) -> Void) {
        let firestore = Firestore.firestore()
        
        var listOfContacts:[Dictionary<String,Any>] = []
        firestore.collection("usuarios")
            .getDocuments { (result,error) in
                if let snapshot = result {
                    for document in snapshot.documents{
                        let dados = document.data()
                        listOfContacts.append(dados)
                    }
                    completion(listOfContacts)
                }
            }
    }
    
    func addContact(email:String,completion:@escaping(AlertModel) -> Void) {
        var mensagem:String!
        var titulo:String!
        self.getContact { result in
            for item in result {
                if let emailItem = item["email"] as? String {
                    if emailItem == email {
                        self.insertContact(dados:item)
                        mensagem = "Novo Usuario Adicionado"
                        titulo = "Sucesso"
                        completion(AlertModel(mensagem: mensagem, titulo: titulo))
                    } else {
                        mensagem = "Usuario não encontrado"
                        titulo = "Fracasso"
                    }
                }
            }
            completion(AlertModel(mensagem: mensagem, titulo: titulo))
        }
    }
    func insertContact(dados:Dictionary<String,Any>) {
        let auth = Auth.auth()
        let usuario = auth.currentUser?.uid
        let firestore = Firestore.firestore()
        if let idUser = usuario{
            firestore.collection("usuarios")
                .document(idUser)
                .collection("contatos")
                .document(dados["id"] as! String)
                .setData(dados)
        }
    }

}
