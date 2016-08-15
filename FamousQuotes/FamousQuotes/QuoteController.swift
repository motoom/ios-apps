
//  QuoteController.swift

import UIKit

class QuoteController: UIViewController {

    var delegate: QuotesController?

    @IBOutlet weak var authorText: UITextField!
    @IBOutlet weak var quoteText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        }

    override func viewWillAppear(animated: Bool) {
        if let id = delegate!.getId() {
            title =  "Edit quote"
            let (author, quote) = delegate!.getQuote(id)
            authorText.text = author
            quoteText.text = quote
            }
        else {
            title = "Add quote"
            authorText.text = ""
            quoteText.text = ""
            }
        }

    override func viewWillDisappear(animated: Bool) {
        let author = authorText.text!
        let quote = quoteText.text!
        if let id = delegate!.getId() {
            delegate!.updateQuote(id, author, quote)
            }
        else if (author != "" || quote != "") { // Don't add empty records.
            delegate!.addQuote(authorText.text!, quoteText.text!)
            }
        }
}