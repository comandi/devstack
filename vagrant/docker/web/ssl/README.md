# Generating SSL certificates

Generating an SSL certificate works as follows:

 * Copy `openssl.cnf.dist` to `openssl.cnf`
 * Add other domain names to the `[alt_names]` sections at the end of the file
 * Run ./request.sh
