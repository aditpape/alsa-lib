#
# Makefile for ALSA library
# Copyright (c) 1994-98 by Jaroslav Kysela <perex@jcu.cz>
#

ifeq (Makefile.conf,$(wildcard Makefile.conf))
include Makefile.conf
else
dummy:
	@echo
	@echo "Please, run configure script as first..."
	@echo
endif


all: include/asoundlib.h
	$(MAKE) -C src
	$(MAKE) -C doc
	@echo
	@echo "ALSA library were sucessfully compiled."
	@echo

include/asoundlib.h:	include/header.h include/version.h include/error.h include/footer.h \
			include/control.h include/mixer.h include/pcm.h include/rawmidi.h
	cat include/header.h include/version.h include/error.h \
	    include/control.h include/mixer.h \
	    include/pcm.h include/rawmidi.h \
	    include/footer.h > include/asoundlib.h

install: all
	$(INSTALL) -m 644 -o root -g root include/asoundlib.h ${includedir}/sys
	$(INSTALL) -m 644 -o root -g root lib/libasound.a ${libdir}
	$(LN_S) -f libasound.so.${SND_LIB_VERSION} ${libdir}/libasound.so
	$(LN_S) -f libasound.so.${SND_LIB_VERSION} ${libdir}/libasound.so.${SND_LIB_MAJOR}
	$(INSTALL) -m 644 -o root -g root lib/libasound.so.${SND_LIB_VERSION} ${libdir}
	/sbin/ldconfig

clean:
	$(MAKE) -C include clean
	$(MAKE) -C src clean
	$(MAKE) -C test clean
	$(MAKE) -C doc clean
	$(MAKE) -C utils clean
	rm -f core .depend *.o *.orig *~
	rm -f `find . -name "out.txt"`

cvsclean: clean
	rm -f configure config.cache config.log config.status Makefile.conf \
              utils/alsa-lib.spec include/config.h include/asoundlib.h include/version.h

pack: cvsclean
	chown -R root.root ../alsa-lib
	tar cvz -C .. -f ../alsa-lib-$(SND_LIB_VERSION).tar.gz alsa-lib
