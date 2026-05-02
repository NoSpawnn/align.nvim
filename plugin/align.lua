local function align_selection_by_str(args)
    local line_start = args.line1 - 1
    local line_end = args.line2

    if (line_start + 1) == line_end then
        print("No selection, nothing to align")
        return
    end

    local match_target = args.fargs[1]
    local furthest_right = -1
    local align_match_idxs = {}
    local lines = vim.api.nvim_buf_get_lines(0, line_start, line_end, false)

    for i, line in ipairs(lines) do
        local pos = string.find(line, match_target)
        if pos then
            align_match_idxs[i] = pos
            if pos > furthest_right then
                furthest_right = pos
            end
        end
    end

    for line_idx, align_match_idx in pairs(align_match_idxs) do
        local chars_to_insert = furthest_right - align_match_idx
        local line = lines[line_idx]
        lines[line_idx] =
            string.sub(line, 0, align_match_idx - 1)
            .. string.rep(" ", chars_to_insert)
            .. string.sub(line, align_match_idx)
    end

    vim.api.nvim_buf_set_lines(0, line_start, line_end, false, lines)
end

vim.api.nvim_create_user_command(
    "Align",
    align_selection_by_str,
    { desc = "Align selection based on string argument", range = true, nargs = 1 }
)
