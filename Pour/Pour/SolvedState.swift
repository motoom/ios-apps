
// Display some kind of confirmation that the puzzle is solved

import GameplayKit

class SolvedState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnterWithPreviousState(prevState: GKState?) {
        super.didEnterWithPreviousState(prevState)
        print("Entered Solved from \(prevState)")
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("SolvedState.updateWithDeltaTime(\(seconds))")
        super.updateWithDeltaTime(seconds)
        // TODO: Confirmation
        self.stateMachine?.enterState(DrainingState)
        }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is DrainingState.Type
        }

    }


