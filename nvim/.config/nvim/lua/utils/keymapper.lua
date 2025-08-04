local default_opts = {
  noremap = true,
}

local map = function(mode, keymaps, command, desc, opts)
  local all_opts = opts

  if all_opts == nil then
    all_opts = {}
  end

  for k, v in pairs(default_opts) do
    all_opts[k] = all_opts[k] or v
  end

  all_opts["desc"] = desc

  vim.keymap.set(mode, keymaps, command, all_opts)
end

return { map = map }
