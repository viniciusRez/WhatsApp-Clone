//
//  ContatosViewModel.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class ContatosViewModel{
    let controller: UIViewController
    init(controller: UIViewController) {
        self.controller = controller
    }
    func getContatos(completion:@escaping([Dictionary<String,Any>]) -> Void){
        let firestore = Firestore.firestore()
        let auth = Auth.auth()
        let user = auth.currentUser?.uid
        if let userID =  user{
            var listOfContacts:[Dictionary<String,Any>] = []
            firestore.collection("usuarios")
                .document(userID)
                .collection("contatos")
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
        
    }
    
    func searchContatos(text:String,completion:@escaping([Dictionary<String,Any>]) -> Void){
        var itemFilter:[Dictionary<String,Any>] = []
        self.getContatos { result in
            for item in result {
                if let nome = item["nome"] as? String {
                    if nome.contains(text){
                        itemFilter.append(item)
                    }
                }
            }
            completion(itemFilter)
        }
    }
    func router(identifier:String,sender:Any?){
        self.controller.performSegue(withIdentifier: identifier, sender: sender)
    }
}
