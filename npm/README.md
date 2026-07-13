# @kaidera/kaidera-os

npm launcher for Kaidera OS. The first run downloads the matching public runtime,
verifies its SHA-256, installs it under `~/kaidera-os`, and delegates to the
`kaidera-os` CLI.

```sh
npm install --global @kaidera/kaidera-os
kaidera-os install
```
