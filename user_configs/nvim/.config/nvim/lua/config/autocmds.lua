-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local fn = vim.fn -- 'file utils'
local json = vim.json

--
-- OK I CAN'T EXPORT A WHOLE FOLDER IN IPYNB... DOWNLOAD THE FOLDER STRUCTURE... TO GET IT, JUST DOWNLOAD THE DIR, AND THEN RECURSIVELY ITERATE THROUGH TO GET ALL FILES THAT END IN .PY or whatever it is... then redownload these manually using the ipynb flag... pushing them back should be no problem...nn
-- TODO: Make a notification to say that databrick sync is on for a given workspace. Do this in the workspace file, by checking for databricks, and then if the relveant configuration files are found, printing it at startup in the same box. Only if in the databricks workspace, print that it's off if in the right workspace.
-- Databricks sync integration: automatically upload files in a marked databricks sub-folder upon write.
-- TODO: Get chatgpt to explain the folder structure here - difference between sync dir, env dir (above it - which databricks env), and the databricks dir.
--       The config only contains info on the remote folder into which the entire local folder will be synced. The includes the folder containing the .nvim/.databrick-sync file.
--       The folder structure is "databricks" (top level) -> "env folder" (which environment) -> "sync folder" (the folder corresponding to the a folder in databricks - local and remote relative paths should match from here)
local databricks_root = "/Users/Yonah.Citron/Library/CloudStorage/OneDrive-Shell/databricks"

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(args)
    local abs_path = fn.resolve(fn.fnamemodify(args.file, ":p"))
    if not vim.startswith(abs_path, databricks_root) then
      return
    end

    -- Walk up until we hit the workspace root (folder that contains .nvim)
    local dir = fn.fnamemodify(abs_path, ":h")
    while dir ~= databricks_root do
      local workspace_dir = dir .. "/.nvim"
      if fn.isdirectory(workspace_dir) == 1 then
        local env_dir = fn.fnamemodify(dir, ":h")
        local sync_file = workspace_dir .. "/.databricks-sync"
        if fn.filereadable(sync_file) == 1 then
          local conf = json.decode(table.concat(fn.readfile(sync_file), "\n"))
          local rel_path = abs_path:sub(#env_dir + 2) -- relative to sync root
          local remote_path = conf.remote_dir .. rel_path
          local tmp_ipynb_no_ext = fn.fnamemodify(abs_path, ":r")

          local import_args = { "databricks", "--debug", "workspace", "import" }
          local tmp_ipynb

          if abs_path:sub(-3) == ".py" then -- ── Python notebook flow ──
            -- Jupytext requires a .ipynb extension to do the conversion, add it temporarily for this process. Upload to databricks without the extension, for neatness.
            tmp_ipynb = tmp_ipynb_no_ext .. ".ipynb"
            local jupy = vim
              .system({
                "jupytext",
                "--from",
                "py:percent",
                "--to",
                "ipynb",
                abs_path,
                "--output",
                tmp_ipynb,
              })
              :wait()
            if jupy.code ~= 0 then
              vim.notify("❌ Jupytext conversion failed:\n" .. jupy.stderr, vim.log.levels.ERROR)
              return
            end
            os.rename(tmp_ipynb, tmp_ipynb_no_ext)
            remote_path = fn.fnamemodify(remote_path, ":r")
            vim.list_extend(
              import_args,
              { remote_path, "--file", tmp_ipynb_no_ext, "--format", "JUPYTER", "--overwrite" }
            )
          else -- ── Normal file flow ──
            vim.list_extend(import_args, { remote_path, "--file", abs_path, "--format", "AUTO", "--overwrite" })
          end

          local result = vim.system(import_args, { pty = true }):wait()
          if result.code ~= 0 then
            vim.notify(
              ("❌ Databricks sync failed (%d):\n%s"):format(result.code, result.stderr),
              vim.log.levels.ERROR
            )
          else
            vim.notify("✅ Databricks sync success: " .. abs_path .. " → " .. remote_path)
          end

          if tmp_ipynb_no_ext and fn.filereadable(tmp_ipynb_no_ext) == 1 then
            fn.delete(tmp_ipynb_no_ext)
          end
          return
        end
      end
      dir = fn.fnamemodify(dir, ":h")
    end
  end,
})
