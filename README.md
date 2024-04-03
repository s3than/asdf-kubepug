<div align="center">

# asdf-kubepug [![Build](https://github.com/s3than/asdf-kubepug/actions/workflows/build.yml/badge.svg)](https://github.com/s3than/asdf-kubepug/actions/workflows/build.yml) [![Lint](https://github.com/s3than/asdf-kubepug/actions/workflows/lint.yml/badge.svg)](https://github.com/s3than/asdf-kubepug/actions/workflows/lint.yml)


[kubepug](https://github.com/kubepug/kubepug) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Install

Plugin:

```shell
asdf plugin add kubepug https://github.com/s3than/asdf-kubepug.git
```

kubepug:

```shell
# Show all installable versions
asdf list-all kubepug

# Install specific version
asdf install kubepug latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kubepug latest

# Now kubepug commands are available
kubepug --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/s3than/asdf-kubepug/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Tim Colbert](https://github.com/s3than/)
