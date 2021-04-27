#! make

IMAGE=sbdi/mirroreum

.PHONY: all release start

logos:
	./hexsticker.R

all: build start-ide

build:
	docker build -t $(IMAGE) .

release:
	docker login
	docker push $(IMAGE)

start-ide:
	docker run -d --name mywebide \
		--env ROOT=true \
		--env USER=rstudio \
		--env PASSWORD=mirroreum \
		--env USERID=$$(id -u) \
		--env GROUPID=$$(id -g) \
		--publish 8787:8787 \
		--volume $$HOME/.Renviron:/home/rstudio/.Renviron \
		--volume $$(pwd)/login.html:/etc/rstudio/login.html:ro \
		--volume $$(pwd)/rserver.conf:/etc/rstudio/rserver.conf \
		--volume $$(pwd)/home:/home/rstudio/home \
		$(IMAGE) /init
#		--user $$(id -u):$$(id -g) \

clean-ide:
	@docker stop mywebide
	@docker rm mywebide
