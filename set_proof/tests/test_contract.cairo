// use starknet::ContractAddress;
// use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
// use core::array::ArrayTrait;
// use core::traits::Into;
// use core::result::ResultTrait;

// use set_proof::ISetProofDispatcher;
// use set_proof::ISetProofDispatcherTrait;
// use set_proof::ISetProofSafeDispatcher;
// use set_proof::ISetProofSafeDispatcherTrait;

// // Helper function to deploy the contract with initial values
// fn deploy_contract(initial_elements: Array<felt252>) -> ContractAddress {
//     let contract = declare("SetProof").unwrap().contract_class();
//     let mut calldata = ArrayTrait::new();
    
//     // Add array length to calldata
//     calldata.append(initial_elements.len().into());
    
//     // Add each element to calldata
//     let mut i: u32 = 0;
//     let elements_len = initial_elements.len();
//     while i != elements_len {
//         calldata.append(*initial_elements.at(i));
//         i += 1;
//     }
    
//     let (contract_address, _) = contract.deploy(@calldata).unwrap();
//     contract_address
// }

// // Test adding elements to the set
// #[test]
// fn test_add_element() {
//     // Deploy with no initial elements
//     let mut initial_elements = ArrayTrait::new();
//     let contract_address = deploy_contract(initial_elements);
    
//     let dispatcher = ISetProofDispatcher { contract_address };
    
//     // Add an element
//     let element: felt252 = 42;
//     let result = dispatcher.add_element(element);
    
//     // Verify element was added
//     assert(result == true, 'Add element should return true');
//     assert(dispatcher.is_member(element) == true, 'Element should be member');
//     assert(dispatcher.get_set_size() == 1, 'Set size should be 1');
    
//     // Get all elements and verify
//     let elements = dispatcher.get_all_elements();
//     assert(elements.len() == 1, 'Should have 1 element');
//     assert(*elements.at(0) == element, 'First element should match');
// }

// // Test removing elements from the set
// #[test]
// fn test_remove_element() {
//     // Deploy with one initial element
//     let mut initial_elements = ArrayTrait::new();
//     let element: felt252 = 42;
//     initial_elements.append(element);
    
//     let contract_address = deploy_contract(initial_elements);
//     let dispatcher = ISetProofDispatcher { contract_address };
    
//     // Verify initial state
//     assert(dispatcher.is_member(element) == true, 'Element should be member');
//     assert(dispatcher.get_set_size() == 1, 'Set size should be 1');
    
//     // Remove the element
//     let result = dispatcher.remove_element(element);
    
//     // Verify element was removed
//     assert(result == true, 'Remove should return true');
//     assert(dispatcher.is_member(element) == false, 'Element should not be member');
//     assert(dispatcher.get_set_size() == 0, 'Set size should be 0');
    
//     // Try to remove again (should fail)
//     let result = dispatcher.remove_element(element);
//     assert(result == false, 'Remove non-existent should fail');
// }

// // Test verifying membership with proof
// #[test]
// fn test_verify_membership() {
//     // Deploy with one initial element
//     let mut initial_elements = ArrayTrait::new();
//     let element: felt252 = 42;
//     initial_elements.append(element);
    
//     let contract_address = deploy_contract(initial_elements);
//     let dispatcher = ISetProofDispatcher { contract_address };
    
//     // Verify membership of existing element
//     let (is_member, hash) = dispatcher.verify_membership(element);
//     assert(is_member == true, 'Should be a member');
//     assert(hash != 0, 'Hash should not be zero');
    
//     // Verify non-membership
//     let non_member: felt252 = 100;
//     let (is_member, hash) = dispatcher.verify_membership(non_member);
//     assert(is_member == false, 'Should not be a member');
//     assert(hash != 0, 'Hash should not be zero');
// }

// // Test getting all elements
// #[test]
// fn test_get_all_elements() {
//     // Deploy with multiple initial elements
//     let mut initial_elements = ArrayTrait::new();
//     initial_elements.append(10);
//     initial_elements.append(20);
//     initial_elements.append(30);
    
//     let contract_address = deploy_contract(initial_elements);
//     let dispatcher = ISetProofDispatcher { contract_address };
    
//     // Get all elements
//     let elements = dispatcher.get_all_elements();
    
//     // Verify elements
//     assert(elements.len() == 3, 'Should have 3 elements');
//     assert(*elements.at(0) == 10, 'First element should be 10');
//     assert(*elements.at(1) == 20, 'Second element should be 20');
//     assert(*elements.at(2) == 30, 'Third element should be 30');
// }

// // Test authorization for add_element
// #[test]
// #[feature("safe_dispatcher")]
// fn test_unauthorized_add_element() {
//     // Deploy contract with changer account
//     let mut initial_elements = ArrayTrait::new();
//     let contract_address = deploy_contract(initial_elements);
    
//     // Create safe dispatcher from different account
//     let safe_dispatcher = ISetProofSafeDispatcher { contract_address };
    
//     // Try to add element with different account (should fail)
//     match safe_dispatcher.add_element(42) {
//         Result::Ok(_) => core::panic_with_felt252('Should have failed authorization'),
//         Result::Err(panic_data) => {
//             assert(*panic_data.at(0) == 'NotAuthorized', 'Wrong error message');
//         }
//     };
// }

// // Test adding duplicates
// #[test]
// fn test_add_duplicate_element() {
//     let mut initial_elements = ArrayTrait::new();
//     let element: felt252 = 42;
//     initial_elements.append(element);
    
//     let contract_address = deploy_contract(initial_elements);
//     let dispatcher = ISetProofDispatcher { contract_address };
    
//     // Try to add the same element again
//     let result = dispatcher.add_element(element);
    
//     // Should return false since element already exists
//     assert(result == false, 'Adding duplicate should fail');
//     assert(dispatcher.get_set_size() == 1, 'Size should still be 1');
// }

// // Test getting set size
// #[test]
// fn test_get_set_size() {
//     let mut initial_elements = ArrayTrait::new();
//     initial_elements.append(10);
//     initial_elements.append(20);
    
//     let contract_address = deploy_contract(initial_elements);
//     let dispatcher = ISetProofDispatcher { contract_address };
    
//     // Check initial size
//     assert(dispatcher.get_set_size() == 2, 'Initial size should be 2');
    
//     // Add an element and check size again
//     let _ = dispatcher.add_element(30);
//     assert(dispatcher.get_set_size() == 3, 'Size should be 3 after add');
    
//     // Remove an element and check size
//     let _ = dispatcher.remove_element(20);
//     assert(dispatcher.get_set_size() == 2, 'Size should be 2 after remove');
// }

// // Test is_member function
// #[test]
// fn test_is_member() {
//     let mut initial_elements = ArrayTrait::new();
//     initial_elements.append(10);
    
//     let contract_address = deploy_contract(initial_elements);
//     let dispatcher = ISetProofDispatcher { contract_address };
    
//     // Check existing member
//     assert(dispatcher.is_member(10) == true, 'Should be a member');
    
//     // Check non-member
//     assert(dispatcher.is_member(20) == false, 'Should not be a member');
// }