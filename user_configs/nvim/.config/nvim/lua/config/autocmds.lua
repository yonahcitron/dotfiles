-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local fn = vim.fn -- 'file utils'
local json = vim.json

-- TODO: Make a notification to say that databrick sync is on for a given workspace. Do this in the workspace file, by checking for databricks, and then if the relveant configuration files are found, printing it at startup in the same box. Only if in the databricks workspace, print that it's off if in the right workspace.
-- Databricks sync integration: automatically upload files in a marked databricks sub-folder upon write.
-- TODO: Get chatgpt to explain the folder structure here - difference between sync dir, env dir (above it - which databricks env), and the databricks dir.
--       The config only contains info on the remote folder into which the entire local folder will be synced. The includes the folder containing the .nvim-workspace/.databrick-sync file.
--       The folder structure is "databricks" (top level) -> "env folder" (which environment) -> "sync folder" (the folder corresponding to the a folder in databricks - local and remote relative paths should match from here)
local databricks_projects_real_path = "/Users/Yonah.Citron/Library/CloudStorage/OneDrive-Shell/databricks"
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(args)
    local absolute_local_path = fn.resolve(fn.fnamemodify(args.file, ":p")) -- Resolve symlinks and get absolute path
    if vim.startswith(absolute_local_path, databricks_projects_real_path) then
      -- Iterate up the folder path to find the configuration file for syncing
      local parent_dir = fn.fnamemodify(absolute_local_path, ":h")
      while parent_dir ~= databricks_projects_real_path do
        -- Stop iteration at the project sync dir root
        local workspace_dir = parent_dir .. "/.nvim-workspace"
        if fn.isdirectory(workspace_dir) == 1 then -- Found the workspace folder, meaning it's the root of a sync dir
          local environment_dir = fn.fnamemodify(parent_dir, ":h") -- e.g. "emob-dev" - one level above the sync folder dirs
          local databricks_sync_file = workspace_dir .. "/.databricks-sync"
          if fn.filereadable(databricks_sync_file) == 1 then -- Found the file with the sync configs
            local conf_json = table.concat(vim.fn.readfile(databricks_sync_file), "\n") -- Readfile returns a "list" (just a table). The table.concat is essentially the join method.
            local conf = json.decode(conf_json)
            local relative_path = absolute_local_path:sub(#environment_dir + 2) -- Strips away everything before the sync dir root, including the root folder itself. From this point, the structure should be the same on the local and remote.
            local remote_path = conf["remote_dir"] .. relative_path
            local cmd = "databricks --debug workspace import"
              .. ' "'
              .. remote_path
              .. '" '
              .. "--file"
              .. ' "'
              .. absolute_local_path
              .. '" '
              .. "--format AUTO --overwrite"
            local result = vim.system({ "bash", "-lc", cmd }, { pty = true }):wait()
            if result.code ~= 0 then
              vim.notify(
                string.format("❌ Databricks sync failed for file: " .. args.file),
                string.format("Exit code %d:\n%s", result.code, result.stderr),
                vim.log.levels.ERROR
              )
            else
              vim.notify("✅ Databricks sync success for file: " .. args.file)
              vim.notify("Sync path: " .. absolute_local_path .. "-->" .. remote_path)
            end
            return
          else
            vim.notify(
              ".databrick-sync file not found in parent workspace folder: " .. workspace_dir .. ". File not synced."
            )
          end
        end
        parent_dir = fn.fnamemodify(parent_dir, ":h") -- Search the next folder
      end
      vim.notify(
        ".nvim-workspace config dir not found within the local databricks folder: "
          .. parent_dir
          .. ". File not synced."
      )
    end
  end,
})
