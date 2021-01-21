//
//  ViewController.swift
//  Pokedex
//
//  Created by Ansh Maroo on 5/17/20.
//  Copyright © 2020 Mygen Contac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    var pokemon: [Pokemon] = []
    var searchData: [Pokemon] = []
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        var url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=500")
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                self.searchData = self.pokemon
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }
            catch let error{
                print("\(error)")
            }
            
            
        }.resume()
        
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: searchData[indexPath.row].name)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PokemonSegue") {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = searchData[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func capitalize(text: String) -> String {
        text.prefix(1).uppercased() + text.dropFirst()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchData = []
        if searchText == "" {
            searchData = pokemon
        }
        else {
            for i in pokemon {
                if i.name.lowercased().contains(searchText.lowercased()) {
                    searchData.append(i)
                }
            }
        }
        tableView.reloadData()
        
        
    }
}

