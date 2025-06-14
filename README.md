# gofileyourself-nvim

Neovim plugin for [gofileyourself](https://github.com/thilobro/gofileyourself)

## Lazy Example Config

```
return {
    {
        "thilobro/gofileyourself.nvim",
        vim.api.nvim_create_user_command("Ra", function()
            require("gofileyourself-nvim").open()
        end, {}),
    },
}
```
