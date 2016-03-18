
// editor-identation-style: banner

import Foundation


// Specifies how many vessels a configuration contains, and their capacity.
struct CapacitiesConfig {
    var capacity: [Int] = []
    }

// Idem, but their contents.
struct ContentsConfig: Hashable {
    var content: [Int] = []

    // http://stackoverflow.com/questions/31438210/how-to-implement-the-hashable-protocol-in-swift-for-an-int-array-a-custom-strin
    var hashValue: Int {
        var v = 0
        for nr in content {
            v <<= 4
            v |= nr
            }
        return v
        }
    }

// Required for Hashable protocol.
func ==(left: ContentsConfig, right: ContentsConfig) -> Bool {
    return left.content == right.content
    }


// Specifies a pouring from a vessel into another.
struct Pouring {
    var from: Int
    var to: Int
    }


// Given a specific configuration of vessels and a pouring, can the pouring be done?
func canPour(capacities: CapacitiesConfig, _ contents: ContentsConfig, _ pouring: Pouring) -> Bool
{
    if pouring.from == pouring.to { // Can't pour a vessel into itself.
        return false
        }
    if contents.content[pouring.from] == 0 { // Can't pour from an empty vessel.
        return false;
        }
    if contents.content[pouring.to] >= capacities.capacity[pouring.to] { // Can't pour to a full vessel.
        return false;
        }
    return true;
}


// Given a specific configuration of vessels and a pouring, what quantity of fluid can be transferred?
func pourableQuantity(capacities: CapacitiesConfig, _ contents: ContentsConfig, _ pouring: Pouring) -> Int
{
    let room = capacities.capacity[pouring.to] - contents.content[pouring.to]
    var quantity = contents.content[pouring.from]
    if quantity > room {
        quantity = room
        }
    return quantity
}


// Return a new contents configuration resulting from a pouring. Assumes the pouring is valid.
func performPouring(capacities: CapacitiesConfig, _ contents: ContentsConfig, _ pouring: Pouring) -> ContentsConfig
{
    var result = ContentsConfig(content: contents.content)
    let q = pourableQuantity(capacities, result, pouring)
    result.content[pouring.from] -= q
    result.content[pouring.to] += q
    return result
}


func solve(capacities: CapacitiesConfig, _ contents: ContentsConfig,  _ target: Int) -> [Pouring]?
{
    var configs: [ContentsConfig] = [] // All reached configurations, including the given one.
    var pourings: [(Int, Pouring)] = [] // Array of tuples of (source configuration index, pouring).
    var processed = Set<ContentsConfig>() // Earlier processed configurations, to prevent duplicates.

    configs.append(contents)
    pourings.append((0, Pouring(from: 0, to: 0)))

    // Generate configs until
    // - target volume reached (return an array of pourings for quickest solution)
    // - no more new configs found (in this case, return nil, denoting 'no solution found')
    var extending = true
    while extending {
        extending = false // Assume we're done.

        // Extend the configs array with new configs, if possible.
        var index = configs.count - 1
        while index >= 0 {
            // The configuration to process.
            let current = configs[index]

            // Target present anywhere?
            for c in current.content {
                if c == target { // Solved!
                    // Traceback the necessary pourings
                    var solvesteps = [Pouring]()
                    while index != 0 {
                        let (fromindex, pouring) = pourings[index]
                        solvesteps.append(pouring)
                        index = fromindex
                        }
                    return solvesteps.reverse()
                    }
                }

            if processed.contains(current) {
                index -= 1
                continue
                }

            // Try all possible pourings.
            for to in 0 ..< capacities.capacity.count {
                for from in 0 ..< capacities.capacity.count {
                    let pouring = Pouring(from: from, to: to)
                    if !canPour(capacities, current, pouring) {
                        continue
                        }
                    let result = performPouring(capacities, current, pouring)
                    if processed.contains(result) {
                        continue // This configuration has been reached before, and already processed.
                        }
                    configs.append(result)
                    pourings.append((index, pouring))
                    extending = true // Apparently we're not done extending.
                    }
                }
            // Done with this one
            processed.insert(current)
            // Next one
            index -= 1
            }
        }
    return nil
}


func solvetest()
{
    let capacities = CapacitiesConfig(capacity: [12, 7, 4])
    let contents = ContentsConfig(content: [6, 4, 0])
    let newcontents = performPouring(capacities, contents, Pouring(from: 0, to: 1))
    assert(newcontents == ContentsConfig(content: [3, 7, 0]))

    let target = 8
    let res = solve(capacities, contents, target)
    if let pourings = res {
        print("Pourings:", pourings)
        }
    else {
        print("No solution")
        }
}
