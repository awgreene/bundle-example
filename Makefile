build:
	podman build -t quay.io/agreene/bundle-example:$(TAG) -f ./dockerfiles/bundle.Dockerfile .
	podman push quay.io/agreene/bundle-example:$(TAG)
	opm index add --bundles quay.io/agreene/bundle-example:$(TAG) --tag quay.io/olmtest/catsrc_dynamic_resources:$(TAG)
	podman push quay.io/olmtest/catsrc_dynamic_resources:$(TAG)
	
clean:
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
