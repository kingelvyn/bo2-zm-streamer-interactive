// POWERUPS (MAX AMMO / INSTA KILL / FIRE SALE) ------------------------------

streamer_reward_powerup( player, powerupType )
{
    if ( !isDefined ( player ) )
        return false;

    if ( !isDefined( powerupType ) )
        return false;

    forward = anglesToForward ( player.angles );
    org = player.origin + ( forward * 30 );
    org[2] = org[2] + 20;

    end = org;
    end[2] = end[2] - 100;

    trace = bulletTrace ( org, end, false, player );
    origin = trace["position"];
    origin[2] = origin[2] + 4;

    // Names: full_ammo (max ammo), insta_kill, fire_sale, double_points, nuke, carpenter, etc.
    level.powerup_drop_count = 0;

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
        default:
            return false;
    }

    if ( isDefined( powerup ) )
    {
        powerup thread maps\mp\zombies\_zm_powerups::powerup_timeout();
        return true;
    }

    return false;
}