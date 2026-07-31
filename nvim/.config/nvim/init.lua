local NVIM_CONF = os.getenv("NVIM_CONFIG_TYPE")
_G.USE_MINIMAL = true

if NVIM_CONF == "full" then
	_G.USE_MINIMAL = false
end

require("core")
require("lsp")
