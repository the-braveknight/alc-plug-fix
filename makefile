BINARY=alc-plug-fix
DIST=TBK-alc
BUILDDIR=./build


.PHONY: all
all:
	xcodebuild build -configuration Debug
	xcodebuild build -configuration Release

.PHONY: clean
clean:
	xcodebuild clean -configuration Debug
	xcodebuild clean -configuration Release
	
.PHONY: install
install:
	sudo cp $(BUILDDIR)/Release/$(BINARY) /usr/bin
