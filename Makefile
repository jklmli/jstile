SRC = src
DIST = dist

OUT = jstile

all: build

build:
	coffee -cb test/init.coffee
	coffee -j $(DIST)/$(OUT).js -cb $(SRC)/*.coffee

clean:
	rm -f test/init.js
	rm -rf $(DIST)
