#
# Makefile : Builds wxWindows samples for Unix.
#

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_DIR = /usr/bin/install -c -d
PROJ_SUBDIRS=vscpworks  
VSCP_PROJ_BASE_DIR=/srv/vscp
IPADDRESS :=  $(shell hostname -I)

all:
	@for d in $(PROJ_SUBDIRS); do (echo "====================================================" &&\
	echo "Building in dir " $$d && echo "====================================================" && cd $$d && $(MAKE)); done

install-all: install install-folders install-startup-script install-config install-sample-data install-sample-certs install-manpages

install: install-folders install-startup-script install-config install-sample-data install-sample-certs install-manpages
# Install sub components
	@for d in $(PROJ_SUBDIRS); do (echo "====================================================" &&\
	echo "Building in dir " $$d && echo "====================================================" && cd $$d && $(MAKE) install); done
	@echo
	@echo
	@echo "Your VSCP & Friends system is now installed."
	@echo "============================================"
	@echo 
	@echo "If this is the first install of VSCP & Friends on this system issue"
	@echo "'make install-first' to install data files and configuration files or"
	@echo "manually do the steps below."
	@echo
	@echo "1.) Use 'make install-folders' to construct all folders."
	@echo
	@echo "2.) Use 'make install-config' to install default configuration files "
	@echo
	@echo "3.) Use 'make install-startup' install startup.script on Debian systems."
	@echo 
	@echo "4.) Use 'make install-manpages' to install on-line docs."
	@echo
	@echo "5.) Use 'make install-sample-data' to install on-line docs."
	@echo
	@echo "6.) Use 'make install-sample-certs' to install on-line docs."
	@echo
	@echo "All of steps 1-6 can be done with 'make install-system' or 'make install-all'"
	@echo
	@echo "Use 'make intall-web-samples' to install sample web-pages."
	@echo
	@echo " - Start the VSCP daemon with 'sudo /etc/init.d/vscpd start'"
	@echo "   or 'vscpd -s' to start the daemon in the  foreground."
	@echo
	@echo " - Admin interface is at http://localhost:8884/vscp"
	@echo "   Username: admin, Password: secret"
	@echo
	@echo " - If you have installed the web sample pages it is located at"
	@echo "   http://localhost:8884. Remember to change the ip address"
	@echo "   in the file /srv/vscp/web/testws/settings.js to your local"
	@echo "   ip address ($(IPADDRESS)) to be able to access this content from other "
	@echo "   machines than your local machine."
	@echo
	@echo " - You can reach core functionality in the telnet interface on"
	@echo "   this machine ($(IPADDRESS)) at port 9598."
	@echo "   Username: 'admin', Password: 'secret'"
	@echo
	@echo " - The configuration file for the VSCP daemon is at '/etc/vscd/vscpd.conf' and"
	@echo "   you can read about the different available options here "
	@echo "   https://grodansparadis.gitbooks.io/the-vscp-daemon/configuring_the_vscp_daemon.html"
	@echo "   Other configuration files is under /srv/vscp"
	@echo
	@echo " - Documentation is at https://grodansparadis.gitbooks.io/the-vscp-daemon "
	@echo "   and more general documentation can be found at http://www.vscp.org/docs"
	@echo
	@echo "   Have fun and remember to always be hungry and stay foolish or the other way"
	@echo "   around be foolish - stay hungry! - There is always a choice."

install-system: install-folders install-startup-script install-config install-sample-data install-sample-certs install-manpages

install-folders:
	@echo "- Creating folders."
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/logs
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/actions
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/scripts
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/scripts/javascript
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/scripts/lua
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/ux
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/web
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/web/js
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/web/service
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/certs
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/drivers
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/drivers/level1
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/drivers/level2
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/drivers/level2
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/upload
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/web/css
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/web/images
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/web/lib
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/web/testws
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/vscp
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/tables
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/mdf
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/tmp

install-startup-script:
	@$(INSTALL_PROGRAM) -d $(DESTDIR)/etc
	$(INSTALL_PROGRAM) -d $(DESTDIR)/etc/init.d
	@echo "- Installing startup script."
	@if [ ! -e $(DESTDIR)/etc/init.d/vscpd ]; then\
 	    echo "- Copying startup script";\
	    $(INSTALL_PROGRAM) -b -m755 install_files/unix/vscpd.startup_script_debian $(DESTDIR)/etc/init.d/vscpd;\
	    echo "- Installing startup script";\
	    update-rc.d vscpd defaults;\
	fi

install-config:
	@echo "- Installing main configuration file."
	$(INSTALL_PROGRAM) -d $(DESTDIR)/etc/
	$(INSTALL_PROGRAM) -d $(DESTDIR)/etc/vscp
#	$(INSTALL_PROGRAM) -b -m744 install_files/unix/vscpd.conf $(DESTDIR)/etc/vscp/vscpd.conf
	@if [ ! -e $(DESTDIR)/etc/vscp/vscpd.conf ]; then\
	    $(INSTALL_PROGRAM) -b -m744 install_files/unix/vscpd.conf $(DESTDIR)/etc/vscp/vscpd.conf;\
	else\
	    $(INSTALL_PROGRAM) -b -m744 install_files/unix/vscpd.conf $(DESTDIR)/etc/vscp/vscpd.conf.`date +'%Y%m%d'`;\
	fi

