OS := $(shell uname | awk '{print tolower($$0)}')

BIN_DIR := ./bin

ROVER_VERSION := 0.8.2

ROVER := $(abspath $(BIN_DIR)/rover)

.PHONY: rover
rover:
	@curl -sSL "https://github.com/apollographql/rover/releases/download/v$(ROVER_VERSION)/rover-v$(ROVER_VERSION)-$(shell uname -m)-unknown-$(OS)-gnu.tar.gz" | tar -C $(BIN_DIR) -xzv dist/rover
	@mv $(BIN_DIR)/dist/rover $(ROVER) && rm -rf $(BIN_DIR)/dist
