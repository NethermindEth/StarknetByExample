#[cfg(test)]
mod tests {
    use super::*;
    use starknet::testing::{start_block, get_block_timestamp};
    use starknet::ContractAddress;
    use core::num::traits::Zero;
    use erc20_streaming::{Stream, Storage, Errors};

    #[test]
    fn test_create_stream() {
        let erc20_token = ContractAddress::new(1); // Mock ERC20 token address
        let mut contract = erc20_streaming::ContractState::new(erc20_token);

        let to = ContractAddress::new(2);
        let total_amount = felt252::from(1000);
        let start_time = get_block_timestamp();
        let end_time = start_time + 3600; // 1 hour later
        contract.create_stream(to, total_amount, start_time, end_time);

        // Assert
        let stream = contract.streams.read(1); // Stream ID should start from 1
        assert_eq!(stream.from, get_caller_address());
        assert_eq!(stream.to, to);
        assert_eq!(stream.total_amount, total_amount);
        assert_eq!(stream.released_amount, felt252::zero());
        assert_eq!(stream.start_time, start_time);
        assert_eq!(stream.end_time, end_time);

        // Check if the next stream ID is incremented
        assert_eq!(contract.next_stream_id.read(), 2);
    }

    #[test]
    fn test_release_tokens() {
        let erc20_token = ContractAddress::new(1);
        let mut contract = erc20_streaming::ContractState::new(erc20_token);

        // Create a stream
        let to = ContractAddress::new(2);
        let total_amount = felt252::from(1000);
        let start_time = get_block_timestamp();
        let end_time = start_time + 3600;
        contract.create_stream(to, total_amount, start_time, end_time);

        start_block(start_time + 1800); // 30 minutes later

      
        contract.release_tokens(1); // Release tokens for stream ID 1

        // Assert
        let stream = contract.streams.read(1);
        let expected_released_amount = felt252::from(500); // Half of the total amount should be released
        assert_eq!(stream.released_amount, expected_released_amount);
    }
}
