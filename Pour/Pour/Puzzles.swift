import Foundation

class Puzzle
{
    var vesselCount = 0
    var targetContent = 0
    var capacity: [Int] = []
    var content: [Int] = []
}


class Puzzles
{
    var db = [Int: [Int: [String]]]() // Mapping from NrOfVessels -> Difficulty -> [Puzzlestrings]


   func unhex(digit: Character) -> Int {
        return Int(String(digit), radix: 16)!
        }


    func extractClassification(line: String) -> (Int, Int) {
        var vesselCount = 0
        var difficulty = 0
        for (nr, c) in line.characters.enumerate() {
            if nr == 1 {
                vesselCount = unhex(c)
                }
            else if nr == 2 {
                difficulty = unhex(c)
                }
            else if nr > 2 {
                break
                }
            }
        return (vesselCount, difficulty)
        }


    init() {
        // Read the database with precomputed puzzles.
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("Puzzles", ofType: "dat")
        let text = try? String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        let lines: [String] = (text?.componentsSeparatedByString("\n"))!
        // Toss into bins (indexable by nr. of vessels and difficulty)
        let start = NSDate()
        for line in lines {
            var vesselCount, difficulty: Int
            (vesselCount, difficulty) = extractClassification(line)
            if db.indexForKey(vesselCount) == nil {
                db[vesselCount] = [Int: [String]]()
                }
            if db[vesselCount]!.indexForKey(difficulty) == nil {
                db[vesselCount]![difficulty] = [String]()
                }
            db[vesselCount]![difficulty]!.append(line)
            }
        print(abs(start.timeIntervalSinceNow), "seconds used for building puzzle database")
        }


    func dump() {
        var totalCount = 0
        for key in db.keys {
            for subkey in db[key]!.keys {
                let puzzleCount = db[key]![subkey]!.count
                totalCount += puzzleCount
                print("vesselcount \(key) / difficulty \(subkey) has \(puzzleCount) puzzles")
                }
            }
        print("\(totalCount) puzzles total")
        }

    func extractPuzzle(line: String) -> Puzzle {
        let puzzle = Puzzle()
        for (nr, c) in line.characters.enumerate() {
            if nr == 1 {
                puzzle.vesselCount = unhex(c)
                }
            else if nr == 3 {
                puzzle.targetContent = unhex(c)
                }
            else if nr > 3 {
                break
                }
            }
        for i in 0 ..< puzzle.vesselCount {
            let index = 4 + i * 2
            let contentDigit = line.substringWithRange(Range<String.Index>(start: line.startIndex.advancedBy(index), end: line.startIndex.advancedBy(index + 1)))
            let capacityDigit = line.substringWithRange(Range<String.Index>(start: line.startIndex.advancedBy(index + 1), end: line.startIndex.advancedBy(index + 2)))
            puzzle.content.append(unhex(Character(contentDigit)))
            puzzle.capacity.append(unhex(Character(capacityDigit)))
            }
        return puzzle
        }

    func randomPuzzle(vesselCount: Int, difficulty: Int) -> Puzzle {
        let coll = db[vesselCount]![difficulty]!
        let index = Int(arc4random_uniform(UInt32(coll.count)))
        return extractPuzzle(coll[index])
        }
}


/*
0          Shaker (random letter a-z, A-Z)
1          Nr. of vessels in this puzzle (hex digit: 3, 4 or 5)
2          Difficulty; approx. mimimum nr. of steps necessary to solve this puzzle (hex digit)
3          Target contents (hex digit)
4          Initial contents of vessel 0 (hex digit)
5          Capacity of vessel 0 (hex digit)
6 and 7    Initial contents and capacity of vessel 1
8 and 9    Initial contents and capacity of vessel 2
10 and 11  Initial contents and capacity of vessel 3
12 and 13  Initial contents and capacity of vessel 4
*/