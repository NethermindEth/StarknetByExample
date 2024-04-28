// SPDX-License-Identifier: MIT

/// # SRC5 Component
///
/// The SRC5 component allows contracts to expose the interfaces they implement

#[starknet::component]
mod SRC5Component {
    use interface;

    #[storage]
    struct Storage {
        SRC5_supported_interfaces: LegacyMap<felt252, bool>
    }

    mod Errors {
        const INVALID_ID: felt252 = `SRC5: invalid id`;
    }

     #[embeddable_as(SRC5Impl)]
     impl SRC5<TContractState, +HasComponent<TContractState>
     > of interface::ISRC5<ComponentState<TContractState>> {

        fn supports_interface(
            self: @ComponentState<TContractState>, interface_id: felt252
        ) -> bool {
            if interface_id == interface::ISRC5_ID {
                return true;
            }
            self.SRC5_supported_interfaces.read(interface_id)
        }
     }

     #[generate_trait]
     impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {

        fn register_interface(ref self: ComponentState<TContractState>, interface_id: felt252 ) {
            self.SRC5_supported_interfaces.write(interface_id, true);
        }

        fn deregister_interface(ref self: ComponentState<TContractState>, interface_id: felt252) {
            assert(interface_id != interface::ISRC5_ID, Errors::INVALID_ID);
            self.SRC5_supported_interfaces.write(interface_id, false);
        }
    }
}


