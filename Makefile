SRC = src/*.coffee
DIST = dist/
NAME = jstile.js

build:
	coffee -j $(DIST)$(NAME) -cb $(SRC)

clean:
	rm -rf $(DIST) 
