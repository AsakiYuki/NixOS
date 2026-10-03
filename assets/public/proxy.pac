function match(host, domain) {
	return shExpMatch(host, domain) || shExpMatch(host, `*.${domain}`)
}

function FindProxyForURL(url, host) {
	if (
		match(host, "steampowered.com") ||
		match(host, "steamcommunity.com") ||
		match(host, "steamgames.com") ||
		match(host, "steam-chat.com") ||
		match(host, "microsoft.com") ||
		match(host, "visualstudio.com") ||
		match(host, "sourceforge.net") ||
		match(host, "yandex.ru")
	) {
		return "SOCKS5 192.168.1.100:10808; SOCKS5 100.66.141.14:10808; DIRECT"
	} else if (match(host, "whatismyip.com")) {
		return "SOCK5 101.36.104.239:10808; DIRECT"
	}

	return "DIRECT"
}
