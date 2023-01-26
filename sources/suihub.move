module suihub::profile {


    use std::option::{Self, Option, some, none};
    use std::string::{Self, String};
    use std::vector::{Self, length};

    friend suihub::profile;

 
    const ADDRESS_QUOTE_POST: vector<u8> = b"ipfs://";
    const ADDRESS_POST: vector<u8> = b"ipfs://";
    const ADDRESS_REPOST: vector<u8> = b"ipfs://";
    const ADDRESS_REPLY: vector<u8> = b"ipfs://";
    const ADDRESS_LIKE: vector<u8> = b"ipfs://";
    const ADDRESS_META: vector<u8> = b"ipfs://";
    const ERR_POST_OVERFLOW: u64 = 1;
    const ERR_REQUIRE_REF_ID: u64 = 2;
    const ERR_UNEXPECTED_ACTION: u64 = 3;
    const ERR_INVALID_ACTION: u64 = 4;
    const _REPLY: u8 = 3;
    const _LIKE: u8 = 4;
    const _POST: u8 = 0;
    const _REPOST: u8 = 1;
    const _QUOTE_POST: u8 = 2;
    const MAX_POST_LENGTH: u64 = 20000;
    const APP_ID_FOR_COMINGCHAT_APP: u8 = 0;
    const APP_ID_FOR_COMINGCHAT_WEB: u8 = 1;

// We consider posts as NFTs
    struct suihub has key, store {
        id: UID,
        app_id: u8,
        poster: address,
        text: Option<String>,
        ref_id: Option<address>,
        action: u8,
        url: Url
    }

    ///  configs for user
    struct suihubMeta has key {
        id: UID,
        next_index: u64,
        follows: Table<address, address>,
        suihub_table: Table<u64, suihub>,
        url: Url
    }

    struct LikePost has key {
        id: UID,
        poster: address
    }

    struct RePost has key {
        id: UID,
        poster: address
    }


    public(friend) fun suihub_meta(
        ctx: &mut TxContext,
    ) {
        transfer::transfer(
            suihubMeta {
                id: object::new(ctx),
                next_index: 0,
                follows: table::new<address, address>(ctx),
                suihub_table: table::new<u64, suihub>(ctx),
                url: url::new_unsafe_from_bytes(URL_META)
            },
            tx_context::sender(ctx)
        )
    }

    public(friend) fun truncate_all(
        meta: suihubMeta,
    ) {
        let next_index = meta.next_index;
        batch_burn_range(&mut meta, 0, next_index);

        let suihubMeta { id, next_index: _, suihub_table, follows, url: _ } = meta;

        // suihub no drop ability, so use truncate_empty
        table::truncate_empty(suihub_table);
        table::drop(follows);
        object::delete(id);
    }


    fun submit_internally(
        meta: &mut suihubMeta,
        app_id: u8,
        text: vector<u8>,
        ctx: &mut TxContext,
    ) {
        assert!(length(&text) <= MAX_TEXT_LENGTH, ERR_TEXT_OVERFLOW);

        let suihub = suihub {
            id: object::new(ctx),
            app_id,
            poster: tx_context::sender(ctx),
            text: some(string::utf8(text)),
            ref_id: none(),
            action: ACTION_POST,
            url: url::new_unsafe_from_bytes(URL_POST)
        };

        table::add(&mut meta.suihub_table, meta.next_index, suihub);
        meta.next_index = meta.next_index + 1
    }

}
