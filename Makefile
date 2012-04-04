SRC = src/*.coffee
DIST = dist/
NAME = jstile.js

build:
	coffee -cb test/init.coffee
	coffee -j $(DIST)$(NAME) -cb $(SRC)

clean:
	rm -f test/init.js
	rm -rf $(DIST) 
