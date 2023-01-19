//
//  LoginViewController.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import UIKit

class LoginViewController: UIViewController {
    var loginViewModel: LoginViewModel!
    override func viewDidLoad() {
        self.loginViewModel = LoginViewModel(controller: self)
        self.loginViewModel.checkIsLogged()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        self.loginViewModel.singOut()
        // Use data from the view controller which initiated the unwind segue
    }
    @IBOutlet var email: UITextField!
    @IBOutlet var senha: UITextField!
    @IBAction func logar(_ sender: Any) {
        if let email = self.email.text{
            if let senha = self.senha.text{
                
                self.loginViewModel.login(email:email,senha:senha, completion: {(result,alert) in
                   
                    self.present(alert.makeAlert(), animated: true)
                    
                })

            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        self.loginViewModel.router(identifier: "register")
    }
    
}
