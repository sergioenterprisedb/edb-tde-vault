#!/usr/bin/env python3

"""EDB TDE KMIP client

This program provides the glue between EDB's TDE implementation and
KMIP-enabled key management servers.
"""

import argparse
import sys
from kmip.pie.client import ProxyKmipClient
from kmip import enums


# This configuration encrypts the input using AES-CBC with the usual
# padding and writes the generated IV followed by the ciphertext.
# (For key wrapping, we wouldn't actually need any padding, but at
# least the PyKMIP server doesn't actually support the padding method
# NONE, so it would be difficult to test.  The padding does provide a
# bit of error checking, so it's not bad to have it.)
#
# Other configurations could be added.  (But note that that would
# probably also require some changes below at the encrypt and decrypt
# calls.)
cryptographic_parameters = {
    'cryptographic_algorithm': enums.CryptographicAlgorithm.AES,
    'block_cipher_mode': enums.BlockCipherMode.CBC,
    'padding_method': enums.PaddingMethod.PKCS5,
    'random_iv': True,
}


def main():
    argparser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description='EDB TDE KMIP client',
        epilog='''
Typical use for EDB TDE is:

    PGDATAKEYWRAPCMD='python edb_tde_kmip_client.py encrypt --key-uid=... --out-file=%p'
    PGDATAKEYUNWRAPCMD='python edb_tde_kmip_client.py decrypt --key-uid=... --in-file=%p'
    export PGDATAKEYWRAPCMD PGDATAKEYUNWRAPCMD

See also <https://pykmip.readthedocs.io/en/latest/client.html#configuration>
for information about the configuration file.
'''
    )
    argparser.add_argument('action', choices=['decrypt', 'encrypt'])
    argparser.add_argument('--pykmip-config-file', metavar='FILENAME',
                           help='location of pykmip.conf file')
    argparser.add_argument('--pykmip-config-block', metavar='NAME',
                           default='client',
                           help='block name in pykmip.conf file')
    argparser.add_argument('--in-file', metavar='FILENAME',
                           help='input file (for decrypt action)')
    argparser.add_argument('--out-file', metavar='FILENAME',
                           help='output file (for encrypt action)')
    argparser.add_argument('--key-uid',
                           required=True,
                           help='unique identifier of key to use')
    argparser.add_argument('--variant', choices=['pykmip', 'thales'],
                           required=True,
                           help='choose among incompatible KMIP variants')
    args = argparser.parse_args()

    pykmip_client = ProxyKmipClient(config_file=args.pykmip_config_file,
                                    config=args.pykmip_config_block)

    with pykmip_client:
        if args.action == 'decrypt':
            with open(args.in_file, mode="rb") as f:
                filedata = f.read()
            iv = filedata[:16]
            ciphertext = filedata[16:]

            # For pykmip: The ciphertext and the IV are passed as
            # separate arguments; the result is the plaintext.  For
            # thales: The IV+ciphertext are passed together (as they
            # are in the file); the result has the plaintext at an
            # offset.
            #
            # (Yes, the "I" in KMIP stands for "Interoperability".)
            if args.variant == 'pykmip':
                plaintext = pykmip_client.decrypt(
                    data=ciphertext,
                    iv_counter_nonce=iv,
                    uid=args.key_uid,
                    cryptographic_parameters=cryptographic_parameters
                )
            elif args.variant == 'thales':
                tmp = pykmip_client.decrypt(
                    data=filedata,
                    uid=args.key_uid,
                    cryptographic_parameters=cryptographic_parameters
                )
                plaintext = tmp[16:]

            sys.stdout.buffer.write(plaintext)
        elif args.action == 'encrypt':
            plaintext = sys.stdin.buffer.read()
            ciphertext, iv = pykmip_client.encrypt(
                data=plaintext,
                uid=args.key_uid,
                cryptographic_parameters=cryptographic_parameters
            )
            with open(args.out_file, mode="wb") as f:
                f.write(iv + ciphertext)


if __name__ == '__main__':
    main()
