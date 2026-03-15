#include scripts\zm\streamer_mod\streamer_debug;

// ---------------------------------------------------------------------------
// POWERUPS
// ---------------------------------------------------------------------------
streamer_reward_powerup( player, powerupType )
{
    if ( !isDefined ( player ) )
        return false;

    if ( !isDefined( powerupType ) )
    {
        streamer_debug_print ( "Powerup failed: Type undefined" );
        return false;
    }

    // Positioning onto player
    forward = anglesToForward ( player.angles );
    org = player.origin + ( forward * 30 );
    org[2] = org[2] + 20;

    end = org;
    end[2] = end[2] - 100;

    trace = bulletTrace ( org, end, false, player );
    origin = trace["position"];
    origin[2] = origin[2] + 4;

    // Names: full_ammo (max ammo), insta_kill, fire_sale, double_points, nuke, carpenter, etc.

    switch ( powerupType )
    {
        case "ammo":
            powerup = level maps\mp\zombies\_zm_powerups::specific_powerup_drop( "full_ammo", origin );
            break;
        case "insta_kill":
            powerup = level maps\mp\zombies\_zm_powerups::specific_powerup_drop( "insta_kill", origin );
            break;
        case "fire_sale":
            powerup = level maps\mp\zombies\_zm_powerups::specific_powerup_drop( "fire_sale", origin );
            break;
        case "nuke":
            powerup = level maps\mp\zombies\_zm_powerups::specific_powerup_drop( "nuke", origin );
            break;
        case "carpenter":
            powerup = level maps\mp\zombies\_zm_powerups::specific_powerup_drop( "carpenter", origin );
            break;
        case "double_points":
            powerup = level maps\mp\zombies\_zm_powerups::specific_powerup_drop( "double_points", origin );
            break;

        default:
            streamer_debug_print ( "Power up failed" );
            return false;
    }

    if ( isDefined( powerup ) )
    {
        player.ignore_range_powerup = powerup;
        return true;
    }

    return false;
}