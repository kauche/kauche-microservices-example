package local

import "github.com/kauche/kauche-microservices-example/app/platform/gateway/envoy/config"

_project_id: "my-projectid"

bootstrap: config.#Bootstrap & {
	input: config.#Input & {
		memory: 536870912

		enable_tls_for_upstream: false

		gcp_metadata_server_emulator_host: "gcp-metadata-server"

		cloud_logging_integration: {
			project_id: _project_id
		}

		hosts: [
			config.#Host & {
				domain: "api.kauche.localhost"
				routes: [
					config.#Route & {
						path:    "/"
						cluster: "customer-graph"
					},
				]
			},
		]

		clusters: {
			"customer-graph": config.#Cluster & {
				address: "customer-graph"
				port:    8080
			}
		}
	}
}
