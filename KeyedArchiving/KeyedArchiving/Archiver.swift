
// Archiver.swift
// Michiel Overtoom, motoom@xs4all.nl

import Foundation

class Archiver {
    static func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
        }

    static func documentFilename(filename: String) -> String {
        return getDocumentsDirectory() + "/" + filename
        }

    static func save(obj: AnyObject, _ filename: String) -> Bool {
        let data = NSKeyedArchiver.archivedDataWithRootObject(obj)
        return data.writeToFile(documentFilename(filename), atomically: true)
        }

    static func load(filename: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(documentFilename(filename))
        }
    }
