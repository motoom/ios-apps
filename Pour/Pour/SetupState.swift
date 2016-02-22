
// Setup a new puzzle.

import GameplayKit

class SetupState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnterWithPreviousState(prevState: GKState?) {
        super.didEnterWithPreviousState(prevState)
        print("Entered Setup from \(prevState)")
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("SetupState.updateWithDeltaTime(\(seconds))")
        super.updateWithDeltaTime(seconds)        
        // TODO: Setup a new puzzle
        self.stateMachine?.enterState(FillingState)
        }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is FillingState.Type
        }

    }


