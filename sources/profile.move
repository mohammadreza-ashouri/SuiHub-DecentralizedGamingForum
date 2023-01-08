
module suihub::profile {
    use std::bcs;
    use std::hash::sha3_256;
    use std::vector;

    use sui::dynamic_object_field as dof;
    use sui::ed25519::ed25519_verify;
    use sui::object::{Self, ID, UID};
    use sui::object_table::{Self, ObjectTable};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::url::{Self, Url};


    const INIT_CAPTCHA_PUBLIC_KEY: vector<u8> = x"";

    // TODO: replace real urls
    const URL_GLOABL: vector<u8> = b"ipfs://";
    const URL_PROFILE: vector<u8> = b"ipfs://";

    const ERR_NO_PERMISSIONS: u64 = 1;
    const ERR_INVALID_CAPTCHA: u64 = 2;

    struct WrapperProfile has key, store {
        id: UID,
        profile: vector<u8>,
        owner: address,
        url: Url
    }

    struct Global has key {
        id: UID,
        creator: address,
        captcha_public_key: vector<u8>,
        profiles: ObjectTable<address, WrapperProfile>,
        url: Url
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            Global {
                id: object::new(ctx),
                creator: tx_context::sender(ctx),
                captcha_public_key: INIT_CAPTCHA_PUBLIC_KEY,
                profiles: object_table::new<address, WrapperProfile>(ctx),
                url: url::new_unsafe_from_bytes(URL_GLOABL)
            }
        )
    }


}
