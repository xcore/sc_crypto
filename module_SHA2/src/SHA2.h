// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

void computeSHA2(unsigned int message[16], unsigned int hash[8]);

void sha256Process(streaming chanend c);

void sha256Begin(streaming chanend c);
void sha256Update(streaming chanend c, unsigned char message[], int n);
void sha256End(streaming chanend c, unsigned int hash[8]);
void sha256Terminate(streaming chanend c);

void sha256BlockBegin(unsigned int hash[8]);
void sha256BlockUpdate(unsigned int hash[8], unsigned char message[], int n);
void sha256BlockEnd(unsigned int hash[8]);
