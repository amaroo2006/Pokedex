//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ansh Maroo on 5/17/20.
//  Copyright © 2020 Mygen Contac. All rights reserved.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable, Equatable, Hashable {
    let name : String
    let url: String
    

}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: PokemonSprites
    
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonSprites: Codable {
    let front_default: String
}

struct FlavorTextEntry: Codable {
    let flavor_text: String
    let language: Language
}

struct Language: Codable {
    let name: String
    let url: String
}

struct PokemonSpecies: Codable {
    let flavor_text_entries: [FlavorTextEntry]
}
