OS   := $(shell uname | awk '{print tolower($$0)}')
ARCH := $(shell case $$(uname -m) in (x86_64) echo amd64 ;; (aarch64) echo arm64 ;; (*) echo $$(uname -m) ;; esac)

BIN_DIR := ./bin

ROVER_VERSION              := 0.14.0
CUE_VERSION                := 0.5.0
BUF_VERSION                := 1.20.0
PROTOC_GEN_GO_VERSION      := 1.30.0
PROTOC_GEN_GO_GRPC_VERSION := 1.3.0

ROVER              := $(abspath $(BIN_DIR)/rover-$(ROVER_VERSION))
CUE                := $(abspath $(BIN_DIR)/cue-$(CUE_VERSION))
BUF                := $(abspath $(BIN_DIR)/buf-$(BUF_VERSION))
PROTOC_GEN_GO      := $(abspath $(BIN_DIR)/protoc-gen-go)
PROTOC_GEN_GO_GRPC := $(abspath $(BIN_DIR)/protoc-gen-go-grpc)

PROXY_WASM_GOOGLE_METADATA_IDENTITY_TOKEN_VERSION := 0.2.0
PROXY_WASM_CLOUD_LOGGING_TRACE_CONTEXT_VERSION    := 0.1.0
PROXY_WASM_HTTP_HEADER_RENAME_VERSION             := 0.1.0

PROXY_WASM_GOOGLE_METADATA_IDENTITY_TOKEN := $(abspath $(BIN_DIR)/proxy-wasm-google-metadata-identity-token-$(PROXY_WASM_GOOGLE_METADATA_IDENTITY_TOKEN_VERSION).wasm)
PROXY_WASM_CLOUD_LOGGING_TRACE_CONTEXT    := $(abspath $(BIN_DIR)/proxy-wasm-cloud-logging-trace-context-$(PROXY_WASM_CLOUD_LOGGING_TRACE_CONTEXT_VERSION).wasm)
PROXY_WASM_HTTP_HEADER_RENAME             := $(abspath $(BIN_DIR)/proxy-wasm-http-header-rename-$(PROXY_WASM_CLOUD_LOGGING_TRACE_CONTEXT_VERSION).wasm)

.PHONY: gen-code
gen-code: customer-graphql-schema lib-go-commerce-graphql lib-go-social-graphql lib-swift-customer-graphql lib-kotlin-graphql

.PHONY: kauche-gqlgen
kauche-gqlgen:
	@CGO_ENABLED=0 go build -trimpath -ldflags "-s -w -extldflags -static" -o ./bin/kauche-gqlgen ./cmd/platform/kauche-gqlgen

rover: $(ROVER)
$(ROVER):
	@curl -sSL "https://github.com/apollographql/rover/releases/download/v$(ROVER_VERSION)/rover-v$(ROVER_VERSION)-$(shell uname -m)-unknown-$(OS)-gnu.tar.gz" | tar -C $(BIN_DIR) -xzv dist/rover
	@mv $(BIN_DIR)/dist/rover $(ROVER) && rm -rf $(BIN_DIR)/dist

cue: $(CUE)
$(CUE):
	@curl -sSL "https://github.com/cue-lang/cue/releases/download/v$(CUE_VERSION)/cue_v$(CUE_VERSION)_$(OS)_$(ARCH).tar.gz" | tar -C ./bin -xzv cue
	@chmod +x $(BIN_DIR)/cue
	@mv $(BIN_DIR)/cue $(CUE)

buf: $(BUF)
$(BUF):
	@curl -sSL "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-$(shell uname -s)-$(shell uname -m)" -o $(BUF) && chmod +x $(BUF)

protoc-gen-go: $(PROTOC_GEN_GO)
$(PROTOC_GEN_GO):
	@curl -sSL https://github.com/protocolbuffers/protobuf-go/releases/download/v$(PROTOC_GEN_GO_VERSION)/protoc-gen-go.v$(PROTOC_GEN_GO_VERSION).$(OS).$(ARCH).tar.gz | tar -C $(BIN_DIR) -xzv protoc-gen-go

protoc-gen-go-grpc: $(PROTOC_GEN_GO_GRPC)
$(PROTOC_GEN_GO_GRPC):
	@curl -sSL https://github.com/grpc/grpc-go/releases/download/cmd%2Fprotoc-gen-go-grpc%2Fv$(PROTOC_GEN_GO_GRPC_VERSION)/protoc-gen-go-grpc.v$(PROTOC_GEN_GO_GRPC_VERSION).$(OS).$(ARCH).tar.gz | tar -C $(BIN_DIR) -xzv ./protoc-gen-go-grpc

proxy-wasm-google-metadata-identity-token.wasm: $(PROXY_WASM_GOOGLE_METADATA_IDENTITY_TOKEN)
$(PROXY_WASM_GOOGLE_METADATA_IDENTITY_TOKEN):
	@curl -sSL "https://github.com/kauche/proxy-wasm-google-metadata-identity-token/releases/download/v${PROXY_WASM_GOOGLE_METADATA_IDENTITY_TOKEN_VERSION}/proxy-wasm-google-metadata-identity-token.wasm" \
		-o $(BIN_DIR)/proxy-wasm-google-metadata-identity-token.wasm
	@cp $(BIN_DIR)/proxy-wasm-google-metadata-identity-token.wasm $(PROXY_WASM_GOOGLE_METADATA_IDENTITY_TOKEN)

proxy-wasm-cloud-logging-trace-context.wasm: $(PROXY_WASM_CLOUD_LOGGING_TRACE_CONTEXT)
$(PROXY_WASM_CLOUD_LOGGING_TRACE_CONTEXT):
	@curl -sSL "https://github.com/kauche/proxy-wasm-cloud-logging-trace-context/releases/download/v${PROXY_WASM_CLOUD_LOGGING_TRACE_CONTEXT_VERSION}/proxy-wasm-cloud-logging-trace-context.wasm" \
		-o $(BIN_DIR)/proxy-wasm-cloud-logging-trace-context.wasm
	@cp $(BIN_DIR)/proxy-wasm-cloud-logging-trace-context.wasm $(PROXY_WASM_CLOUD_LOGGING_TRACE_CONTEXT)

proxy-wasm-http-header-rename.wasm: $(PROXY_WASM_HTTP_HEADER_RENAME)
$(PROXY_WASM_HTTP_HEADER_RENAME):
	@curl -sSL "https://github.com/kauche/proxy-wasm-http-header-rename/releases/download/v${PROXY_WASM_HTTP_HEADER_RENAME_VERSION}/proxy-wasm-http-header-rename.wasm" \
		-o $(BIN_DIR)/proxy-wasm-http-header-rename.wasm
	@cp $(BIN_DIR)/proxy-wasm-http-header-rename.wasm $(PROXY_WASM_HTTP_HEADER_RENAME)

.PHONY: gateway
gateway: $(CUE) proxy-wasm-google-metadata-identity-token.wasm proxy-wasm-cloud-logging-trace-context.wasm proxy-wasm-http-header-rename.wasm
	@cd ./app/platform/gateway/envoy && $(CUE) -t env=local gen

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

.PHONY: gen-proto
gen-proto: $(BUF) $(PROTOC_GEN_GO) $(PROTOC_GEN_GO_GRPC)
	@$(BUF) generate \
		--path ./api/services/commerce/proto/v1/

.PHONY: up
up: gateway
	docker compose up --detach
