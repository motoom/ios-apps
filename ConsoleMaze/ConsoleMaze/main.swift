
import Foundation

// TODO: Enums?
let WALLNORTH = 1 // Walls
let WALLEAST = 2
let WALLSOUTH = 4
let WALLWEST = 8
let VISITED = 16 // Used during maze generation

let NORTH = 0
let EAST = 1
let SOUTH = 2
let WEST = 3

class Maze {
    var rowcount: Int = 0
    var colcount: Int = 0
    var cells: Array<Array<Int>>

    // Wall bits for NORTH, EAST, SOUTH, WEST
    let wallbit = [WALLNORTH, WALLEAST, WALLSOUTH, WALLWEST]

    // Coordinate offsets for NORTH, EAST, SOUTH, WEST
    let drow = [-1, 0, 1, 0]
    let dcol = [0, 1, 0, -1]

    // Directions opposite of NORTH, EAST, SOUTH, WEST
    let opposite = [SOUTH, WEST, NORTH, EAST]



    init(_ rowcount: Int, _ colcount: Int) {
        self.rowcount = rowcount
        self.colcount = colcount
        // See http://stackoverflow.com/questions/25127700/two-dimensional-array-in-swift
        cells = Array(count: rowcount, repeatedValue: Array(count: colcount, repeatedValue: 0))
        generate()
    }


    func generateStep(row: Int, _ col: Int) {
        var directions = [NORTH, EAST, SOUTH, WEST]
        // Randomize the directions, so the path will meander.
        for a in 0 ..< 4 {
            let b = Int(arc4random() & 3)
            (directions[a], directions[b]) = (directions[b], directions[a])
            }
        // Iterate over the directions.
        for dir in 0 ..< 4 {
            // Determine the coordinates of the cell in that direction.
            let direction = directions[dir]
            let newrow = row + drow[direction]
            let newcol = col + dcol[direction]
            // Decide if the cell is valid or not. Skip cells outside the maze.
            if newrow < 0 || newrow >= rowcount { continue }
            if newcol < 0 || newcol >= colcount { continue }
            // New cell must not have been previously visited.
            if cells[newrow][newcol] & VISITED != 0 { continue }
            // Cut down the walls.
            cells[row][col] &= ~wallbit[direction]
            cells[row][col] |= VISITED
            cells[newrow][newcol] &= ~wallbit[opposite[direction]]
            cells[newrow][newcol] |= VISITED
            generateStep(newrow, newcol)
            }
        }

    // Maze generation according to http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking
    func generate() {
        // Start with all walls up, also clears 'visited' bit.
        for r in 0 ..< rowcount {
            for c in 0 ..< colcount {
                cells[r][c] = WALLNORTH|WALLEAST|WALLSOUTH|WALLWEST
                }
            }
        // ...and generate the maze from the middle.
        generateStep(rowcount / 2, colcount / 2)
        }


    func asciiRepresentation() -> String {
        var s = " "
        for _ in 0 ..< self.colcount * 2 - 1 {
            s += "_"
            }
        s += "\n"
        for r in 0 ..< self.rowcount {
            s += "|"
            for c in 0 ..< self.colcount {
                if cells[r][c] & WALLSOUTH != 0 {
                    if cells[r][c] & WALLEAST != 0 {
                        s += "_|" // └├┤└┐┣╋━┃
                        }
                    else {
                        s += "__"
                        }
                    }
                else {
                    if cells[r][c] & WALLEAST != 0 {
                        s += " |"
                        }
                    else {
                        s += "  "
                        }
                    }
                }
            s += "\n"
            }
        return s
        }
}


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
