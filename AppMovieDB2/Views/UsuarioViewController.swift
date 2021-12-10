//
//  UsuarioViewController.swift
//  AppMovieDB2
//
//  Created by Mac 10 on 12/3/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class UsuarioViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var email: UILabel!
    
    var user:Users?
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        email.text = "\((user?.name)!)"
        
        Database.database().reference().child("Usuarios").child((self.user?.uid)!).child("Imagenes").observe(DataEventType.childAdded, with: { (snapshot) in
            let imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            if imagenURL == "" {
                //imagen definida
            }else{
                self.imagen.sd_setImage(with: URL(string: imagenURL), completed: nil)
                self.imagen.layer.cornerRadius = self.imagen.bounds.size.width / 2.0
            }
        })
    }
    
    func mostrarAlerta(titulo:String, mensaje:String,accion:String){
        let alerta = UIAlertController(title:titulo, message: mensaje, preferredStyle: .alert)
        let btnCancelOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCancelOK)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func ElegirImagen(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagen.image = image
        
         let imagenesFolder = Storage.storage().reference().child("imagenes")
                let imagenData = imagen.image?.jpegData(compressionQuality: 0.50)
                let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
                    cargarImagen.putData(imagenData!, metadata: nil) { (metadata, error) in
                    if error != nil{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelve a intentarlo.", accion: "Aceptar")
                        print("Ocurrio un error al subir la imagen: \(String(describing: error))")
                    }else{
                        cargarImagen.downloadURL(completion: { (url, error) in
                            guard url != nil else{
                                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la informacion de la imagen", accion: "Cancelar")
                                print("Ocurrio un error al obtener la informacion de la imagen \(String(describing: error))")
                                return
                            }
                            let snap = ["from" : (self.user?.name)!, "imagenURL" : url?.absoluteString]
                            Database.database().reference().child("Usuarios").child((self.user?.uid)!).child("Imagenes").childByAutoId().setValue(snap)
                        })
                    }
                }
    
        imagen.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
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
