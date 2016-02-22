
// Fill the vessels to their starting contents.

import GameplayKit

class FillingState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnterWithPreviousState(prevState: GKState?) {
        super.didEnterWithPreviousState(prevState)
        print("Entered Filling from \(prevState)")
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("FillingState.updateWithDeltaTime(\(seconds))")
        super.updateWithDeltaTime(seconds)
        // TODO: Animate, and when done:
        self.stateMachine?.enterState(SelectingState)
        }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is SelectingState.Type
        }

    }


