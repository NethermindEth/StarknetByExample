from starkware.starknet.public.abi import starknet_keccak

    signatures = [
    'supports_interface(felt252)->E((),())',
    'is_valid_signature(felt252,Array<felt252>)->E((),())',
    '__execute__(Array<(ContractAddress,felt252,Array<felt252>)>)->Array<(@Array<felt252>)>',
    '__validate__(Array<(ContractAddress,felt252,Array<felt252>)>)->felt252',
    '__validate_declare__(felt252)->felt252'
    ]

    def compute_interface_id():
    interface_id = 0x0
    for sig in signatures:
        function_id = starknet_keccak(sig.encode())
        interface_id ^= function_id
    print('IAccount ID:', hex(interface_id))

    compute_interface_id()