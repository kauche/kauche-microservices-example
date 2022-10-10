OS := $(shell uname | awk '{print tolower($$0)}')

BIN_DIR := ./bin

ROVER_VERSION := 0.8.2

GQLGEN := $(abspath $(BIN_DIR)/gqlgen)
ROVER := $(abspath $(BIN_DIR)/rover)

.PHONY: gqlgen
gqlgen:
	@cd ./tools && go build -o $(GQLGEN) github.com/99designs/gqlgen

.PHONY: rover
rover:
	@curl -sSL "https://github.com/apollographql/rover/releases/download/v$(ROVER_VERSION)/rover-v$(ROVER_VERSION)-$(shell uname -m)-unknown-$(OS)-gnu.tar.gz" | tar -C $(BIN_DIR) -xzv dist/rover
	@mv $(BIN_DIR)/dist/rover $(ROVER) && rm -rf $(BIN_DIR)/dist

.PHONY: customer-graphql-schema
customer-graphql-schema:
	@APOLLO_ELV2_LICENSE=accept $(ROVER) supergraph compose --config ./api/platform/customer/graphql/supergraph.yaml > ./api/platform/customer/graphql/schema.graphqls

.PHONY: lib-go-commerce-graphql
lib-go-commerce-graphql:
	@./bin/kauche-gqlgen \
		--path ./lib/go/api/services/commerce/graphql/ \
		--schema ./api/services/commerce/graphql/schema.graphqls

.PHONY: lib-go-social-graphql
lib-go-social-graphql:
	@./bin/kauche-gqlgen \
		--path ./lib/go/api/services/social/graphql/ \
		--schema ./api/services/social/graphql/schema.graphqls

.PHONY: lib-swift-customer-graphql
lib-swift-customer-graphql:
	@./node_modules/.bin/apollo codegen:generate \
		--target=swift \
		--addTypename \
		--includes=./api/platform/customer/graphql/query/ProductList.graphql \
		--localSchemaFile=./api/platform/customer/graphql/schema.graphqls \
		--operationIdsPath=./lib/swift/api/platform/customer/graphql/operationIDs.json \
		--mergeInFieldsFromFragmentSpreads ./lib/swift/api/platform/customer/graphql/API.swift

.PHONY: lib-kotlin-graphql
lib-kotlin-graphql:
	@rm -rf ./lib/kotlin/com
	@mkdir -p ./lib/kotlin/com/kauche/api/platform
	@./gradlew :api:generateApolloSources
	@mv ./api/build/generated/source/apollo/customer-graphql/com/kauche/api/platform/customer ./lib/kotlin/com/kauche/api/platform/customer
