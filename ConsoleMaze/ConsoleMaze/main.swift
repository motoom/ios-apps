
import Foundation

// TODO: Enums?


var rows = 10, cols = 10
if Process.arguments.count == 2 {
    rows = Int(Process.arguments[1])!
    cols = Int(Process.arguments[1])!
    }
else if Process.arguments.count == 3 {
    rows = Int(Process.arguments[1])!
    cols = Int(Process.arguments[2])!
    }

let m = Maze(rows, cols)
print(m.asciiRepresentation())
