package config

import (
	"strings"
	"encoding/json"
)

#Input: {
	memory:                            number
	cloud_trace_integration?:          #CloudTraceIntegration
	cloud_logging_integration?:        #CloudLoggingIntegration
	enable_tls_for_upstream:           bool
	gcp_metadata_server_emulator_host: string | *""
	hosts: [...#Host]
	clusters: [string]: #Cluster

	_use_grpc_json_transcoding: len([ for h in hosts for r in h.routes if r.grpc_json_transcoding_config != _|_ {}]) > 0
	_use_ext_authz:             len([ for h in hosts for r in h.routes if r.ext_authz_config != _|_ {}]) > 0
}

#CloudTraceIntegration: {
	project_id: string
}

#CloudLoggingIntegration: {
	project_id: string
}

#GRPCJSONTranscodingConfig: {
	proto_descriptor: string
	services: [...string]
}

#ExtAuthzConfig: {
	cluster:           string
	with_request_body: bool | *false
}

#Host: {
	domain: string
	routes: [...#Route]
}

#Route: {
	path:                          string
	path_prefix_rewrite:           string | *""
	headers:                       [...#HeaderMatcher] | *[]
	cluster:                       string
	should_cache:                  bool | *false
	grpc_json_transcoding_config?: #GRPCJSONTranscodingConfig | null
	ext_authz_config?:             #ExtAuthzConfig | null
	request_headers_to_add: [...#HeaderToAdd]
	request_headers_to_rename: [...#HeaderToRename]
	response_headers_to_add: [...#HeaderToAdd]

	_request_headers_to_rename_json: json.Marshal({
		"request_headers_to_rename": [
			for h in request_headers_to_rename {
				{
					header: {
						key:   h.key
						value: h.value
					}
				}
			},
		]
	})
}

#Cluster: {
	name:     string
	address:  string
	port:     number
	is_http2: bool | *false
}

_#RoutePredicate: {
	domain:  string
	path:    string
	headers: [...#HeaderMatcher] | *[]

	out: and_matcher: predicate: [
		{
			single_predicate: {
				input: {
					name: "host"
					typed_config: {
						"@type":     "type.googleapis.com/envoy.type.matcher.v3.HttpRequestHeaderMatchInput"
						header_name: "host"
					}
				}
				value_match: exact: domain
			}
		},
		if len(headers) > 0 {
			for h in headers {
				single_predicate: {
					input: {
						name: strings.Join(["header", h.name], "-")
						typed_config: {
							"@type":     "type.googleapis.com/envoy.type.matcher.v3.HttpRequestHeaderMatchInput"
							header_name: h.name
						}
					}
					value_match: {
						if h.exact_match != "" {
							exact: h.exact_match
						}
					}
				}
			}
		},
		{
			single_predicate: {
				input: {
					name: "path-prefix"
					typed_config: {
						"@type":     "type.googleapis.com/envoy.type.matcher.v3.HttpRequestHeaderMatchInput"
						header_name: ":path"
					}
				}
				value_match: prefix: path
			}
		},
	]
}

#HeaderMatcher: {
	name:        string
	exact_match: string | *""
}

#HeaderToAdd: {
	key:   string
	value: string
}

#HeaderToRename: {
	key:   string
	value: string
}

