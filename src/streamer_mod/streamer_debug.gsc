streamer_debug_print( msg )
{
    if ( isDefined( level.streamer_debug ) && level.streamer_debug )
        iprintln( "^1[11 MOD] ^3" + msg );
}