.ONESHELL:
wasm:
	cargo build --target wasm32-unknown-unknown
	cd target/wasm32-unknown-unknown/debug
	wasm-bindgen --target web --no-typescript --out-dir . wasm_sample.wasm
	wasm-gc wasm_sample_bg.wasm
	cp wasm_sample_bg.wasm ../../../www
	cp wasm_sample.js ../../../www
	cd -
	ls -l www

clean:
	rm target/wasm32-unknown-unknown/debug/wasm_sample*.*
	rm www/wasm_sample*.wasm