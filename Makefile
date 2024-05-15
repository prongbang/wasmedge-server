install_wasmedge:
	curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all

build:
	cargo build --target wasm32-wasi --release
	
run:
	wasmedge target/wasm32-wasi/release/wasmedge-server.wasm

docker_build:
	docker buildx build --platform linux/arm64 -t inteniquetic/wasmedge-server .

docker_run:
	docker run -it -p 8080:8080 --name wasmedge-server inteniquetic/wasmedge-server