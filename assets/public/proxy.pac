function FindProxyForURL(url, host) {
	if (
		shExpMatch(host, "*.steampowered.com") ||
		shExpMatch(host, "steampowered.com") ||
		shExpMatch(host, "*.steamcommunity.com") ||
		shExpMatch(host, "steamcommunity.com") ||
		shExpMatch(host, "*.steamgames.com") ||
		shExpMatch(host, "steamgames.com") ||
		shExpMatch(host, "*.steam-chat.com") ||
		shExpMatch(host, "steam-chat.com")
	) {
		return "SOCKS5 192.168.1.100:10808; SOCKS5 100.66.141.14:10808; DIRECT"
	}

	return "DIRECT"
}
