//
//  SecondViewController.swift
//  AppMovieDB2
//
//  Created by Mac 10 on 11/22/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var txtBuscar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancel: UIButton!
    
    var movie = [Movie]()
    var uid:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: "celda")
        tableView.delegate = self
        tableView.dataSource = self
        txtBuscar.delegate = self
        cancel.layer.cornerRadius = 4
        
    }
    @IBAction func Limpiar(_ sender: Any) {
        txtBuscar.text = ""
        self.tableView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies(){
        txtBuscar.resignFirstResponder()
        
        let text = txtBuscar.text!.replacingOccurrences(of: " ", with: "%20")
        
        movie.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/search/movie?api_key=1865f43a0549ca50d341dd9ab8b29f49&language=en-US&query=\(text)&page=1")!,
                                           completionHandler: { data, response, error in
        
                                            guard let data = data, error == nil else {
                                                return
                                            }
        
                                            // Convert
                                            var result: MoviesData?
                                            do {
                                                result = try JSONDecoder().decode(MoviesData.self, from: data)
                                            }
                                            catch {
                                                let alerta = UIAlertController(title: "Error", message: "Escriba solo letras y para los espacios reemplace con '_'.", preferredStyle: .alert)
                                                let btnCerrar = UIAlertAction(title: "Cerrar", style: .default, handler: { (UIAlertAction) in
                                                    self.dismiss(animated: true, completion: nil)
                                                })
                                                alerta.addAction(btnCerrar)
                                                self.present(alerta, animated: true, completion: nil)
                                            }
        
                                            guard let finalResult = result else {
                                                return
                                            }
                                            
                                            print("\(finalResult.movies.first?.title ?? "")")
        
                                            // Update our movies array
                                            let newMovies = finalResult.movies
                                            self.movie.append(contentsOf: newMovies)
        
                                            // Refresh our table
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                            }
        
                }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! MovieTableViewCell
        cell.configure(with: movie[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pelicula = movie[indexPath.row]
        performSegue(withIdentifier: "detalle", sender: pelicula)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! DetalleViewController
        siguienteVC.pelicula = sender as? Movie
        siguienteVC.user = uid
    }
    
}

