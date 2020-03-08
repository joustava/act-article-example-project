#!/usr/bin/make -f

PACT_VOLUME ?= ${CURDIR}/pacts
PACT_MOCK_PORT ?= 1234

SQLITE_DATABASE_ADAPTER ?= sqlite
SQLITE_DATABASE_NAME ?= pact_broker.sqlite

integration-tests:
	cd mobile; \
	swift test --filter=IntegrationTests 2>&1 | xcpretty --simple --color

pact-consumer-tests:
	cd mobile; \
	swift test --filter=ContractTests 2>&1 | xcpretty --simple --color

# Run the node server for standalone example.
greeting-server-run:
	cd server; \
	docker build -t provider-container -f Dockerfile.dev .; \
	docker run -p 8080:8080 provider-container

pact-mock-run:
	docker run -it \
	--rm \
	--name pact-mock-service \
	-p ${PACT_MOCK_PORT}:${PACT_MOCK_PORT} \
	-v ${PACT_VOLUME}:/tmp/pacts \
	pactfoundation/pact-cli:latest \
	mock-service \
	-p ${PACT_MOCK_PORT} \
	--host 0.0.0.0 \
	--pact-dir /tmp/pacts

pact-stub-run:
	docker pull pactfoundation/pact-stub-server; \
	docker run -t -p 8083:8083 -v /Users/joustava/Workspace/spikes/pact-article-example-project/pacts/:/app/pacts pactfoundation/pact-stub-server -p 8083 -f /app/pacts/greeting_service_client-greeting_provider.json


.PHONY: test-provider-run integration-tests	pact-mock-run pact-broker-run pact-publish
