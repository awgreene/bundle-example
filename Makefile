build:
	docker build -t quay.io/agreene/bundle-example:$(TAG) -f ./dockerfiles/prom.bundle.Dockerfile .
	docker push quay.io/agreene/bundle-example:$(TAG)
	opm index add --permissive --generate -b quay.io/agreene/bundle-example:$(TAG)
	docker build -t quay.io/agreene/bundle-index:$(TAG) -f ./dockerfiles/prom.index.Dockerfile .
	docker push quay.io/agreene/bundle-index:$(TAG)
	$(MAKE) clean

clean:
	rm bundle.tar
	rm index.Dockerfile

run-local:
	kubectl apply -f ./deploy

install-crds:
	kubectl apply -f crds/servicemonitor.crd.yaml
	kubectl apply -f crds/prometheusrule.crd.yaml

uninstall:
	kubectl delete subscription my-subscription
	kubectl delete catsrc my-catalogsource
	kubectl delete csv prometheusoperator.0.14.0
	kubectl delete servicemonitor my-servicemonitor
	kubectl delete prometheusrule my-prometheusrule
