SRC = src/*.coffee

build:
	coffee -cb test/init.coffee
	coffee -cb src/jstile.coffee

clean:
	rm -f test/init.js
	rm -f src/jstile.coffee
