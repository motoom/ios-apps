
//  QuotesDatabase.swift

import Foundation

class QuotesDatabase {
    static let sharedInstance = QuotesDatabase()

    var quotes: [Int: Quote] = [
         6: Quote("Zenyatta", "Repetition is the path to mastery."),

        90: Quote("Ayn Rand", "A creative man is motivated by the desire to achieve, not by the desire to beat others."),

        22: Quote("Ayn Rand", "The smallest minority on earth is the individual. Those who deny individual rights cannot claim to be defenders of minorities."),

        23: Quote("Albert Einstein", "Everything should be made as simple as possible, but not simpler."),

        24: Quote("Artistotle", "Pleasure in the job puts perfection in the work."),

        80: Quote("Albert Einstein", "Imagination is more important than knowledge."),

        50: Quote("Ayn Rand", "Wealth is the product of man's capacity to think."),

        51: Quote("Ayn Rand", "Throughout the centuries there were men who took first steps, down new roads, armed with nothing but their own vision."),

         7: Quote("Zenyatta", "Overconfidence is a flimsy shield."),

        25: Quote("Albert Einstein", "Great spirits have always encountered violent opposition from mediocre minds."),

         9: Quote("Zenyatta", "One cannot survive on strength alone."),

        40: Quote("Artistotle", "No great genius has ever existed without some touch of madness."),

        43: Quote("Artistotle", "We are what we repeatedly do. Excellence, then, is not an act, but a habit."),

        13: Quote("Zenyatta", "True self is without form."),

        30: Quote("Artistotle", "All men by nature desire knowledge."),

        32: Quote("Ayn Rand", "Money is only a tool. It will take you wherever you wish, but it will not replace you as the driver."),

        36: Quote("Zenyatta", "Even the teacher can learn from his student."),

        29: Quote("Zenyatta", "Adversity is an opportunity for change."),

        57: Quote("Albert Einstein", "Two things are infinite: the universe and human stupidity; and I'm not sure about the universe."),

        55: Quote("Zenyatta", "You are your own worst enemy."),

        54: Quote("Zenyatta", "Pain is an excellent teacher."),

         3: Quote("Zenyatta", "Consider only victory. Make defeat an impossibility in your mind."),

        99: Quote("Albert Einstein", "Anyone who has never made a mistake has never tried anything new."),

         1: Quote("Zenyatta", "If you do not bend... you break."),

        98: Quote("Artistotle", "It is the mark of an educated mind to be able to entertain a thought without accepting it."),
        ]

    func quoteCount() -> Int {
        return quotes.count
        }

    // TODO: fetch(filter?) -> levert array op van quotes, al dan niet gefilterd

    // Mimic SQL's SELECT, INSERT INTO, UPDATE, DELETE FROM.

    func fetchone(id: Int) -> Quote? {
        return quotes[id]
        }

    func select(filter: String = "") -> [Int] {
        // TODO: filtering
        return Array(quotes.keys)
        }

    func insert(author: String, _ quote: String) -> Int {
        let newid = (quotes.keys.maxElement() ?? 0) + 1
        quotes[newid] = Quote(author, quote)
        return newid
        }

    func update(id: Int, _ author: String, _ quote: String) {
        quotes[id] = Quote(author, quote)
        }

    func delete(id: Int) {
        quotes.removeValueForKey(id)
        }
    }
