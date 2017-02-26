
// Let the user select a source and destination vessel.
// TODO: Might be more states?

import GameplayKit

class SelectingState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnter(from prevState: GKState?) {
        super.didEnter(from: prevState)
        print("Entered Selecting from \(prevState)")
    }

    override func update(deltaTime seconds: TimeInterval) {
        print("SelectingState.updateWithDeltaTime(\(seconds))")
        super.update(deltaTime: seconds)
        // TODO: Let user do their thing, and when done:
        self.stateMachine?.enter(PouringState.self)
        }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PouringState.Type
        }

    }


