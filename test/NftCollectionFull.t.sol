// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/NftCollection.sol";

contract NftCollectionFullTest is Test {
    NftCollection nft;
    address owner = address(0x1);
    address alice = address(0x2);
    address bob = address(0x3);
    address operator = address(0x4);

    uint256 constant MAX_SUPPLY = 10;
    string constant BASE = "https://example.com/meta/";

    // ---------------------- Setup ----------------------
    function setUp() public {
        vm.prank(owner);
        nft = new NftCollection("TestNFT", "TNFT", MAX_SUPPLY, BASE);
    }

    // ---------------------- Minting ----------------------
    function test_owner_can_mint_and_supply_updates() public {
        vm.prank(owner);
        nft.safeMint(alice, 1);

        assertEq(nft.ownerOf(1), alice);
        assertEq(nft.balanceOf(alice), 1);
        assertEq(nft.totalSupply(), 1);
    }

    function test_non_owner_cannot_mint() public {
        vm.prank(bob);
        vm.expectRevert();
        nft.safeMint(bob, 2);
    }

    function test_cannot_mint_zero_address() public {
        vm.prank(owner);
        vm.expectRevert();
        nft.safeMint(address(0), 3);
    }

    function test_cannot_mint_duplicate_or_out_of_range() public {
        vm.prank(owner);
        nft.safeMint(alice, 4);

        vm.prank(owner);
        vm.expectRevert(); 
        nft.safeMint(bob, 4); // duplicate tokenId

        vm.prank(owner);
        vm.expectRevert(); 
        nft.safeMint(bob, 0); // invalid id = 0

        vm.prank(owner);
        vm.expectRevert(); 
        nft.safeMint(bob, MAX_SUPPLY + 1); // out of range
    }

    function test_maxSupply_enforced() public {
        vm.startPrank(owner);
        for (uint256 i = 1; i <= MAX_SUPPLY; i++) {
            nft.safeMint(owner, i);
        }
        vm.expectRevert();
        nft.safeMint(owner, 11);
        vm.stopPrank();
    }

    // ---------------------- Transfers ----------------------
    function test_owner_transfer_updates_balances() public {
        vm.prank(owner);
        nft.safeMint(alice, 5);

        vm.prank(alice);
        nft.transferFrom(alice, bob, 5);

        assertEq(nft.ownerOf(5), bob);
        assertEq(nft.balanceOf(alice), 0);
        assertEq(nft.balanceOf(bob), 1);
    }

    function test_approve_and_transfer_by_approved() public {
        vm.prank(owner);
        nft.safeMint(alice, 6);

        vm.prank(alice);
        nft.approve(bob, 6);
        assertEq(nft.getApproved(6), bob);

        vm.prank(bob);
        nft.transferFrom(alice, bob, 6);

        assertEq(nft.ownerOf(6), bob);
    }

    function test_operator_approval_transfers() public {
        vm.prank(owner);
        nft.safeMint(alice, 7);

        vm.prank(alice);
        nft.setApprovalForAll(operator, true);
        assertTrue(nft.isApprovedForAll(alice, operator));

        vm.prank(operator);
        nft.transferFrom(alice, bob, 7);

        assertEq(nft.ownerOf(7), bob);
    }

    function test_transfer_nonexistent_reverts() public {
        vm.prank(alice);
        vm.expectRevert();
        nft.transferFrom(alice, bob, 999);
    }

    // ---------------------- Metadata ----------------------
    function test_tokenURI_and_baseURI_update() public {
        vm.prank(owner);
        nft.safeMint(alice, 8);

        string memory uri = nft.tokenURI(8);
        assertEq(uri, string(abi.encodePacked(BASE, "8")));

        vm.prank(owner);
        nft.setBaseURI("https://x/");
        assertEq(nft.tokenURI(8), "https://x/8");
    }

    function test_tokenURI_nonexistent_reverts() public {
        vm.expectRevert();
        nft.tokenURI(999);
    }

    // ---------------------- Pausing ----------------------
    function test_pause_prevents_mint_and_transfer() public {
        vm.prank(owner);
        nft.pause();

        vm.prank(owner);
        vm.expectRevert();
        nft.safeMint(alice, 9);

        vm.prank(owner);
        nft.unpause();

        vm.prank(owner);
        nft.safeMint(alice, 9);

        vm.prank(owner);
        nft.pause();

        vm.prank(alice);
        vm.expectRevert();
        nft.transferFrom(alice, bob, 9);

        vm.prank(owner);
        nft.unpause();
    }

    // ---------------------- Burning ----------------------
    function test_burn_updates_supply_and_balance() public {
        vm.prank(owner);
        nft.safeMint(alice, 10);

        vm.prank(alice);
        nft.burn(10);

        vm.expectRevert();
        nft.ownerOf(10);

        assertEq(nft.totalSupply(), 0);
        assertEq(nft.balanceOf(alice), 0);
    }

    // ---------------------- Invalid cases ----------------------
    function test_balanceOf_zero_address_reverts() public {
        vm.expectRevert();
        nft.balanceOf(address(0));
    }

    // ---------------------- Gas Bound Test ----------------------
    function test_gas_mint_and_transfer_are_reasonable() public {
        vm.prank(owner);
        uint256 g1 = gasleft();
        nft.safeMint(alice, 1);
        uint256 mintGas = g1 - gasleft();

        vm.prank(alice);
        uint256 g2 = gasleft();
        nft.transferFrom(alice, bob, 1);
        uint256 transferGas = g2 - gasleft();

        assertLt(mintGas, 500_000);
        assertLt(transferGas, 200_000);
    }
}



