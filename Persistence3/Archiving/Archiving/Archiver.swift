
// Archiver.swift
// Michiel Overtoom, motoom@xs4all.nl

import Foundation

class Archiver {

    static func documentFilename(filename: String) -> String {
        let docdir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return docdir.URLByAppendingPathComponent(filename).path!
        }

    static func save(obj: AnyObject, _ filename: String) -> Bool {
        let data = NSKeyedArchiver.archivedDataWithRootObject(obj)
        return data.writeToFile(documentFilename(filename), atomically: true)
        }

    static func load(filename: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(documentFilename(filename))
        }
    }
