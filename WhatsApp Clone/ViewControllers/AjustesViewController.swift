//
//  AjustesViewController.swift
//  WhatsApp Clone
//
//  Created by Vinicius Rezende on 19/01/23.
//

import UIKit
import  Kingfisher

class AjustesViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var imagePicker:UIImagePickerController!
    var ajustesViewModel:AjustesViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.ajustesViewModel = AjustesViewModel(controller:self)
        self.ajustesViewModel.getImage { info in
            if let url = URL(string: info["urlImage"] as! String) {
                self.alterImage(url:url)
            }else{
                self.imageView.image = UIImage(named: "padrao")

            }
            self.lblNome.text = (info["nome"] as! String)
            self.lblEmail.text = (info["email"] as! String)

        }
    }
    
    func alterImage(url:URL){
        self.imageView.kf.setImage(with: url){result in
            switch result {
                case .success:
                print("sucesso")
                case .failure(let error):
                print(error)
                self.imageView.image = UIImage(named: "padrao")
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageRecover = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
      
            self.imageView.image = imageRecover
            self.ajustesViewModel.saveImage(selectedImage: self.imageView)
            self.imagePicker.dismiss(animated: true)
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblNome: UILabel!
    @IBAction func selectImage(_ sender: Any) {
        
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