#Bootstrap: {
	input: #Input

	config: {
		static_resources: {
			listeners: [{
				name: "kauche"
				address: socket_address: {
					address:    "0.0.0.0"
					port_value: 8080
				}
				per_connection_buffer_limit_bytes: 52428800 // 50 MiB
				filter_chains: [{
					filters: [{
						name: "envoy.filters.network.http_connection_manager"
						typed_config: {
							"@type":                          "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
							use_remote_address:               true
							stat_prefix:                      "ingress_http"
							codec_type:                       "AUTO"
							normalize_path:                   true
							merge_slashes:                    true
							path_with_escaped_slashes_action: "KEEP_UNCHANGED"
							common_http_protocol_options: {
								idle_timeout:                    "3600s"
								headers_with_underscores_action: "ALLOW"
							}
							request_timeout: "330s" // Must be more than Cloud Run's timeout setting.
							if input.cloud_trace_integration != _|_ {
								tracing: {
									provider: {
										name: "envoy.tracers.opencensus"
										typed_config: {
											"@type":                      "type.googleapis.com/envoy.config.trace.v3.OpenCensusConfig"
											stackdriver_exporter_enabled: true
											stackdriver_project_id:       input.cloud_trace_integration.project_id
											incoming_trace_context: ["CLOUD_TRACE_CONTEXT"]
											outgoing_trace_context: ["CLOUD_TRACE_CONTEXT"]
										}
									}
								}
							}
							access_log: {
								name: "log"
								typed_config: {
									"@type": "type.googleapis.com/envoy.extensions.access_loggers.stream.v3.StdoutAccessLog"
									log_format:
										json_format: {
											message:                           "%REQ(HOST)%%REQ(:PATH)%"
											protocol:                          "%PROTOCOL%"
											method:                            "%REQ(:METHOD)%"
											path:                              "%REQ(:PATH)%"
											host:                              "%REQ(HOST)%"
											authority:                         "%REQ(:AUTHORITY)%"
											user_agent:                        "%REQ(USER-AGENT)%"
											status:                            "%RESPONSE_CODE%"
											severity:                          "INFO"
											component:                         "api-gateway-envoy"
											duration:                          "%DURATION%"
											upstream_cluster:                  "%UPSTREAM_CLUSTER%"
											bytes_received:                    "%BYTES_RECEIVED%"
											bytes_sent:                        "%BYTES_SENT%"
											request_id:                        "%REQ(X-REQUEST-ID)%"
											response_flags:                    "%RESPONSE_FLAGS%"
											response_code_details:             "%RESPONSE_CODE_DETAILS%"
											connection_termination_details:    "%CONNECTION_TERMINATION_DETAILS%"
											upstream_request_attempt_count:    "%UPSTREAM_REQUEST_ATTEMPT_COUNT%"
											upstream_transport_failure_reason: "%UPSTREAM_TRANSPORT_FAILURE_REASON%"
											if input.cloud_logging_integration != _|_ {
												"logging.googleapis.com/trace": "%REQ(x-cloud-logging-trace-context)%"
											}
										}
								}
							}
							http_filters: [
								if input.cloud_logging_integration != _|_ {
									{
										name: "envoy.filters.http.wasm"
										typed_config: {
											"@type":  "type.googleapis.com/udpa.type.v1.TypedStruct"
											type_url: "type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm"
											value: {
												config: {
													vm_config: {
														runtime: "envoy.wasm.runtime.v8"
														code: local: filename: "/etc/envoy/proxy-wasm-cloud-logging-trace-context.wasm"
													}
													configuration: {
														"@type": "type.googleapis.com/google.protobuf.StringValue"
														value:   """
														{
															"project_id": "\(input.cloud_logging_integration.project_id)"
														}
														"""
													}
												}
											}
										}
									}
								},
								if input._use_ext_authz {
									{
										name: "ext-authz"
										typed_config: {
											"@type": "type.googleapis.com/envoy.extensions.common.matching.v3.ExtensionWithMatcher"
											extension_config: {
												name: "composite"
												typed_config: "@type": "type.googleapis.com/envoy.extensions.filters.http.composite.v3.Composite"
											}
											xds_matcher: matcher_list: matchers: [
												for host in input.hosts for route in host.routes if route.ext_authz_config != _|_ {
													{
														predicate: (_#RoutePredicate & {
															domain:  host.domain
															path:    route.path
															headers: route.headers
														}).out
														on_match: action: {
															name: "composite-action"
															typed_config: {
																"@type": "type.googleapis.com/envoy.extensions.filters.http.composite.v3.ExecuteFilterAction"
																typed_config: {
																	name: "ext_authz"
																	typed_config: {
																		"@type":  "type.googleapis.com/udpa.type.v1.TypedStruct"
																		type_url: "type.googleapis.com/envoy.extensions.filters.http.ext_authz.v3.ExtAuthz"
																		value: {
																			grpc_service: {
																				envoy_grpc: {
																					cluster_name: route.ext_authz_config.cluster
																					authority:    input.clusters[route.ext_authz_config.cluster].address
																				}
																			}
																			transport_api_version: "V3"
																			failure_mode_allow:    false
																			if route.ext_authz_config.with_request_body {
																				with_request_body: {
																					max_request_bytes:     8192 // 8 MiB
																					allow_partial_message: false
																					pack_as_bytes:         true
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												},
											]
										}
									}
								},
								if input._use_grpc_json_transcoding {
									{
										name: "grpc-json-transcoding"
										typed_config: {
											"@type": "type.googleapis.com/envoy.extensions.common.matching.v3.ExtensionWithMatcher"
											extension_config: {
												name: "composite"
												typed_config: "@type": "type.googleapis.com/envoy.extensions.filters.http.composite.v3.Composite"
											}
											xds_matcher: matcher_list: matchers: [
												for host in input.hosts for route in host.routes if route.grpc_json_transcoding_config != _|_ {
													{
														predicate: (_#RoutePredicate & {
															domain:  host.domain
															path:    route.path
															headers: route.headers
														}).out
														on_match: action: {
															name: "composite-action"
															typed_config: {
																"@type": "type.googleapis.com/envoy.extensions.filters.http.composite.v3.ExecuteFilterAction"
																typed_config: {
																	name: "grpc_json_transcoding"
																	typed_config: {
																		"@type":  "type.googleapis.com/udpa.type.v1.TypedStruct"
																		type_url: "type.googleapis.com/envoy.extensions.filters.http.grpc_json_transcoder.v3.GrpcJsonTranscoder"
																		value: {
																			proto_descriptor: route.grpc_json_transcoding_config.proto_descriptor
																			services:         route.grpc_json_transcoding_config.services
																			print_options: {
																				add_whitespace:                false
																				always_print_primitive_fields: true
																				always_print_enums_as_ints:    false
																				preserve_proto_field_names:    true
																				stream_newline_delimited:      false
																			}
																			match_incoming_request_route:    true
																			auto_mapping:                    false
																			ignore_unknown_query_parameters: true
																			convert_grpc_status:             true
																			request_validation_options: {
																				reject_unknown_method:                true
																				reject_unknown_query_parameters:      true
																				reject_binding_body_field_collisions: true
																			}
																		}
																	}
																}
															}
														}
													}
												},
											]
										}
									}
								},
								{
									name: "envoy.filters.http.router"
									typed_config: "@type": "type.googleapis.com/envoy.extensions.filters.http.router.v3.Router"
								},
							]
							route_config: virtual_hosts: [
								for host in input.hosts {
									name: host.domain
									domains: [
										host.domain,
									]
									routes: [
										for r in host.routes {
											match: {
												prefix: r.path
												if len(r.headers) > 0 {
													headers: [
														for h in r.headers {
															{
																name: h.name
																if h.exact_match != "" {
																	exact_match: h.exact_match
																}
															}
														},
													]
												}
											}
											route: {
												cluster: r.cluster
												if r.path_prefix_rewrite != "" {
													prefix_rewrite: r.path_prefix_rewrite
												}

												timeout:           "330s" // Must be more than Cloud Run's timeout setting.
												auto_host_rewrite: true
												retry_policy: {
													retry_on:    "reset"
													num_retries: 1
													retriable_status_codes: [
														503,
													]
												}
											}
											if len(r.request_headers_to_add) > 0 {
												request_headers_to_add: [
													for h in r.request_headers_to_add {
														header: {
															key:   h.key
															value: h.value
														}
														append_action:    "OVERWRITE_IF_EXISTS_OR_ADD"
														keep_empty_value: "false"
													},
												]
											}
											if !r.should_cache || len(r.response_headers_to_add) > 0 {
												response_headers_to_add: [
													for h in r.response_headers_to_add {
														header: {
															key:   h.key
															value: h.value
														}
														append_action:    "OVERWRITE_IF_EXISTS_OR_ADD"
														keep_empty_value: "false"
													},
													if !r.should_cache {
														header: {
															key: "Cache-Control"
															// Use kitchen-sink headers in order to fully disable the chache.
															// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching#shared_cache
															value: "no-store, no-cache, max-age=0, must-revalidate, proxy-revalidate"
														}
														append_action:    "OVERWRITE_IF_EXISTS_OR_ADD"
														keep_empty_value: "false"
													},
												]
											}
										},
									]
								},
							]
						}
					}]
				}]
			}]

			clusters: [
				for key, cluster in input.clusters {
					name:                              key
					per_connection_buffer_limit_bytes: 52428800
					if cluster.is_http2 {
						http2_protocol_options: {}
					}
					connect_timeout:   "1.00s"
					dns_lookup_family: "V4_ONLY"
					type:              "STRICT_DNS"
					lb_policy:         "ROUND_ROBIN"
					load_assignment: {
						cluster_name: key
						endpoints: [{
							lb_endpoints: [{
								endpoint: address: socket_address: {
									address:    cluster.address
									port_value: cluster.port
								}
							}]
						}]
					}
					if input.enable_tls_for_upstream {
						transport_socket: {
							name: "envoy.transport_sockets.tls"
							typed_config: {
								"@type": "type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext"
								common_tls_context: validation_context: trusted_ca: filename: "/etc/ssl/certs/ca-certificates.crt"
								sni: cluster.address
							}
						}
					}
				},
			]
		}

		admin: {
			address: socket_address: {
				address:    "127.0.0.1"
				port_value: 15000
			}
		}

		overload_manager: {
			refresh_interval: "0.25s"
			resource_monitors: [
				{
					name: "envoy.resource_monitors.fixed_heap"
					typed_config: {
						"@type":             "type.googleapis.com/envoy.extensions.resource_monitors.fixed_heap.v3.FixedHeapConfig"
						max_heap_size_bytes: input.memory
					}
				},
			]
			actions: [
				{
					name: "envoy.overload_actions.shrink_heap"
					triggers: [
						{
							name: "envoy.resource_monitors.fixed_heap"
							threshold: value: 0.95
						},
					]
				},
				{
					name: "envoy.overload_actions.stop_accepting_requests"
					triggers: [
						{
							name: "envoy.resource_monitors.fixed_heap"
							threshold: value: 0.98
						},
					]
				},
			]
		}

		layered_runtime: layers: [{
			name: "static_layer"
			static_layer: {
				envoy: resource_limits: listener: kauche: connection_limit: 10000
				overload: {
					global_downstream_max_connections: 50000
				}
			}
		}]
	}
}
