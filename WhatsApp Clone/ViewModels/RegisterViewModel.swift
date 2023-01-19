//
//  RegisterViewModel.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class RegisterViewModel{
    
    func register(email:String,senha:String,nome:String,completion:@escaping(Bool,AlertModel) ->Void) {
        let register = Auth.auth()
        var mensagem = ""
        var tittle = ""
        var errorRegister = false
        register.createUser(withEmail: email, password: senha, completion: { (usuario, error) in
            if error == nil {
                if usuario != nil{
                    let firestore = Firestore.firestore()
                    if let idUser = usuario?.user.uid{
                        let userData = ["nome":nome,"email":email,"id":idUser,"urlImage":"","idImage":""]
                        firestore.collection("usuarios")
                            .document(idUser)
                            .setData(userData)
                        mensagem = "\(nome) olaa!!"
                        tittle = "Bem vindo"
                    }
                }
                
            } else {
                let erroR = error! as NSError
                print(erroR)
                errorRegister = true
                if let codigoError = erroR.userInfo["FIRAuthErrorUserInfoNameKey"]{
                    let mensagemError = codigoError as! String
                    print(mensagemError)
                    switch mensagemError{
                    case "ERROR_INVALID_EMAIL":
                        mensagem = "\(nome) seu email e invalido!!"
                        tittle = "Email invalido"
                        break
                    case "ERROR_WEAK_PASSWORD":
                        mensagem = "\(nome) sua senha esta fraca!!"
                        tittle = "Deixe sua senha forte"
                        break
                    case "ERROR_EMAIL_ALREADY_IN_USE":
                        mensagem = "\(nome) este email ja existe!!"
                        tittle = "Email ja cadastrado"
                        break
                        
                    default:
                        mensagem = "\(nome) erro inesperado!!"
                        tittle = "Chame o suporte"
                    }
                }
            }
            let alert:AlertModel = AlertModel(mensagem:  mensagem, titulo: tittle)
            
            completion(errorRegister,alert)
        })
        
    }
    
}
