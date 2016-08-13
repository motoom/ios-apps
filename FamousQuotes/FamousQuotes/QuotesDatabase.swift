
//  QuotesDatabase.swift

import Foundation

class QuotesDatabase {
    var quotes = [
        ("Zenyatta", "Repetition is the path to mastery."),
        ("Ayn Rand", "A creative man is motivated by the desire to achieve, not by the desire to beat others."),
        ("Ayn Rand", "The smallest minority on earth is the individual. Those who deny individual rights cannot claim to be defenders of minorities."),
        ("Albert Einstein", "Everything should be made as simple as possible, but not simpler."),
        ("Artistotle", "Pleasure in the job puts perfection in the work."),
        ("Albert Einstein", "Imagination is more important than knowledge."),
        ("Ayn Rand", "Wealth is the product of man's capacity to think."),
        ("Ayn Rand", "Throughout the centuries there were men who took first steps, down new roads, armed with nothing but their own vision."),
        ("Zenyatta", "Overconfidence is a flimsy shield."),
        ("Albert Einstein", "Great spirits have always encountered violent opposition from mediocre minds."),
        ("Zenyatta", "One cannot survive on strength alone."),
        ("Artistotle", "No great genius has ever existed without some touch of madness."),
        ("Artistotle", "We are what we repeatedly do. Excellence, then, is not an act, but a habit."),
        ("Zenyatta", "True self is without form."),
        ("Artistotle", "All men by nature desire knowledge."),
        ("Ayn Rand", "Money is only a tool. It will take you wherever you wish, but it will not replace you as the driver."),
        ("Zenyatta", "Even the teacher can learn from his student."),
        ("Zenyatta", "Adversity is an opportunity for change."),
        ("Albert Einstein", "Two things are infinite: the universe and human stupidity; and I'm not sure about the universe."),
        ("Zenyatta", "You are your own worst enemy."),
        ("Zenyatta", "Pain is an excellent teacher."),
        ("Zenyatta", "Consider only victory. Make defeat an impossibility in your mind."),
        ("Albert Einstein", "Anyone who has never made a mistake has never tried anything new."),
        ("Zenyatta", "If you do not bend... you break."),
        ("Artistotle", "It is the mark of an educated mind to be able to entertain a thought without accepting it."),
        ]

    func quoteCount() -> Int {
        return quotes.count
        }

    // Mimic SQL's SELECT, INSERT INTO, UPDATE, DELETE FROM.
    func select(id: Int) -> (String, String) {
        return quotes[id]
        }

    func insert(author: String, _ quote: String) -> Int {
        quotes.append((author, quote))
        return quotes.count - 1
        }

    func update(id: Int, _ author: String, _ quote: String) {
        quotes[id] = (author, quote)
        }

    func delete(id: Int) {
        // TODO
        }
    }
