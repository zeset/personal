build:
	ocamlbuild -package graphics -I src -cflags "-warn-error +a" main.native
	mkdir -p bin
	mv ./main.native ./bin/coreldro

test: build
	ocamlbuild -package oUnit -package graphics -I src -I tests app_test.native
	mv app_test.native ./bin/app_test
	./bin/app_test

.PHONY: clean

clean:
	rm -rf ./_build
	rm -rf ./bin
