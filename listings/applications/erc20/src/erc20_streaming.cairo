#[starknet::contract]

pub mod erc20_streaming {

    // Import necessary modules and traits
    use core::num::traits::Zero;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use starknet::LegacyMap;

    #[storage]
    struct Storage {
        streams: LegacyMap<u64, Stream>,
        next_stream_id: u64,  
       
    }

    #[derive(Copy, Drop, Debug, PartialEq)]
    struct Stream {
        from: ContractAddress,
        start_time: u64,
        end_time: u64,
        total_amount: felt252,
        released_amount: felt252,
        to: ContractAddress,
        erc20_token: ContractAddress,
    }

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        StreamCreated: StreamCreated,
        TokensReleased: TokensReleased,
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct StreamCreated {
        pub from: ContractAddress,
        pub to: ContractAddress,
        pub total_amount: felt252,
        pub start_time: u64,
        pub end_time: u64,
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct TokensReleased {
        pub to: ContractAddress,
        pub amount: felt252,
    }

    mod Errors {
        pub const STREAM_AMOUNT_ZERO: felt252 = 'Stream amount cannot be zero';
        pub const STREAM_ALREADY_EXISTS: felt252 = 'Stream already exists';
        pub const END_TIME_INVALID: felt252 = 'End time must be greater than start time';
        pub const START_TIME_INVALID: felt252 = 'Start time must be greater than or equal to the current block timestamp';'';
        pub const STREAM_UNAUTHORIZED: felt252 = 'Caller is not the recipient of the stream';
    }

    #[constructor]
    fn constructor(ref self: ContractState, erc20_token: ContractAddress) {
        self.erc20_token.write(erc20_token);
        self.next_stream_id.write(1);
    }

    #[abi(embed_v0)]
    impl IStreamImpl of super::IStream<ContractState> {
        fn create_stream(
            ref self: ContractState,
            to: ContractAddress,
            total_amount: felt252,
            start_time: u64,
            end_time: u64
        ) {
            assert(total_amount != felt252::zero(), Errors::STREAM_AMOUNT_ZERO);
            let caller = get_caller_address();
            let start_time = get_block_timestamp(); // Use block timestamp for start time
            assert(end_time > start_time, Errors::END_TIME_INVALID); // Assert end_time > start_time
            assert(start_time >= get_block_timestamp(), Errors::START_TIME_INVALID);

            let stream_key = self.next_stream_id;
            self.next_stream_id.write(stream_key + 1);
           
            // Call the ERC20 contract to transfer tokens
            let erc20 = self.erc20_token.read();
            erc20.call("transfer_from", (caller, self.contract_address(), total_amount));

            let stream = Stream {
                from: caller;
                to,
                start_time,
                end_time,
                total_amount,
                released_amount: felt252::zero(),
            };
            self.streams.write(stream_id, stream);

            self.emit(StreamCreated { stream_id, from: caller, to, total_amount, start_time, end_time });
        }
        self.next_stream_id.write(stream_id + 1); // Increment the stream ID counter
    }

        fn release_tokens(ref self: ContractState, stream_id: u64) {
            let caller = get_caller_address();
            let stream = self.streams.read(stream_id);
            assert(caller == stream.to, Errors::STREAM_UNAUTHORIZED);

            let releasable_amount = self.releasable_amount(stream);
            assert(
                releasable_amount <= (stream.total_amount - stream.released_amount),
                "Releasable amount exceeds remaining tokens"
            );

            self.streams.write(
                stream_id,
                Stream {
                    released_amount: stream.released_amount + releasable_amount,
                    ..stream
                }
            );

            // Call the ERC20 contract to transfer tokens
            let erc20 = self.erc20_token.read();
            erc20.call("transfer", (stream.to, releasable_amount));

            self.emit(TokensReleased { to, amount: releasable_amount });
        }

        fn releasable_amount(&self, stream: Stream) -> felt252 {
                let current_time = starknet::get_block_timestamp();
                let time_elapsed = current_time - stream.start_time;
                let vesting_duration = stream.end_time - stream.start_time;

                let vested_amount = stream.total_amount * min(time_elapsed, vesting_duration) / vesting_duration;;
                vested_amount - stream.released_amount;
            }
        }

