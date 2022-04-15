#!/usr/bin/env python
# coding: utf-8

import os
import yaml


with open('../caliper-workspace/networks/networkConfig.yaml') as file: 
    networkFile = yaml.load(file, Loader=yaml.FullLoader)

priv_key_path_org1 = networkFile['organizations'][0]['identities']['certificates'][0]['clientPrivateKey']['path'].split('/')

priv_key_path_org1[10] = os.listdir('../fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/minter@org1.example.com/msp/keystore/')[0]

networkFile['organizations'][0]['identities']['certificates'][0]['clientPrivateKey']['path'] = '/'.join(priv_key_path_org1)

priv_key_path_org2 = networkFile['organizations'][1]['identities']['certificates'][0]['clientPrivateKey']['path'].split('/')

priv_key_path_org2[10] = os.listdir('../fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/users/recipient@org2.example.com/msp/keystore/')[0]

networkFile['organizations'][1]['identities']['certificates'][0]['clientPrivateKey']['path'] = '/'.join(priv_key_path_org2)


with open('../caliper-workspace/networks/networkConfig.yaml', 'w') as file: 
    yaml.dump(networkFile, file)
