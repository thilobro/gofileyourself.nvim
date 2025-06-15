# gofileyourself-nvim

Neovim plugin for [gofileyourself](https://github.com/thilobro/gofileyourself).
Based on [ranger.nvim](https://github.com/kelly-lin/ranger.nvim).

## Lazy Example Config

```
return {
    {
        "thilobro/gofileyourself.nvim",
        vim.api.nvim_create_user_command("Ra", function()
            require("gofileyourself-nvim").open("current_buffer")
        end, {}),
        vim.api.nvim_create_user_command("Ran", function()
            require("gofileyourself-nvim").open("new_buffer")
        end, {}),
    },
}
```
