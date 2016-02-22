
// Let the user select a source and destination vessel.
// TODO: Might be more states?

import GameplayKit

class SelectingState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnterWithPreviousState(prevState: GKState?) {
        super.didEnterWithPreviousState(prevState)
        print("Entered Selecting from \(prevState)")
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("SelectingState.updateWithDeltaTime(\(seconds))")
        super.updateWithDeltaTime(seconds)
        // TODO: Let user do their thing, and when done:
        self.stateMachine?.enterState(PouringState)
        }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is PouringState.Type
        }

    }


