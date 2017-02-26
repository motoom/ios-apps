
// Drain all vessels until empty, then return to title screen.

import GameplayKit

class DrainingState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnter(from prevState: GKState?) {
        super.didEnter(from: prevState)
        print("Entered Draining from \(prevState)")
    }

    override func update(deltaTime seconds: TimeInterval) {
        print("DrainingState.updateWithDeltaTime(\(seconds))")
        super.update(deltaTime: seconds)
        // TODO: Drain animation, and when done:
        self.stateMachine?.enter(TitleState.self)
        }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is TitleState.Type
        }

    }


