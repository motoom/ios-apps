
// Fill the vessels to their starting contents.

import GameplayKit

class FillingState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnter(from prevState: GKState?) {
        super.didEnter(from: prevState)
        print("Entered Filling from \(prevState)")
    }

    override func update(deltaTime seconds: TimeInterval) {
        print("FillingState.updateWithDeltaTime(\(seconds))")
        super.update(deltaTime: seconds)
        // TODO: Animate, and when done:
        self.stateMachine?.enter(SelectingState.self)
        }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is SelectingState.Type
        }

    }


