BIN_DIR := ./bin

GQLGEN := $(abspath $(BIN_DIR)/gqlgen)

.PHONY: gqlgen
gqlgen:
	@cd ./tools && go build -o $(GQLGEN) github.com/99designs/gqlgen
