//
//  FirstViewController.swift
//  AppMovieDB2
//
//  Created by Mac 10 on 11/22/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var nowPlayingMovie = [Movie]()
    var popularMovie = [Movie]()
    var topRatedMovie = [Movie]()
    var upComingMovie = [Movie]()
    var usuario:String = ""
    var uid:String = ""
    let direccion = Urls()
    
    //var circulo: UIActivityIndicatorView? = nil
    

    @IBOutlet weak var collectionViewA: UICollectionView!
    @IBOutlet weak var collectionViewB: UICollectionView!
    @IBOutlet weak var collectionViewC: UICollectionView!
    @IBOutlet weak var collectionViewD: UICollectionView!
    
    let apiService = ApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionViewA.delegate = self
        collectionViewA.dataSource = self
        collectionViewB.delegate = self
        collectionViewB.dataSource = self
        collectionViewC.delegate = self
        collectionViewC.dataSource = self
        collectionViewD.delegate = self
        collectionViewD.dataSource = self
        /*
        circulo = loader()
        
        collectionViewA.addSubview(circulo!)
        collectionViewB.addSubview(circulo!)
        collectionViewC.addSubview(circulo!)
        collectionViewD.addSubview(circulo!)
        */
        //Llamando a los metodos
        nowPlaying(circulo: loader())
        popular(circulo: loader())
        topRated(circulo: loader())
        upcoming(circulo: loader())
    }
    
    func loader() -> UIActivityIndicatorView {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 20, y: 15, width: 80, height: 80))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        return loadingIndicator
    }
    
    // movies now_playing
    func nowPlaying(circulo: UIActivityIndicatorView){
        self.collectionViewA.addSubview(circulo)
        apiService.getNowPlayingMovies{ (result) in
            switch result{
            case .success(let listOf):
                self.nowPlayingMovie = listOf.movies
                circulo.stopAnimating()
                self.collectionViewA.reloadData()
                print("now_playing")
            case .failure(let error):
                print("Error al processing json data: \(error)")
            }
        }
    }
    //movies popular
    func popular(circulo: UIActivityIndicatorView){
        self.collectionViewB.addSubview(circulo)
        apiService.getPopularMovies { (result) in
            switch result{
            case .success(let listOf):
                self.popularMovie = listOf.movies
                circulo.stopAnimating()
                self.collectionViewB.reloadData()
                print("popular")
            case .failure(let error):
                print("Error al processing json data: \(error)")
            }
        }
    }
    //movies top rated
    func topRated(circulo: UIActivityIndicatorView){
        self.collectionViewC.addSubview(circulo)
        apiService.getTopRatedMovies { (result) in
            switch result{
            case .success(let listOf):
                self.topRatedMovie = listOf.movies
                circulo.stopAnimating()
                self.collectionViewC.reloadData()
                print("top_rated")
            case .failure(let error):
                print("Error al processing json data: \(error)")
            }
        }
    }
    //movies upcoming
    func upcoming(circulo: UIActivityIndicatorView){
        self.collectionViewD.addSubview(circulo)
        apiService.getUpcomingMovies{ (result) in
            switch result{
            case .success(let listOf):
                self.upComingMovie = listOf.movies
                circulo.stopAnimating()
                self.collectionViewD.reloadData()
                print("upcoming")
            case .failure(let error):
                print("Error al processing json data: \(error)")
            }
        }
    }
    @IBAction func btnSalir(_ sender: Any) {
        let alerta = UIAlertController(title: "Cerrar Sesion", message: "¿Esta seguro que desea salir?", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        let btnCerrar = UIAlertAction(title: "Cerrar", style: .default, handler: { (UIAlertAction) in
        })
        alerta.addAction(btnOK)
        alerta.addAction(btnCerrar)
        self.present(alerta, animated: true, completion: nil)
    }
    @IBAction func btnUsuario(_ sender: Any) {
        let movie = Users()
        movie.name = "\(usuario)"
        movie.uid = "\(uid)"
        direccion.user = movie
        performSegue(withIdentifier: "segueUsuario", sender: direccion)
    }
    
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewA {
            return nowPlayingMovie.count
        }
        else if collectionView == self.collectionViewB{
            return popularMovie.count
        }
        else if collectionView == self.collectionViewC{
            return topRatedMovie.count
        }
        return upComingMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewA {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
            let pelicula = nowPlayingMovie[indexPath.row]
            let url = pelicula.posterURL
            if let data = try? Data(contentsOf: URL(string: (url).absoluteString)!) {
                cellA.imagenA.image = UIImage(data: data)
            }
            cellA.labelA.text = pelicula.title
            return cellA
        }
        else if collectionView == collectionViewB{
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
            let pelicula = popularMovie[indexPath.row]
            let url = pelicula.backdropURL
            if let data = try? Data(contentsOf: URL(string: (url).absoluteString)!) {
                cellB.imagenB.image = UIImage(data: data)
            }
            cellB.labelB.text = pelicula.title
            return cellB
        }
        else if collectionView == collectionViewC{
            let cellC = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
            let pelicula = topRatedMovie[indexPath.row]
            let url = pelicula.backdropURL
            if let data = try? Data(contentsOf: URL(string: (url).absoluteString)!) {
                cellC.imagenC.image = UIImage(data: data)
            }
            cellC.labelC.text = pelicula.title
            return cellC
        }
        else {
            let cellD = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
            let pelicula = upComingMovie[indexPath.row]
            let url = pelicula.backdropURL
            if let data = try? Data(contentsOf: URL(string: (url).absoluteString)!) {
                cellD.imagenD.image = UIImage(data: data)
            }
            cellD.labelD.text = pelicula.title
            return cellD
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewA {
            let pelicula = nowPlayingMovie[indexPath.row]
            direccion.movie = pelicula
            performSegue(withIdentifier: "detalleMovie", sender: direccion)
        }
        else if collectionView == self.collectionViewB{
            let pelicula = popularMovie[indexPath.row]
            direccion.movie = pelicula
            performSegue(withIdentifier: "detalleMovie", sender: direccion)
        }
        else if collectionView == self.collectionViewC{
            let pelicula = topRatedMovie[indexPath.row]
            direccion.movie = pelicula
            performSegue(withIdentifier: "detalleMovie", sender: direccion)
        }else{
            let pelicula = upComingMovie[indexPath.row]
            direccion.movie = pelicula
            performSegue(withIdentifier: "detalleMovie", sender: direccion)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalleMovie"{
            let siguienteVC = segue.destination as! DetalleViewController
            siguienteVC.user = uid
            siguienteVC.pelicula = direccion.movie
        }else if segue.identifier == "segueUsuario"{
            let siguienteVC = segue.destination as! UsuarioViewController
            siguienteVC.user = direccion.user
            
        }
        
    }
}
