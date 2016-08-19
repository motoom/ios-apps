
//  QuoteProtocol.swift

import Foundation

protocol QuoteProtocol {
    func getId() -> Int? // Id of quote to edit, or nil when adding a quote.
    func getQuote(id: Int) -> Quote
    func updateQuote(id: Int, _ author: String, _ quote: String)
    func addQuote(author: String, _ quote: String) -> Int
    }
