
// Display some kind of confirmation that the puzzle is solved

import GameplayKit

class SolvedState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnter(from prevState: GKState?) {
        super.didEnter(from: prevState)
        print("Entered Solved from \(prevState)")
    }

    override func update(deltaTime seconds: TimeInterval) {
        print("SolvedState.updateWithDeltaTime(\(seconds))")
        super.update(deltaTime: seconds)
        // TODO: Confirmation
        self.stateMachine?.enter(DrainingState.self)
        }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is DrainingState.Type
        }

    }


