// [!region enums]
#[derive(Drop, Serde, Copy, starknet::Store)]
struct Position {
    x: u32,
    y: u32,
}

#[derive(Drop, Serde, Copy, starknet::Store)]
enum UserCommand {
    #[default]
    Login,
    UpdateProfile,
    Logout,
}

#[derive(Drop, Serde, Copy, starknet::Store)]
enum Action {
    #[default]
    Quit,
    Move: Position,
    SendMessage: felt252,
    ChangeAvatarColor: (u8, u8, u8),
    ProfileState: UserCommand,
}
// [!endregion enums]

// [!region enum_contract]
#[starknet::interface]
trait IEnumContract<TContractState> {
    fn register_action(ref self: TContractState, action: Action);
    fn generate_default_actions_list(self: @TContractState) -> Array<Action>;
}

#[starknet::contract]
mod EnumContract {
    use starknet::storage::StoragePointerWriteAccess;
    use super::IEnumContract;
    use super::{Action, Position, UserCommand};

    #[storage]
    struct Storage {
        most_recent_action: Action,
    }

    #[abi(embed_v0)]
    impl IEnumContractImpl of IEnumContract<ContractState> {
        fn register_action(ref self: ContractState, action: Action) {
            // quick note: match takes ownership of variable (but enum Action implements Copy trait)
            match action {
                Action::Quit => "Quit",
                Action::Move(value) => format!("Move with x: {} and y: {}", value.x, value.y),
                Action::SendMessage(msg) => format!("Write with message: {}", msg),
                Action::ChangeAvatarColor((
                    r, g, b,
                )) => format!("Change color to r: {}, g: {}, b: {}", r, g, b),
                Action::ProfileState(state) => {
                    let profile_state = match state {
                        UserCommand::Login => 1,
                        UserCommand::UpdateProfile => 2,
                        UserCommand::Logout => 3,
                    };
                    format!("profile_state: {}", profile_state)
                },
            };

            self.most_recent_action.write(action);
        }

        fn generate_default_actions_list(self: @ContractState) -> Array<Action> {
            let actions = array![
                Action::Quit,
                Action::Move(Position { x: 1, y: 2 }),
                Action::SendMessage('here is my message'),
                Action::ChangeAvatarColor((1, 2, 3)),
                Action::ProfileState(UserCommand::Login),
            ];

            actions
        }
    }
}
// [!endregion enum_contract]


