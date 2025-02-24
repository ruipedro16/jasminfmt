# jasminfmt

[Jasmin](https://github.com/jasmin-lang/jasmin) source code formatter

- `jasmin2tex` must be in `PATH`
- Comments are not preserved
- `-I` for include paths
- `-i` to format inplace
- `-in foo -o bar`: format `foo` and print the result to `bar`
- `-in foo`: format `foo` and print the result to `stdout`
- `-in foo -c config.json -o bar`: format `foo` and print the result to `bar` using the config file `config.json`

## Config

- `indent_size`: no. of spaces (e.g. `"indent_size": 2`). Default is 4
- `split_fn_modifier`: `True`/`true`. Default is false 