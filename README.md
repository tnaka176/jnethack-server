# jnethack-server

## Overview

docker image of jnethack + gotty.

- nethack-3.6.6

- jnethack.patch-3.6.6-0.5

- gotty

## Reference

https://www.nethack.org/

https://jnethack.osdn.jp/

https://nethack.zacharymwyatt.com/server-setup-366.html

https://github.com/yudai/gotty

## .env file

### HTTP_PROXY

use proxy when build container.

### JNETHACK_EXTERNAL_PORT

listen gotty port.

eg. `8080`

### TZ

set timezone.

eg. `Japan`

### NETHACKOPTIONS

set nethack option.

eg. `!autopickup,symset:DECgraphics`

### GOTTY_CREDENTIAL

set gotty credential. (loginuser:password)

if no-credential access, set `disabled`

### GOTTY_TITLE_FORMAT

set display browser title.

eg. `"GoTTY - jnethack"`

### GOTTY_PERMIT_WRITE

set `true`
