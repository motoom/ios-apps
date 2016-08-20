
//  QuotesDatabase.swift

import Foundation

class QuotesDatabase {
    static let sharedInstance = QuotesDatabase()

    // TODO: dictionary ipv. array, keyen op record-id  34 -> Quote("Aap", "Noot")

    var quotes = [
        Quote("Zenyatta", "Repetition is the path to mastery."),
        Quote("Ayn Rand", "A creative man is motivated by the desire to achieve, not by the desire to beat others."),
        Quote("Ayn Rand", "The smallest minority on earth is the individual. Those who deny individual rights cannot claim to be defenders of minorities."),
        Quote("Albert Einstein", "Everything should be made as simple as possible, but not simpler."),
        Quote("Artistotle", "Pleasure in the job puts perfection in the work."),
        Quote("Albert Einstein", "Imagination is more important than knowledge."),
        Quote("Ayn Rand", "Wealth is the product of man's capacity to think."),
        Quote("Ayn Rand", "Throughout the centuries there were men who took first steps, down new roads, armed with nothing but their own vision."),
        Quote("Zenyatta", "Overconfidence is a flimsy shield."),
        Quote("Albert Einstein", "Great spirits have always encountered violent opposition from mediocre minds."),
        Quote("Zenyatta", "One cannot survive on strength alone."),
        Quote("Artistotle", "No great genius has ever existed without some touch of madness."),
        Quote("Artistotle", "We are what we repeatedly do. Excellence, then, is not an act, but a habit."),
        Quote("Zenyatta", "True self is without form."),
        Quote("Artistotle", "All men by nature desire knowledge."),
        Quote("Ayn Rand", "Money is only a tool. It will take you wherever you wish, but it will not replace you as the driver."),
        Quote("Zenyatta", "Even the teacher can learn from his student."),
        Quote("Zenyatta", "Adversity is an opportunity for change."),
        Quote("Albert Einstein", "Two things are infinite: the universe and human stupidity; and I'm not sure about the universe."),
        Quote("Zenyatta", "You are your own worst enemy."),
        Quote("Zenyatta", "Pain is an excellent teacher."),
        Quote("Zenyatta", "Consider only victory. Make defeat an impossibility in your mind."),
        Quote("Albert Einstein", "Anyone who has never made a mistake has never tried anything new."),
        Quote("Zenyatta", "If you do not bend... you break."),
        Quote("Artistotle", "It is the mark of an educated mind to be able to entertain a thought without accepting it."),
        ]

    func quoteCount() -> Int {
        return quotes.count
        }

    // TODO: fetch(filter?) -> levert array op van quotes, al dan niet gefilterd

    // Mimic SQL's SELECT, INSERT INTO, UPDATE, DELETE FROM.
    func select(id: Int) -> Quote {
        return quotes[id]
        }

    func insert(author: String, _ quote: String) -> Int {
        quotes.append(Quote(author, quote))
        return quotes.count - 1
        }

    func update(id: Int, _ author: String, _ quote: String) {
        quotes[id] = Quote(author, quote)
        }

    func delete(id: Int) {
        quotes.removeAtIndex(id)
        }
    }
