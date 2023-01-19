//
//  LoginViewModel.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewModel{
    let controller:UIViewController
    init(controller: UIViewController) {
        self.controller = controller
    }
    func checkIsLogged(){
        let auth = Auth.auth()
        auth.addStateDidChangeListener{ (auth,user) in
            if user != nil{
                self.router(identifier: "inside")
            }else{
                
            }
        }
    }
    func singOut(){
        let authentication = Auth.auth()
        do{
            try authentication.signOut()
        }catch{
            print(error)
        }
        
    }
    func login(email:String,senha:String,completion:@escaping(Bool,AlertModel) ->Void){
        let login = Auth.auth()
        var mensagem = ""
        var tittle = ""
        var notUser:Bool = false
        login.signIn(withEmail: email, password: senha, completion: { (result, error) in
            if error == nil {
                if result == nil{
                    mensagem = "\(email) erro ao autenticar, tente novamente!!"
                    tittle = "Erro ao autenticar"
                }else{
                    mensagem = "\(email) seja bem vindo!!"
                    tittle = "Bem vindo"
                }
           
            } else {
                let erroR = error! as NSError
                print(erroR)
                notUser = true
                if let codigoError = erroR.userInfo["FIRAuthErrorUserInfoNameKey"]{
                    let mensagemError = codigoError as! String
                    print(mensagemError)
                    switch mensagemError{
                    case "ERROR_INVALID_EMAIL":
                        mensagem = " seu email e invalido!!"
                        tittle = "Email invalido"
                        break
                    case "ERROR_WRONG_PASSWORD":
                        mensagem = "Sua senha esta incorreta!!"
                        tittle = "Confira sua senha"
                        break
                    case "ERROR_USER_NOT_FOUND":
                        mensagem = "usuario não cadastrado!!"
                        tittle = "confira o email"
                        break
                    default:
                        mensagem = "\(email ) erro inesperado!!"
                        tittle = "Chame o suporte"
                    }
                }
            }

            let alert:AlertModel = AlertModel(mensagem:  mensagem, titulo: tittle)

            completion(notUser,alert)
        })
    
        
    }
    func router(identifier:String){
        self.controller.performSegue(withIdentifier: identifier, sender: nil)
    }
}
