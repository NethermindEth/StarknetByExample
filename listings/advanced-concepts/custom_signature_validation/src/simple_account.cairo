#[starknet::contract]
mod SimpleAccount {
    // ANCHOR: validate
    fn __validate__(ref self: ContractState, calls: Array<Call>) -> felt252 {
        let exec_info = get_execution_info().unbox();
        let tx_info = exec_info.tx_info.unbox();
        assert_only_protocol(exec_info.caller_address);
        assert_correct_invoke_version(tx_info.version);
        assert(tx_info.paymaster_data.is_empty(), 'unsupported-paymaster');
        if self.session.is_session(tx_info.signature) {
            self
                .session
                .assert_valid_session(calls.span(), tx_info.transaction_hash, tx_info.signature,);
        } else {
            self
                .assert_valid_calls_and_signature(
                    calls.span(),
                    tx_info.transaction_hash,
                    tx_info.signature,
                    is_from_outside: false,
                    account_address: exec_info.contract_address,
                );
        }
        VALIDATED
    }
    // ANCHOR_END: validate

    // ANCHOR: execute
    fn __execute__(ref self: ContractState, calls: Array<Call>) -> Array<Span<felt252>> {
        self.reentrancy_guard.start();
        let exec_info = get_execution_info().unbox();
        let tx_info = exec_info.tx_info.unbox();
        assert_only_protocol(exec_info.caller_address);
        assert_correct_invoke_version(tx_info.version);
        let signature = tx_info.signature;
        if self.session.is_session(signature) {
            let session_timestamp = *signature[1];
            // can call unwrap safely as the session has already been deserialized
            let session_timestamp_u64 = session_timestamp.try_into().unwrap();
            assert(
                session_timestamp_u64 >= exec_info.block_info.unbox().block_timestamp,
                'session/expired'
            );
        }

        let retdata = execute_multicall(calls.span());

        self.emit(TransactionExecuted { hash: tx_info.transaction_hash, response: retdata.span() });
        self.reentrancy_guard.end();
        retdata
    }
    // ANCHOR_END: execute
}
