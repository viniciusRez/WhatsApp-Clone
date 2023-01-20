//
//  ConversasViewModel.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 20/01/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class ConversasViewModel{
    let auth:Auth!
    let firestore:Firestore
    let idUser:String
    let controller: UIViewController 
    init(controller: UIViewController) {
        self.controller = controller
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.idUser = self.auth.currentUser!.uid
    }


    func getMessage(completion:@escaping([Dictionary<String,Any>])-> Void){
        var listOfMessage:[Dictionary<String,Any>] = []
        self.firestore.collection("conversas")
            .document(self.idUser)
            .collection("lastMessage")
            .getDocuments{ (querry,error) in
                if error == nil{
                    if let snapshot = querry {
                        for document in snapshot.documents {
                            print(document.data().count)
                            let dados = document.data()
                            listOfMessage.append(dados)
                            completion(listOfMessage)

                        }
                    }
                }
            }
    }
    func router(identifier:String,sender:Any?){
        self.controller.performSegue(withIdentifier: identifier, sender: sender)
    }
}
