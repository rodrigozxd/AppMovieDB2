//
//  LoginViewController.swift
//  AppMovieDB2
//
//  Created by Mac 10 on 12/1/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var controlSegmento: UISegmentedControl!
    @IBOutlet weak var txtUsuario: UITextFieldX!
    @IBOutlet weak var txtPassword: UITextFieldX!
    @IBOutlet weak var boton: UIButton!
    
    var iconClick = false
    let imageicon = UIImageView()
    let person = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageicon.image = UIImage(named: "close")
        let contenView = UIView()
        contenView.addSubview(imageicon)
        
        contenView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        imageicon.frame = CGRect(x: -15, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        
        txtPassword.rightView = contenView
        txtPassword.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageicon.isUserInteractionEnabled = true
        imageicon.addGestureRecognizer(tapGestureRecognizer)
        
    }
    @IBAction func btnSegmento(_ sender: UISegmentedControl) {
        let control = controlSegmento.selectedSegmentIndex
        switch control {
        case 0:
            boton.setTitle("Iniciar Sesion", for: .normal)
        case 1:
            boton.setTitle("Registrar Usuario", for: .normal)
        default:
            print("error control Segmento")
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if iconClick{
            iconClick = false
            tappedImage.image = UIImage(named: "open")
            txtPassword.isSecureTextEntry = false
        }else {
            iconClick = true
            tappedImage.image = UIImage(named: "close")
            txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        let opcion = controlSegmento.selectedSegmentIndex
        switch  opcion {
        case 0:
            Auth.auth().signIn(withEmail: txtUsuario.text!, password: txtPassword.text!) {
                (user, error) in
                print("Intentando Iniciar Sesion")
                if error != nil{
                    print("Se presento el siguiente error: \(String(describing: error))")
                    let alerta = UIAlertController(title: "Error", message: "Su usuario no esta registrado, por favor cree primero su usuario", preferredStyle: .alert)
                    let btnCerrar = UIAlertAction(title: "Cerrar", style: .default, handler: { (UIAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alerta.addAction(btnCerrar)
                    self.present(alerta, animated: true, completion: nil)
                }else{
                    print("Inicio de Sesion Exitoso")
                    self.person.uid = user!.user.uid
                    self.person.name = user!.user.email
                    self.performSegue(withIdentifier: "iniciosegue", sender: self.person)
                }
            }
        case 1:
            Auth.auth().createUser(withEmail: self.txtUsuario.text!, password: self.txtPassword.text!, completion: { (user, error) in
                print("Intentando crear un usuario")
                if error != nil {
                    print("Se presento el siguiente error al crear el usuario: \(String(describing: error))")
                    let alerta = UIAlertController(title: "Error", message: "Se produjo un error al crear el usuario.", preferredStyle: .alert)
                    let btnCerrar = UIAlertAction(title: "Cerrar", style: .default, handler: { (UIAlertAction) in
                    })
                    alerta.addAction(btnCerrar)
                    self.present(alerta, animated: true, completion: nil)
                }else{
                    print("El usuario fue creado satisfactoriamente")
                Database.database().reference().child("Usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                    let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.txtUsuario.text!) se creo perfectamente.", preferredStyle: .alert)
                    let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                        self.person.uid = user!.user.uid
                        self.person.name = user!.user.email
                        self.performSegue(withIdentifier: "iniciosegue", sender: self.person)
                    })
                    alerta.addAction(btnOK)
                    self.present(alerta, animated: true, completion: nil)
                }
            })
        default:
            print("Error!")
        }
        
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBar = segue.destination as! UITabBarController
        let siguienteVC = (tabBar.viewControllers![0] as! UINavigationController).topViewController as! FirstViewController
        siguienteVC.usuario = person.name!
        siguienteVC.uid = person.uid!
        let siguienteVC2 = (tabBar.viewControllers![1] as! UINavigationController).topViewController as! SecondViewController
        siguienteVC2.uid = person.uid!
        let siguienteVC3 = (tabBar.viewControllers![2] as! UINavigationController).topViewController as! ThreeViewController
        siguienteVC3.uid = person.uid!
    }

}
