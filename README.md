# KAUCHE Microservices Example

Let's explore the KAUCHE like microservices consist of Go, gRPC, GraphQL and Envoy **on your laptop!**

![architecture](https://github.com/kauche/kauche-microservices-example/assets/2134196/817ff9a9-b4e7-4f00-bef5-352151447e79)

## Usage

Start servers with the command below:

```sh
$ make up
```

And then, you can call KAUCHE like microservices like below:

```sh
$ curl -s -H "Host: api.kauche.localhost" -H "content-type: application/json" -d '{"query": "query { products{ id name comments{ id text customer{ id name } } } }"}' localhost:8000/query | jq .
```
