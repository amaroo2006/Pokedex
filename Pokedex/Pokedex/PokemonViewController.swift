//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Ansh Maroo on 5/17/20.
//  Copyright © 2020 Mygen Contac. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var pokemonImage: UIImageView!
    
    @IBOutlet var flavorText: UILabel!
    
    
    var pokemon: Pokemon!
    var pokemonCaught: Bool = false
    var pokemonUnlocked: String! = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonUnlocked = UserDefaults.standard.string(forKey: pokemon.name)
        pokemonCaught = UserDefaults.standard.bool(forKey: pokemon.name)
        
        setTitle()
        type1Label.text = ""
        type2Label.text = ""
        loadPokemon()
        
        
    }
    
    func loadPokemon() {
        var url = URL(string: pokemon.url)
        
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                DispatchQueue.main.async {
                    self.nameLabel.text = self.capitalize(text: self.pokemon.name)
                    self.numberLabel.text = self.capitalize(text: String(format: "#%03d", pokemonData.id))
                    
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            
                            self.type1Label.text = self.capitalize(text: typeEntry.type.name)
                        }
                        else if typeEntry.slot == 2 {
                            
                            self.type2Label.text = self.capitalize(text: typeEntry.type.name)
                        }
                    }
                }
                var url = URL(string: pokemonData.sprites.front_default)
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)

                DispatchQueue.main.async {
                   self.pokemonImage.image = image
                }
                url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(pokemonData.id)/")
                guard let u = url else {
                    return
                }
                
                URLSession.shared.dataTask(with: u, completionHandler: {(data, response, error) in
                    guard let data = data else {
                        return
                    }
                    do {
                        let pokemonSpeciesData = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                        for textEntry in pokemonSpeciesData.flavor_text_entries {
                            if textEntry.language.name == "en" {
                                DispatchQueue.main.async {
                                    self.flavorText.text = textEntry.flavor_text
                                    
                                }
                                break
                            }
                        }
                    }
                    catch let error {
                        print("\(error)")
                    }
                }).resume()
                
            }
                
            catch let error{
                print("\(error)")
            }
            
        }.resume()

    }
    
    func getFlavorText(data: PokemonData, url: URL) {
        
        
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let pokemonSpeciesData = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                for textEntry in pokemonSpeciesData.flavor_text_entries {
                    if textEntry.language.name == "en" {
                        DispatchQueue.main.async {
                            self.flavorText.text = textEntry.flavor_text
                        }
                        break
                    }
                }
            }
            catch let error {
                print("\(error)")
            }
        })
    }
    
    func capitalize(text: String) -> String {
        text.prefix(1).uppercased() + text.dropFirst()
    }
    
    @IBAction func toggleCatch() {
        
        if pokemonUnlocked == "false" {
            pokemonUnlocked = "true"
            UserDefaults.standard.set(pokemonUnlocked, forKey: pokemon.name)
        }
        pokemonCaught = !pokemonCaught
        UserDefaults.standard.set(pokemonCaught, forKey: pokemon.name)
        setTitle()
        
    }
    func setTitle() {
        if pokemonCaught == true {
            catchButton.setTitle("Caught!", for: .normal)
        }
        if pokemonCaught == false {
            catchButton.setTitle("Released!", for: .normal)
        }
        if pokemonUnlocked == "false" {
            catchButton.setTitle("Catch!", for: .normal)
            
        }

    }
    
}
