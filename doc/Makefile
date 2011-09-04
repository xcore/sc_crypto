SPHINX_PROJECT_NAME=Cryptography Component
VERSION=0v1
DOXYGEN_DIRS=../../sc_crypto/module_SHA2
SOURCE_INCLUDE_DIRS=../../sc_crypto
XDOC_DIR ?= ../../xdoc
include $(XDOC_DIR)/Makefile.inc

all: html pdf
	@if [ ! -d ../../sc_crypto_gh_pages ] ; then echo '**** no gh_pages checked out ****'; exit 0; else cp -r _build/html/* ../../sc_crypto_gh_pages/; cp -r _build/html/.doctrees ../../sc_crypto_gh_pages/; fi
