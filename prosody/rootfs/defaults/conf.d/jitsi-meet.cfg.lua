admins = { "{{ .Env.JICOFO_AUTH_USER }}@{{ .Env.XMPP_AUTH_DOMAIN }}" }

VirtualHost "{{ .Env.XMPP_DOMAIN }}"
        authentication = "anonymous"
        ssl = {
                key = "/config/certs/{{ .Env.XMPP_DOMAIN }}.key";
                certificate = "/config/certs/{{ .Env.XMPP_DOMAIN }}.crt";
        }
        modules_enabled = {
            "bosh";
            "pubsub";
            "ping";
        }

        c2s_require_encryption = false

VirtualHost "{{ .Env.XMPP_AUTH_DOMAIN }}"
    ssl = {
        key = "/config/certs/{{ .Env.XMPP_AUTH_DOMAIN }}.key";
        certificate = "/config/certs/{{ .Env.XMPP_AUTH_DOMAIN }}.crt";
    }
    authentication = "internal_plain"

Component "{{ .Env.XMPP_MUC_DOMAIN }}" "muc"
    storage = "none"

Component "jitsi-videobridge.{{ .Env.XMPP_DOMAIN }}"
    component_secret = "{{ .Env.JVB_COMPONENT_SECRET }}"

Component "focus.{{ .Env.XMPP_DOMAIN }}"
    component_secret = "{{ .Env.JICOFO_COMPONENT_SECRET }}"

