
// SqliteDb.swift

// Low-level interface voor sqlite3 framework. Open en sluit een databasefile, doe SQL executes en queries.
// Resultset van query is een array van dictionaries, met in elke dictionary veldnaam -> veldwaarde mappings.

// TODO: Parametrised queries mogelijk maken ivm. SQL injection en quoting.

import Foundation

class SqliteDb {

    var db: COpaquePointer = nil

    // MARK: Lifecycle

    func open(filename: String) -> Bool {
        let docdir = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let dbname = docdir.URLByAppendingPathComponent(filename).absoluteString

        if (sqlite3_open(dbname, &db) != SQLITE_OK) {
            print("SqliteUtils.open: Can't open database \(filename)")
            return false
            }
        return true
        }

    func close() {
        if db == nil {
            print("SqliteUtils.close: attempt to close non-opened database")
            }
        else {
            sqlite3_close(db)
            db = nil
            }
        }

    // MARK: Operations

    func execute(cmd: String) -> Bool {
        if db == nil {
            print("SqliteUtils.execute: database is not open, can't execute: \(cmd)")
            return false
            }
        if (sqlite3_exec(db, cmd, nil, nil, nil) == SQLITE_OK) {
            return true
            }
        else {
            print("SqliteUtils.execute: Can't execute: \(cmd)")
            return false
            }
        }


    func query(sql: String) -> [[String: String]]? {
        if db == nil {
            print("SqliteUtils.query: database is not open, can't execute: \(sql)")
            return nil
            }

        var statement: COpaquePointer = nil
        if (sqlite3_prepare_v2(db, sql, -1, &statement, nil)  != SQLITE_OK) {
            print("SqliteUtils.query: Can't prepare: \(sql)")
            return nil
            }

        // Kijk hoe de kolommen in de resultset heten.
        var kolomnamen = [String]()
        for i in 0 ..< sqlite3_column_count(statement) {
            let cname = sqlite3_column_name(statement, i)
            let name = String.fromCString(cname)!
            kolomnamen.append(name)
            }

        // Ga alle rows uit de resultset bij langs, en maak een list van dictionaries met daarin de kolomnamen en -inhouden.
        var rows = [[String: String]]()
        while sqlite3_step(statement) == SQLITE_ROW {
            var row: [String: String] = [:]
            for (kolomnummer, kolomnaam) in kolomnamen.enumerate() {
                let waarde = sqlite3_column_text(statement, Int32(kolomnummer))
                let waardestr = String.fromCString(UnsafePointer<CChar>(waarde))!
                row[kolomnaam] = waardestr
                }
            rows.append(row)
            }
        sqlite3_finalize(statement)
        return rows
        }

    // MARK: Utility functions

    func tableExists(tablename: String) -> Bool {
        if let rs = query("select name from sqlite_master where type='table' and name='\(tablename)'") {
            if rs.count > 0 {
                return true
                }
            }
        return false
        }

}



