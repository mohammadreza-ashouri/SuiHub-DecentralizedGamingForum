
module suihub::profile {

    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::url::{Self, Url};
    use sui::dynamic_object_field as dof;
    use sui::object_table::{Self, ObjectTable};
    use sui::ed25519::ed25519_verify;
    use suihub::suihub::{suihub_meta, truncate_all, suihubMeta};
    use sui::object::{Self, ID, UID};
     
    use std::debug;
    use std::bcs;
    use std::hash::sha3_256;
    use std::vector;

    const INIT_CAPTCHA_PUBLIC_KEY: vector<u8> = x"";
    const URL_GLOABL: vector<u8> = b"ipfs://";
    const URL_PROFILE: vector<u8> = b"ipfs://";
    const ERR_NO_PERMISSIONS: u64 = 1;
    const ERR_INVALID_CAPTCHA: u64 = 2;

    struct _Profile has key, store {
        id: UID,
        profile: vector<u8>,
        owner: address,
        url: Url
    }

    struct Pblic has key {
        id: UID,
        creator: address,
        captcha_public_key: vector<u8>,
        profiles: ObjectTable<address, WrapperProfile>,
        url: Url
    }

    fun init(contx: &mut TxContext) {
        transfer::share_object(
            Pblic {
                id: object::new(contx),
                creator: tx_context::sender(contx),
                captcha_public_key: INIT_CAPTCHA_PUBLIC_KEY,
                profiles: object_table::new<address, WrapperProfile>(contx),
                url: url::new_unsafe_from_bytes(URL_GLOABL)
            }
        )
    }
   
    public entry fun truncate(
        gbl: &mut Pblic,
        meta: suihubMeta,
        contx: &mut TxContext
    ) {
        let wrapper_profile = object_table::remove(
            &mut gbl.profiles,
            tx_context::sender(contx)
        );

        let WrapperProfile { id, profile: _profile, url: _url, owner: _owner } = wrapper_profile;
        object::delete(id);
        truncate_all(meta)
    }
 


    /// Removing items from the profile.
    public entry fun delete_item<T: key + store>(
        gbl: &mut Pblic,
        itm_id: ID,
        contx: &mut TxContext
    ) {
        let usr = tx_context::sender(contx);
        let mut_profile = object_table::borrow_mut(&mut gbl.profiles, usr);

        transfer::transfer(
            dof::remove<ID, T>(&mut mut_profile.id, itm_id),
            tx_context::sender(contx)
        );
    }

        public entry fun attach_item<T: key + store>(
        gbl: &mut Pblic,
        itm: T,
        contx: &mut TxContext
    ) {
        let usr = tx_context::sender(contx);
        let mut_profile = object_table::borrow_mut(&mut gbl.profiles, usr);
        dof::add(&mut mut_profile.id, object::id(&itm), itm);
    }





}
