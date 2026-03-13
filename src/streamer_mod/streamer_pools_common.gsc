streamer_get_current_map()
{
    map = getdvar("mapname");

    if ( isDefined( level.script ) )
    {
        iprintln( "Map detected: " + map );
        return map;
    }
    iprintln ( "Map detection FAILED!" );
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