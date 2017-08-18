#include <amxmodx>
#include <ColorChat>

#define PLUGIN "FakeIP"
#define VERSION "1.0"
#define AUTHOR "RevCrew"

const MAX_IP_FAKES = 4
const TIME = 1440
const IP_SIZE = 18 // Lyshe bol'she 4em men'she

new const PREFIX[] = "FakeIP"

new Trie:g_trie;

#define LOG_FILE "addons/amxmodx/logs/FakeIP.log"

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    g_trie = TrieCreate();
}
public plugin_end()
    TrieDestroy(g_trie);

public client_connect(id)
{
    static ip[IP_SIZE]; get_user_ip(id, ip, sizeof(ip) - 1, .without_port=1)

    new cell = 1;
    if(TrieGetCell(g_trie, ip, cell))
    {
        if(++cell > MAX_IP_FAKES)
        {
            client_print_color(0, RED, "^1[^3%s^1] IP [^3%s^1] banned for [^3%d^1] | Reason: [^4Limit IP Reached^1]",PREFIX, ip, TIME)
            log_to_file(LOG_FILE,"[%s] IP %s banned for %d.",PREFIX, ip, TIME)
            server_cmd("addip %d %s; wait;wait; writeip",TIME, ip)
            return;
        }
    }
    TrieSetCell(g_trie, ip, cell);
}

public client_disconnect(id)
{
    static ip[IP_SIZE]; get_user_ip(id, ip, sizeof(ip) - 1, .without_port=1);
    static cell
    if(TrieGetCell(g_trie, ip, cell))
    {
        if(--cell > 0)
        {
            TrieSetCell(g_trie, ip, cell);
        }
        else
        {
            TrieDeleteKey(g_trie, ip);
        }
    }
}

