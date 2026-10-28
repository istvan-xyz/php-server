# Writes php.ini: the base image's php.ini-production, with PrestaShop's settings.
# Usage, after a change to FROM or to SETTINGS:
#   docker run --rm <the FROM image> cat /usr/local/etc/php/php.ini-production > php.ini-production
#   python3 -I make-php-ini.py php.ini-production php.ini && rm php.ini-production
import re, sys

SETTINGS = {
    'expose_php': 'Off',
    # PrestaShop 9's documented minimum; 8.x and 9.x refuse less than 256M
    'memory_limit': '512M',
    'max_input_vars': '5000',
    # php.net's advice for sites that take uploads (2026-10-21 advisory)
    'post_max_size': '32M',
    'upload_max_filesize': '16M',
    # php.net 2026-10-23: off until the next bugfix release (CVE-2026-115560)
    'session.upload_progress.enabled': 'Off',
    'realpath_cache_size': '4096k',
    'realpath_cache_ttl': '600',
    'opcache.memory_consumption': '256',
    'opcache.interned_strings_buffer': '16',
    'opcache.max_accelerated_files': '20000',
}

src, dst = sys.argv[1], sys.argv[2]
text = open(src).read()
for key, value in SETTINGS.items():
    # The directive itself, or its commented-out default; not the Quick Reference
    # section, which lists defaults as "; key" lines with no '='.
    pattern = re.compile(r'^;?\s*' + re.escape(key) + r'\s*=.*$', re.M)
    matches = list(pattern.finditer(text))
    if not matches:
        sys.exit(f'{key} not found in {src}')
    line = matches[-1]
    text = text[:line.start()] + f'{key} = {value}' + text[line.end():]
open(dst, 'w').write(text)
