//
//  AjustesViewModel.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
class AjustesViewModel{
    let controller:UIViewController
    init(controller: UIViewController) {
        self.controller = controller
    }
    func getImage(completion:@escaping(Dictionary<String,Any>) -> Void){
        let auth = Auth.auth()
        let firestore = Firestore.firestore()
        let usuario = auth.currentUser?.uid
        if let idUser = usuario {
            firestore.collection("usuarios")
                .document(idUser)
            .getDocument { (result,error) in
                if let snapshot = result?.data() {
                    completion(snapshot)
                }
            }
        }
    }
    func saveImage(selectedImage:UIImageView) {
        let storage = Storage.storage().reference()
        let imagens = storage.child("Imagens")
        let userFotos = imagens.child("userFotos")
        let  idImagem = NSUUID().uuidString
        if let selectedImage = selectedImage.image {
            if let dataImage = selectedImage.jpegData(compressionQuality: 0.5){
                let uploadImage = userFotos.child("\(idImagem).jpg")
                uploadImage.putData(dataImage, metadata: nil)  { (metaData,error) in
                    if error == nil{
                        uploadImage.downloadURL(completion: { (url, error) in
                            if error == nil {
                                if let downloadUrl = url {
                                    let downloadString = downloadUrl.absoluteString
                                    print("\(downloadString)")
                                    let firestore = Firestore.firestore()
                                    let auth = Auth.auth()
                                    let usuario = auth.currentUser?.uid
                                    if let idUser = usuario {
                                        let imageData = ["urlImage":downloadString,"idImage":"\(idImagem).jpg"]
                                        firestore.collection("usuarios")
                                            .document(idUser).updateData(imageData)
                                    }
                                }
                            } else {
                                print("\(error!) Nada capturado")
                            }
                        })
                        
                    }else{
                    }
                }
            }
        }
    }
    
}
