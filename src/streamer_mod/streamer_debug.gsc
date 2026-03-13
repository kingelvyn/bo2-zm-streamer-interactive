streamer_debug_print( msg )
{
    if ( isDefined( level.streamer_debug ) && level.streamer_debug )
        iprintln( "^2[11 MOD] ^5" + msg );
}