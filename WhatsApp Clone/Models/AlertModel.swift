//
//  AlertModel.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//


import Foundation
import UIKit
struct AlertModel{
    let mensagem:String
    let titulo:String
    
    init(mensagem: String, titulo: String) {
        self.mensagem = mensagem
        self.titulo = titulo
    }
    
    // mensagem
    func makeAlert() -> UIAlertController {
        let alertaController = UIAlertController(title: self.titulo, message: self.mensagem, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertaController.addAction(action)
        return alertaController
    }
    func makeAlertAndReturn(controller:UIViewController)-> UIAlertController {
        let alertaController = UIAlertController(title: self.titulo, message: self.mensagem, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            self.returnToControll(controller: controller)
        }
        alertaController.addAction(action)
        return alertaController
    }
    func returnToControll(controller:UIViewController){
        controller.navigationController?.popToRootViewController(animated: true)
    }
 }
