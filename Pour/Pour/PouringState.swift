
// Animate the pouring from source to destination

import GameplayKit

class PouringState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnterWithPreviousState(prevState: GKState?) {
        super.didEnterWithPreviousState(prevState)
        print("Entered Pouring from \(prevState)")
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("PouringState.updateWithDeltaTime(\(seconds))")
        super.updateWithDeltaTime(seconds)
        // TODO: Depending on whether puzzle is solved:
        if arc4random_uniform(100) > 80 {
            self.stateMachine?.enterState(SolvedState)
            }
        else {
            self.stateMachine?.enterState(SelectingState)
            }
        }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is SelectingState.Type || stateClass is SolvedState.Type
        }

    }



