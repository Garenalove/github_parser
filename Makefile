.PHONY: docker-build test-docker run-test-docker deps 
.PHONY: docker-down build-image docker-run run compile-assets

docker-build:
	docker-compose build --force-rm --pull

test-docker: docker-build
	docker-compose \
		-f docker-compose-test.yml \
		run \
		--rm \
		--user="$$(id -u):$$(id -g)" \
		-e HOME=/tmp \
		-e MIX_ENV=test \
		app make run-test-docker; \
	TESTS_EXIT_CODE=$$?; \
	exit $$TESTS_EXIT_CODE

run-test-docker: deps
	mix test

deps:
	mix local.hex --force
	mix local.rebar --force
	mix deps.get

docker-down: 
	docker-compose down --remove-orphans --volumes --rmi local;

docker-run: build-image
	docker-compose up --abort-on-container-exit

run: deps
	mix ecto.setup
	mix phx.server

build-image: compile-assets
	docker build -f Dockerfile.rel -t github_parser:staging .

compile-assets: deps
	cd ./assets && npm install
	npm run deploy --prefix ./assets
