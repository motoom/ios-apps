
//  Adressering.swift

import Foundation

class Adressering: NSObject, NSCoding {
    var naam: String = ""
    var adres: String = ""
    var plaats: String = ""

    init(_ naam: String, _ adres: String, _ plaats: String) {
        self.naam = naam
        self.adres = adres
        self.plaats = plaats
        }

    required init(coder unarchiver: NSCoder) {
        super.init()
        naam = unarchiver.decodeObjectForKey("naam") as! String
        adres = unarchiver.decodeObjectForKey("adres") as! String
        plaats = unarchiver.decodeObjectForKey("plaats") as! String
        }

    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(naam, forKey: "naam")
        archiver.encodeObject(adres, forKey: "adres")
        archiver.encodeObject(plaats, forKey: "plaats")
        }

    }