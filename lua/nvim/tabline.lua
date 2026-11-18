local M = {}

local function tab_label(tab, active)
  local win = vim.api.nvim_tabpage_get_win(tab)
  local buf = vim.api.nvim_win_get_buf(win)
  local name = vim.api.nvim_buf_get_name(buf)
  local file = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":t")
  if vim.bo[buf].buftype == "terminal" then file = "[Terminal]" end
  if vim.bo[buf].modified then file = "[+] " .. file end
  if vim.fn.strchars(file) > 20 then file = "…" .. vim.fn.strcharpart(file, vim.fn.strchars(file) - 17) end

  local icon, icon_hl = "", "TabLine"
  if file ~= "[No Name]" and file ~= "[Terminal]" then
    local ok, glyph, hl = pcall(require("mini.icons").get, "file", file)
    if ok then icon, icon_hl = glyph or "", hl or "TabLine" end
  end
  local tab_hl = active and "TabLineSel" or "TabLine"
  return "%#" .. tab_hl .. "#   " .. "%#" .. icon_hl .. "#" .. icon .. " %#" .. tab_hl .. "#" .. file .. "   %*"
end

function M.render()
  local tabs = vim.api.nvim_list_tabpages()
  if #tabs < 2 then return "" end
  local current = vim.api.nvim_get_current_tabpage()
  local items = {}
  for _, tab in ipairs(tabs) do
    items[#items + 1] = "%" .. vim.api.nvim_tabpage_get_number(tab) .. "T" .. tab_label(tab, tab == current)
  end
  return table.concat(items, " ") .. "%T"
end

vim.o.tabline = "%!v:lua.require'nvim.tabline'.render()"
return M
