CURL=curl
GREP=grep

README_TMP=readme.html
# change those for your project
USER=AiCure
REPO=open_dbm

.PHONY: purge

purge:
	$(CURL) -s -X PURGE https://github.com/AiCure/open_dbm/blob/master/images/badges/linux_status.svg
	$(CURL) -s -X PURGE https://github.com/AiCure/open_dbm/blob/master/images/badges/macos_status.svg
	$(CURL) -s -X PURGE https://github.com/AiCure/open_dbm/blob/master/images/badges/windows_status.svg