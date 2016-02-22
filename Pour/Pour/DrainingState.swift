
// Drain all vessels until empty, then return to title screen.

import GameplayKit

class DrainingState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnterWithPreviousState(prevState: GKState?) {
        super.didEnterWithPreviousState(prevState)
        print("Entered Draining from \(prevState)")
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("DrainingState.updateWithDeltaTime(\(seconds))")
        super.updateWithDeltaTime(seconds)
        // TODO: Drain animation, and when done:
        self.stateMachine?.enterState(TitleState)
        }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is TitleState.Type
        }

    }


