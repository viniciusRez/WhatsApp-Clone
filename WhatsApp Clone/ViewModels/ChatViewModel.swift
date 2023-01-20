//
//  ChatViewModel.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class ChatViewModel{
    let auth:Auth!
    let firestore:Firestore
    let idUser:String
    let idContato:String
    init(idContato: String) {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.idUser = self.auth.currentUser!.uid
        self.idContato = idContato
    }
    func getDadosUser(completion:@escaping(Dictionary<String,Any>)-> Void){
        self.firestore.collection("usuarios")
            .document(idUser)
            .getDocument { (result,error) in
                if error == nil{
                    if let userInfo = result?.data(){
                        completion(userInfo)
                    }
                }
            }
    }
    func getMessage(completion:@escaping([Dictionary<String,Any>])-> Void){
        var listOfMessage:[Dictionary<String,Any>] = []
        self.firestore.collection("mensagem")
            .document(self.idUser)
            .collection(self.idContato)
            .order(by: "data", descending: false)
            .addSnapshotListener { (querry,error) in
                if error == nil{
                    if let snapshot = querry {
                        listOfMessage.removeAll()
                        for document in snapshot.documents {
                            let dados = document.data()
                            listOfMessage.append(dados)
                        }
                        completion(listOfMessage)

                    }
                }
            }

        
    }
    func sendMessage(conteudo:String?,urlImage:String?){
        var mensagemEnviada:Dictionary<String,Any>!
        if let urlImage = urlImage {
            mensagemEnviada = [
                "idUsuario": self.idUser,
                "urlImage": urlImage,
                "data":FieldValue.serverTimestamp()
           ]
        }else{
            if let conteudo = conteudo{
                mensagemEnviada = [
                    "idUsuario": self.idUser,
                    "texto": conteudo,
                    "data":FieldValue.serverTimestamp()
                ]
            }
        }
        self.saveMensage(idRemetente: self.idUser, idDestinatario: self.idContato, mensagemEnviada: mensagemEnviada!)
        self.saveMensage(idRemetente: self.idContato, idDestinatario: self.idUser, mensagemEnviada: mensagemEnviada!)

    }
    func lastMessage(contato:Dictionary<String,Any>,conteudo:String?,urlImage:String?){
        
        var ultimaMensagem:String!
        self.getMessage { result in
            if let first = result.last{
                if urlImage == nil {
                    ultimaMensagem = (first["texto"] as! String)
                } else {
                    ultimaMensagem = "imagem... "
                }
                if ultimaMensagem != nil {
                    var ultimaConversa:Dictionary<String,Any>! = ["UltimaMensagem": ultimaMensagem!]
                    ultimaConversa["id"] = self.idContato
                    ultimaConversa["nome"] = contato["nome"] as! String
                    ultimaConversa["urlImage"] = contato["urlImage"] as! String
                    self.saveLastMessage(idRemetente: self.idUser, idDestinatario: self.idContato, ultimaConversa: ultimaConversa)

                    self.getDadosUser { result in
                        ultimaConversa["id"] = self.idUser
                        ultimaConversa["nome"] = result["nome"] as! String
                        ultimaConversa["urlImage"] = result["urlImage"] as! String
                        self.saveLastMessage(idRemetente: self.idContato, idDestinatario: self.idUser, ultimaConversa: ultimaConversa)
                    }
                }
            }
        }
    }
    func saveMensage(idRemetente:String,idDestinatario:String,mensagemEnviada:Dictionary<String,Any>){
        self.firestore.collection("mensagem")
            .document(idRemetente)
            .collection(idDestinatario)
            .addDocument(data: mensagemEnviada as [String : Any])

    }
    
    func saveLastMessage(idRemetente:String,idDestinatario:String,ultimaConversa:Dictionary<String,Any>){
        
        self.firestore.collection("conversas")
            .document(idRemetente)
            .collection("lastMessage")
            .document(idDestinatario)
            .setData(ultimaConversa as [String : Any])
     
        
    }
    
    func sendImage(selectedImage:UIImage){
        let storage = Storage.storage().reference()
        let imagens = storage.child("Imagens")
        let userFotos = imagens.child("sendImagens")
        let  idImagem = NSUUID().uuidString
        if let dataImage = selectedImage.jpegData(compressionQuality: 0.5){
            let uploadImage = userFotos.child("\(idImagem).jpg")
            uploadImage.putData(dataImage, metadata: nil)  { (metaData,error) in
                if error == nil{
                    uploadImage.downloadURL(completion: { (url, error) in
                        if error == nil {
                            if let downloadUrl = url {
                                let downloadString = downloadUrl.absoluteString
                                self.sendMessage(conteudo: nil, urlImage: downloadString)
                            } else {
                                print("\(error!) Nada capturado")
                            }
                        }
                    })
                    
                }
            }
        }
    }
}
