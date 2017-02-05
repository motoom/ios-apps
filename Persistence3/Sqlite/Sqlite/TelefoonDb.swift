
// TelefoonDb.swift
// Singleton-wrapper voor SqliteDb

class TelefoonDb: SqliteDb {
    static let sharedInstance = TelefoonDb()
    }