install-sample-data:
	@echo "- Installing VSCP event database."
	$(INSTALL_PROGRAM) -b -m744 database/vscp_events.sqlite3 $(DESTDIR)/srv/vscp/

	@echo "- Installing example variables."
	@if [ ! -e $(DESTDIR)/srv/vscp/variables.xml ]; then\
	    $(INSTALL_PROGRAM) -b -m744 install_files/variables/variables.xml $(DESTDIR)/srv/vscp/variables.xml;\
	else\
	    $(INSTALL_PROGRAM) -b -m744 install_files/variables/variables.xml $(DESTDIR)/srv/vscp/variables.xml.`date +'%Y%m%d'`;\
	fi

	@echo "- Installing example DM."
	@if [ ! -e $(DESTDIR)/srv/vscp/dm.xml ]; then\
	    $(INSTALL_PROGRAM) -b -m744 install_files/DM/dm.xml $(DESTDIR)/srv/vscp/dm.xml;\
 	else\
 	    $(INSTALL_PROGRAM) -b -m744 install_files/DM/dm.xml $(DESTDIR)/srv/vscp/dm.xml.`date +'%Y%m%d'`;\
 	fi

	@echo "- Installing sample data for simulation."
	@if [ ! -e $(DESTDIR)/srv/vscp/simtempdata.txt ]; then\
	    $(INSTALL_PROGRAM) -b -m744 install_files/simulation/simtempdata.txt $(DESTDIR)/srv/vscp/simtempdata.txt;\
 	else\
 	    $(INSTALL_PROGRAM) -b -m744 install_files/simulation/simtempdata.txt $(DESTDIR)/srv/vscp/simtempdata.txt.`date +'%Y%m%d'`;\
	fi

install-sample-certs:
	$(INSTALL_PROGRAM) -d $(DESTDIR)/srv/vscp/certs
	@echo "- Installing web server sample certificate."
	@if [ ! -e $(DESTDIR)/srv/vscp/certs/server.pem ]; then\
	    $(INSTALL_PROGRAM) -b -m744 install_files/certs/server.pem $(DESTDIR)/srv/vscp/certs/;\
	fi

	@echo "- Installing web client sample certificat."
	@if [ ! -e $(DESTDIR)/srv/vscp/certs/client.pem ]; then\
	    $(INSTALL_PROGRAM) -b -m744 install_files/certs/client.pem $(DESTDIR)/srv/vscp/certs/;\
	fi

	@echo "- Installing tcp/ip server sample certificate."
	@if [ ! -e $(DESTDIR)/srv/vscp/certs/tcpip_server.pem ]; then\
	    $(INSTALL_PROGRAM) -b -m744 install_files/certs/tcpip_server.pem $(DESTDIR)/srv/vscp/certs/;\
	fi

	@echo "- Installing tcp/ip client sample certificat."
	@if [ ! -e $(DESTDIR)/srv/vscp/certs/tcpip_client.pem ]; then\
	    $(INSTALL_PROGRAM) -b -m744 install_files/certs/tcpip_client.pem $(DESTDIR)/srv/vscp/certs/;\
	fi	

install-manpages:
	@echo "- Installing man-pages."
	$(INSTALL_PROGRAM) -d $(DESTDIR)/usr/share/man/man8
	$(INSTALL_PROGRAM) -d $(DESTDIR)/usr/share/man/man7
	$(INSTALL_PROGRAM) -d $(DESTDIR)/usr/share/man/man1
	$(INSTALL_PROGRAM) -b -m644 man/vscpd.8 $(DESTDIR)/usr/share/man/man8/
	$(INSTALL_PROGRAM) -b -m644 man/uvscpd.8 $(DESTDIR)/usr/share/man/man8/
	$(INSTALL_PROGRAM) -b -m644 man/vscpworks.1 $(DESTDIR)/usr/share/man/man1/
	$(INSTALL_PROGRAM) -b -m644 man/vscpcmd.1 $(DESTDIR)/usr/share/man/man1/
	$(INSTALL_PROGRAM) -b -m644 man/vscp-mkpasswd.1 $(DESTDIR)/usr/share/man/man1/
	$(INSTALL_PROGRAM) -b -m644 man/vscphelperlib.1 $(DESTDIR)/usr/share/man/man1/
	$(INSTALL_PROGRAM) -b -m644 man/vscpdrivers.7 $(DESTDIR)/usr/share/man/man7/
	mandb

install-web-samples:
	echo "- Installing web-sample pages."
	sh do_web_download /srv/vscp

fetch_event_database:
	echo "Fetching VSCP event database"
	rm -f /tmp/vscp_data.sql
	rm -f /tmp/vscp_data.sqlite3
	curl -o/tmp/vscp_data.sql -LOk https://www.vscp.org/events/vscp_events.sql
	cat /tmp/vscp_data.sql | sqlite3 /tmp/vscp_data.sqlite3
	cp /tmp/vscp_data.sql database/
	cp /tmp/vscp_events.sqlite3 database/

delete-all:
	rm -rf /srv/vscp/*

clean-conf: delete-all force-conf

clean:
	@for d in $(PROJ_SUBDIRS); do (cd $$d && $(MAKE) clean); done
	rm -f config.log
	rm -f config.startup
	rm -f config.status

distclean: clean
	@sh clean_for_dist
	rm -f m4/Makefile

deb:
	@for d in $(PROJ_SUBDIRS); do (echo "====================================================" &&\
	echo "Building deb in dir " $$d && echo "====================================================" && cd $$d && $(MAKE) deb ); done

