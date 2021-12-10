//
//  ThreeViewController.swift
//  AppMovieDB2
//
//  Created by Mac 10 on 12/6/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ThreeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tablePelicula: UITableView!
    
    var movie = [Movie]()
    
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePelicula.delegate = self
        tablePelicula.dataSource = self
        
        Database.database().reference().child("Usuarios").child(uid).child("pelicula").observe(DataEventType.childAdded, with: { (snapshot) in
            let id = (snapshot.value as! NSDictionary)["id"] as! Int
            let title = (snapshot.value as! NSDictionary)["title"] as! String
            let backdrop = (snapshot.value as! NSDictionary)["backdrop_path"] as! String
            let poster = (snapshot.value as! NSDictionary)["poster_path"] as! String
            let overview = (snapshot.value as! NSDictionary)["overview"] as! String
            let vote = (snapshot.value as! NSDictionary)["vote_average"] as! Double
            let release = (snapshot.value as! NSDictionary)["release_date"] as! String
            let genre = (snapshot.value as! NSDictionary)["genre_ids"] as! [Int]
            let llave = snapshot.key
            
            self.movie.append(Movie(id: id, title: title, backdrop_path: backdrop, poster_path: poster, overview: overview, vote_average: vote, release_date: release, genre_ids: genre, key: llave))
            self.tablePelicula.reloadData()
        })
        Database.database().reference().child("Usuarios").child(uid).child("pelicula").observe(DataEventType.childRemoved, with: { (snapshot) in
            var iterador = 0
            for snap in self.movie{
                if snap.key == snapshot.key{
                    self.movie.remove(at: iterador)
                }
                iterador += 1
            }
            self.tablePelicula.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula = movie[indexPath.row]
        performSegue(withIdentifier: "detalle", sender: pelicula)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablePelicula.dequeueReusableCell(withIdentifier: "celda") as! CustomCell
        let pelicula = movie[indexPath.row]
        let url = pelicula.posterURL
        if let data = try? Data(contentsOf: URL(string: (url).absoluteString)!) {
            cell.imagen.image = UIImage(data: data)
        }
        cell.txt1?.text = pelicula.title
        cell.txt2?.text = "Año: \((pelicula.release_date)!)"
        cell.txt4?.text = "Votacion: ⭐️ \( (pelicula.vote_average)!)"
        cell.txt3?.text = "Genero: \(pelicula.genreText)"
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalle"{
            let siguienteVC = segue.destination as! DetalleViewController
            siguienteVC.user = uid
            siguienteVC.pelicula = sender as? Movie
        }
        
    }
}
