#[starknet::interface]
pub trait ISetProof<TContractState> {
    fn add_element(ref self: TContractState, element: felt252) -> bool;
    fn remove_element(ref self: TContractState, element: felt252) -> bool;
    fn verify_membership(ref self: TContractState, element: felt252) -> (bool, felt252);
    fn get_all_elements(self: @TContractState) -> Array<felt252>;
    fn is_member(self: @TContractState, element: felt252) -> bool;
    fn get_set_size(self: @TContractState) -> u32;
}


#[starknet::contract]
mod SetProof {
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{ContractAddress, get_caller_address};

    use core::traits::Into;
    use core::array::ArrayTrait;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::{poseidon::PoseidonTrait};

    // Storage variables
    #[storage]
    struct Storage {
        // Mapping from element hash to boolean indicating membership
        set_elements: Map<felt252, bool>,
        // Owner of the contract who can modify the set
        owner: ContractAddress,
        // Array to store all elements for iteration purposes
        all_elements: Map<u32, felt252>,
        // Size of the set
        set_size: u32,
    }

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        ElementAdded: ElementAdded,
        ElementRemoved: ElementRemoved,
        MembershipVerified: MembershipVerified,
    }

    // Event emitted when a new element is added to the set
    #[derive(Drop, starknet::Event)]
    struct ElementAdded {
        element: felt252
    }

    // Event emitted when an element is removed from the set
    #[derive(Drop, starknet::Event)]
    struct ElementRemoved {
        element: felt252
    }

    // Event emitted when membership is verified
    #[derive(Drop, starknet::Event)]
    struct MembershipVerified {
        element: felt252,
        is_member: bool,
        poseidon_hash: felt252
    }

    // Constructor to initialize the contract with a set of elements
    #[constructor]
    fn constructor(ref self: ContractState, initial_elements: Array<felt252>) {
        let caller = get_caller_address();
        self.owner.write(caller);
        
        // Initialize set with initial elements
        let mut size: u32 = 0;
        let mut i: u32 = 0;
       
        let elements_len = initial_elements.len();
        while i != elements_len + 1 {
            let element = *initial_elements.at(i);
            if !self.set_elements.read(element) {
                self.set_elements.write(element, true);

                self.all_elements.write(size, element);
                size += 1;
                self.emit(ElementAdded { element });
            }
            
            i += 1;
        }
        
        self.set_size.write(size);
    }

    #[abi(embed_v0)]
    impl SetProofImpl of super::ISetProof<ContractState> {

        // Add an element to the set (only owner)
        fn add_element(ref self: ContractState, element: felt252) -> bool {
            // Check if caller is owner
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'NotAuthorized');
            
            // Check if element already exists
            let exists = self.set_elements.read(element);
            if !exists {
                return false;
            }
            
            // Add element to set
            let size = self.set_size.read();
            self.set_elements.write(element, true);
            self.all_elements.write(size, element);
            self.set_size.write(size + 1);
            
            // Emit event
            self.emit(ElementAdded { element });
            
            true
        }
        
        // Remove an element from the set (only owner)
        fn remove_element(ref self: ContractState, element: felt252) -> bool {
            // Check if caller is owner
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'NotAuthorized');
            
            // Check if element exists
            let exists = self.set_elements.read(element);
            if !exists {
                return false;
            }
            
            // Remove element from set
            self.set_elements.write(element, false);
            
            // Find and replace element in array (with last element for simplicity)
            let mut size = self.set_size.read();
            let mut i: u32 = 0;
        
                while i != size + 1 {
                    if self.all_elements.read(i) == element {
                        // Replace with last element if not the last
                        if i < size - 1 {
                            let last_element = self.all_elements.read(size - 1);
                            self.all_elements.write(i, last_element);
                        }
                        size -= 1;
                        self.set_size.write(size);
                        break;
                    }
                    
                    i += 1;
                }
            
            // Emit event
            self.emit(ElementRemoved { element });
            
            true
        }
        
        // Verify if an element is in the set and generate proof using poseidon
        fn verify_membership(ref self: ContractState, element: felt252) -> (bool, felt252) {
            // Check if element exists in set
            let is_member = self.set_elements.read(element);
        
            let poseidon_hash = PoseidonTrait::new().update_with(element).finalize();
            
            // Emit event with verification result
            self.emit(MembershipVerified { element, is_member, poseidon_hash });
            
            (is_member, poseidon_hash)
        }
        
        // Get all elements in the set
        fn get_all_elements(self: @ContractState) -> Array<felt252> {
              // Check if caller is owner
              let caller = get_caller_address();
              assert(caller == self.owner.read(), 'NotAuthorized');

            let size = self.set_size.read();
            let mut elements = ArrayTrait::new();
            let mut i: u32 = 0;
            
                while i != size + 1 {
                    let element = self.all_elements.read(i);
                    if self.set_elements.read(element) {
                        elements.append(element);
                    }
                    
                    i += 1;
                }            
            
            elements
        }
        
        // Check if an element is in the set (view function)
        fn is_member(self: @ContractState, element: felt252) -> bool {
            self.set_elements.read(element)
        }
        
        // Get the size of the set
        fn get_set_size(self: @ContractState) -> u32 {
            self.set_size.read()
        }
    }
}

