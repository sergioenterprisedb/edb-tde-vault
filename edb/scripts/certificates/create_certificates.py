#import sys
#sys.path.append('/usr/edb/kmip/client')
#import edb_tde_kmip_client.py

from kmip.pie import client
from kmip import enums
c = client.ProxyKmipClient(config_file='/vagrant/scripts/certificates/pykmip.conf')
c.open()
key_id = c.create(enums.CryptographicAlgorithm.AES, 128, name='edbtestkey')
c.activate(key_id)
print (key_id)
c.close()
