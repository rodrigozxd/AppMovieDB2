//
//  DetalleViewController.swift
//  AppMovieDB2
//
//  Created by Mac 10 on 11/29/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetalleViewController: UIViewController {
    
    var pelicula:Movie?
    var user:String = ""
    var keypelicua = ""
    let movies: [Movie] = []

    @IBOutlet weak var tituloMovie: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var detalleMovie: UILabel!
    @IBOutlet weak var genero: UILabel!
    @IBOutlet weak var likes: UIButton!
    
    var encanta = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tituloMovie!.text = pelicula?.title
        let url = pelicula?.posterURL
        if let data = try? Data(contentsOf: URL(string: (url)!.absoluteString)!) {
            imageMovie.image = UIImage(data: data)
        }
        fecha.text = "Año: \((pelicula?.release_date)!)       -       Votacion: ⭐️ \( (pelicula?.vote_average)!)"
        detalleMovie.text = pelicula?.overview
        genero.text = "Genero: \((pelicula?.genreText)!)"
        
        Database.database().reference().child("Usuarios").child(user).child("pelicula").observe(DataEventType.childAdded, with: { (snapshot) in
            let movie = (snapshot.value as! NSDictionary)["title"] as! String
            
            if movie == self.pelicula?.title{
                self.keypelicua = snapshot.key
                print(self.keypelicua)
                self.encanta = false
                let imagen = UIImage(named: "like")
                self.likes.setImage(imagen, for: .normal)
            }
        })
    }
    
    @IBAction func btnLike(_ sender: UIButton) {
        let id:Int = (pelicula?.id)!
        let title:String = (pelicula?.title)!
        let poster_path:String = (pelicula?.poster_path)!
        let backdrop_path:String = (pelicula?.backdrop_path)!
        let release_date:String = (pelicula?.release_date)!
        let vote_average:Double = (pelicula?.vote_average)!
        let overview:String = (pelicula?.overview)!
        let genre_ids:[Int] = (pelicula?.genre_ids)!
        
        if encanta == true{
            encanta = false
            let imagen = UIImage(named: "like")
            likes.setImage(imagen, for: .normal)
            let snap = ["id":id, "title" : title , "poster_path": poster_path, "backdrop_path": backdrop_path, "release_date": release_date, "vote_average": vote_average, "overview": overview, "genre_ids": genre_ids] as [String : Any]
            Database.database().reference().child("Usuarios").child(user).child("pelicula").childByAutoId().setValue(snap)
        }else{
            encanta = true
            let imagen = UIImage(named: "dislike")
            likes.setImage(imagen, for: .normal)
            Database.database().reference().child("Usuarios").child(user).child("pelicula").child(keypelicua).removeValue()
        }

        
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


