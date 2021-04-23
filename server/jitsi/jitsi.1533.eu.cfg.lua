plugin_paths = { "/usr/share/jitsi-meet/prosody-plugins/" }

-- domain mapper options, must at least have domain base set to use the mapper
muc_mapper_domain_base = "jitsi.1533.eu";

external_service_secret = "NWRMnB8Jxok2xetZ";
external_services = {
     { type = "stun", host = "jitsi.1533.eu", port = 3478 },
     { type = "turn", host = "jitsi.1533.eu", port = 3478, transport = "udp", secret = true, ttl = 86400, algorithm = "turn" },
     { type = "turns", host = "jitsi.1533.eu", port = 5349, transport = "tcp", secret = true, ttl = 86400, algorithm = "turn" }
};

cross_domain_bosh = false;
consider_bosh_secure = true;
-- https_ports = { }; -- Remove this line to prevent listening on port 5284

-- https://ssl-config.mozilla.org/#server=haproxy&version=2.1&config=intermediate&openssl=1.1.0g&guideline=5.4
ssl = {
    protocol = "tlsv1_2+";
    ciphers = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
}

VirtualHost "jitsi.1533.eu"
    -- enabled = false -- Remove this line to enable this host
    authentication = "internal_hashed"
    -- Properties below are modified by jitsi-meet-tokens package config
    -- and authentication above is switched to "token"
    --app_id="example_app_id"
    --app_secret="example_app_secret"
    -- Assign this host a certificate for TLS, otherwise it would use the one
    -- set in the global section (if any).
    -- Note that old-style SSL on port 5223 only supports one certificate, and will always
    -- use the global one.
    ssl = {
        key = "/etc/prosody/certs/jitsi.1533.eu.key";
        certificate = "/etc/prosody/certs/jitsi.1533.eu.crt";
    }
    speakerstats_component = "speakerstats.jitsi.1533.eu"
    conference_duration_component = "conferenceduration.jitsi.1533.eu"
    -- we need bosh
    modules_enabled = {
        "bosh";
        "pubsub";
        "ping"; -- Enable mod_ping
        "speakerstats";
        "external_services";
        "conference_duration";
        "muc_lobby_rooms";
    }
    c2s_require_encryption = false
    lobby_muc = "lobby.jitsi.1533.eu"
    main_muc = "conference.jitsi.1533.eu"
    -- muc_lobby_whitelist = { "recorder.jitsi.1533.eu" } -- Here we can whitelist jibri to enter lobby enabled rooms

VirtualHost "guest.jitsi.1533.eu"
    authentication = "anonymous"
    c2s_require_encryption = false
    modules_enabled = {
	"bosh";
	"pubsub";
	"turncredentials";
	"muc_lobby_rooms";
    }
    main_muc = "conference.jitsi.1533.eu" 

Component "conference.jitsi.1533.eu" "muc"
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
        "muc_domain_mapper";
        --"token_verification";
    }
    admins = { "focus@auth.jitsi.1533.eu" }
    muc_room_locking = false
    muc_room_default_public_jids = true

-- internal muc component
Component "internal.auth.jitsi.1533.eu" "muc"
    storage = "memory"
    modules_enabled = {
        "ping";
    }
    admins = { "focus@auth.jitsi.1533.eu", "jvb@auth.jitsi.1533.eu" }
    muc_room_locking = false
    muc_room_default_public_jids = true

VirtualHost "auth.jitsi.1533.eu"
    ssl = {
        key = "/etc/prosody/certs/auth.jitsi.1533.eu.key";
        certificate = "/etc/prosody/certs/auth.jitsi.1533.eu.crt";
    }
    authentication = "internal_hashed"

-- Proxy to jicofo's user JID, so that it doesn't have to register as a component.
Component "focus.jitsi.1533.eu" "client_proxy"
    target_address = "focus@auth.jitsi.1533.eu"

Component "speakerstats.jitsi.1533.eu" "speakerstats_component"
    muc_component = "conference.jitsi.1533.eu"

Component "conferenceduration.jitsi.1533.eu" "conference_duration_component"
    muc_component = "conference.jitsi.1533.eu"

Component "lobby.jitsi.1533.eu" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
