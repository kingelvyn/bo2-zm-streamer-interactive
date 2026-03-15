#include scripts\zm\streamer_mod\streamer_debug;

// ---------------------------------------------------------------------------
// POOL HELPERS
// ---------------------------------------------------------------------------

streamer_get_current_map()
{
    map = getdvar("mapname");

    if ( isDefined( level.script ) )
    {
        streamer_debug_print( "Map detected: " + map );
        return map;
    }
    streamer_debug_print ( "Map detection FAILED!" );
    return "";
}

streamer_add_weapon_to_pool( weap )
{
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = weap;
}

streamer_add_perk_to_pool( perk )
{
    level.streamer_perk_pool[level.streamer_perk_pool.size] = perk;
}