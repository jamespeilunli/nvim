return {
  "xeluxee/competitest.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  config = function()
    local function slugify(s)
      s = (s or ""):lower()
      s = s:gsub("[^%w]+", "_")
      s = s:gsub("^_+", ""):gsub("_+$", "")
      if s == "" then
        s = "problem"
      end
      return s
    end

    local root = vim.fn.expand("~") .. "/programming/competitive"

    local function parse_group(group)
      -- competitive-companion usually sets: "JUDGE - CONTEST"
      local judge, contest = "unknown_judge", "unknown_contest"
      group = group or ""
      local hyphen = group:find(" %- ")
      if hyphen then
        judge = group:sub(1, hyphen - 1)
        contest = group:sub(hyphen + 3)
      elseif group ~= "" then
        judge = group
      end
      return slugify(judge), slugify(contest)
    end

    require("competitest").setup({
      local_config_file_name = ".competitest.lua",

      floating_border = "rounded",
      floating_border_highlight = "FloatBorder",
      picker_ui = {
        width = 0.2,
        height = 0.3,
        mappings = {
          focus_next = { "j", "<down>", "<Tab>" },
          focus_prev = { "k", "<up>", "<S-Tab>" },
          close = { "<esc>", "<C-c>", "q", "Q" },
          submit = "<cr>",
        },
      },
      editor_ui = {
        popup_width = 0.4,
        popup_height = 0.6,
        show_nu = true,
        show_rnu = false,
        normal_mode_mappings = {
          switch_window = { "<C-h>", "<C-l>", "<C-i>" },
          save_and_close = "<C-s>",
          cancel = { "q", "Q" },
        },
        insert_mode_mappings = {
          switch_window = { "<C-h>", "<C-l>", "<C-i>" },
          save_and_close = "<C-s>",
          cancel = "<C-q>",
        },
      },
      runner_ui = {
        interface = "popup",
        selector_show_nu = false,
        selector_show_rnu = false,
        show_nu = true,
        show_rnu = false,
        mappings = {
          run_again = "R",
          run_all_again = "<C-r>",
          kill = "K",
          kill_all = "<C-k>",
          view_input = { "i", "I" },
          view_output = { "a", "A" },
          view_stdout = { "o", "O" },
          view_stderr = { "e", "E" },
          toggle_diff = { "d", "D" },
          close = { "q", "Q" },
        },
        viewer = {
          width = 0.5,
          height = 0.5,
          show_nu = true,
          show_rnu = false,
          open_when_compilation_fails = true,
        },
      },
      popup_ui = {
        total_width = 0.8,
        total_height = 0.8,
        layout = {
          { 4, "tc" },
          { 5, { { 1, "so" }, { 1, "si" } } },
          { 5, { { 1, "eo" }, { 1, "se" } } },
        },
      },
      split_ui = {
        position = "right",
        relative_to_editor = true,
        total_width = 0.3,
        vertical_layout = {
          { 1, "tc" },
          { 1, { { 1, "so" }, { 1, "eo" } } },
          { 1, { { 1, "si" }, { 1, "se" } } },
        },
        total_height = 0.4,
        horizontal_layout = {
          { 2, "tc" },
          { 3, { { 1, "so" }, { 1, "si" } } },
          { 3, { { 1, "eo" }, { 1, "se" } } },
        },
      },

      save_current_file = true,
      save_all_files = false,
      compile_directory = ".",
      compile_command = {
        c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
        cpp = {
          exec = "sh",
          args = {
            "-c",
            "mkdir -p .bin && g++ -std=gnu++17 -Wall -I'$(HOME)/programming/competitive/include' '$(FNAME)' -o .bin/'$(FNOEXT)'",
          },
        },
        rust = { exec = "rustc", args = { "$(FNAME)" } },
        java = { exec = "javac", args = { "$(FNAME)" } },
      },
      running_directory = ".",
      run_command = {
        c = { exec = "./$(FNOEXT)" },
        cpp = { exec = "./.bin/$(FNOEXT)" },
        rust = { exec = "./$(FNOEXT)" },
        python = { exec = "python", args = { "$(FNAME)" } },
        java = { exec = "java", args = { "$(FNOEXT)" } },
      },

      multiple_testing = -1,
      maximum_time = 5000,
      output_compare_method = "squish",
      view_output_diff = false,

      testcases_directory = ".tests",

      testcases_use_single_file = true,
      testcases_auto_detect_storage = true,
      testcases_single_file_format = "$(FNOEXT).testcases",

      testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
      testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

      companion_port = 27121,
      receive_print_message = true,
      start_receiving_persistently_on_setup = false,

      -- ~/programming/competitive/templates/template.cpp
      template_file = root .. "/templates/template.$(FEXT)",
      evaluate_template_modifiers = true,

      date_format = "%c",
      received_files_extension = "cpp",

      received_problems_prompt_path = false,
      received_contests_prompt_directory = false,
      received_contests_prompt_extension = false,

      -- receive problem: ~/programming/competitive/<judge>/<contest>/<problem>.cpp
      received_problems_path = function(task, ext)
        local judge, contest = parse_group(task.group)
        local prob = slugify(task.name)
        return string.format("%s/%s/%s/%s.%s", root, judge, contest, prob, ext)
      end,

      -- receive contest root: ~/programming/competitive/<judge>/<contest>/
      received_contests_directory = function(task, _)
        local judge, contest = parse_group(task.group)
        return string.format("%s/%s/%s", root, judge, contest)
      end,

      -- receive contest problems: <contest>/<problem>.cpp
      received_contests_problems_path = function(task, ext)
        return string.format("%s.%s", slugify(task.name), ext)
      end,

      open_received_problems = true,
      open_received_contests = true,
      replace_received_testcases = false,
    })

    vim.keymap.set("n", "<space>rr", "<cmd>CompetiTest run<CR>", { desc = "CompetiTest run" })
    vim.keymap.set(
      "n",
      "<space>rt",
      "<cmd>CompetiTest receive testcases<CR>",
      { desc = "CompetiTest receive testcases" }
    )
    vim.keymap.set("n", "<space>rp", "<cmd>CompetiTest receive problem<CR>", { desc = "CompetiTest receive problem" })
    vim.keymap.set("n", "<space>ra", "<cmd>CompetiTest add_testcase<CR>", { desc = "CompetiTest run" })
    vim.keymap.set("n", "<space>re", "<cmd>CompetiTest edit_testcase<CR>", { desc = "CompetiTest run" })
  end,
}
