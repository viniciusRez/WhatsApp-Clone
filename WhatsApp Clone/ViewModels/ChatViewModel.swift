//
//  ChatViewModel.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeViewModel{
    let controller: UIViewController
    init(controller: UIViewController) {
        self.controller = controller
    }
   
    func router(identifier:String){
        self.controller.performSegue(withIdentifier: identifier, sender: nil)
    }

}
