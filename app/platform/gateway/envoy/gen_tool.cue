package dump

import (
	"encoding/yaml"
	"tool/file"

	"github.com/kauche/kauche-microservices-example/app/platform/gateway/envoy/env/local"
)

command: gen: {
	env: =~"^(local|lab|dev|prod)$" | *_|_ @tag(env)

	bootstrap_local: local.bootstrap

	write: file.Create & {
		filename: "./env/\(env)/envoy.yaml"
		if env == "local" {
			contents: yaml.Marshal(bootstrap_local.config)
		}
		if env == "dev" {
			// ...
		}
		if env == "prod" {
			// ...
		}
	}
}
