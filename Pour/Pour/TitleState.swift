
// Show the title screen, initiate a new game when the user clicks anywhere.

import GameplayKit

class TitleState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnterWithPreviousState(prevState: GKState?) {
        super.didEnterWithPreviousState(prevState)
        print("Entered A from \(prevState)")
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("TitleState.updateWithDeltaTime(\(seconds))")
        super.updateWithDeltaTime(seconds)
        self.stateMachine?.enterState(SetupState)
        }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is SetupState.Type
        }

    }


