# errorpage

- öncesinde uygulama erişilememesi durumunda, custombackend servisine yönlendirmek için özel imajlı deployment ve ilgili servisi yüklenecek.

````bash
cd deploy
k apply -f deployment.yaml
````

- daha sonra kubernetes cluster'a ingress-nginx yüklendikten sonra ingress-nginx deployment'ı edit edilip ilgili parametre eklenecek

````bash
k edit -n nginx deploy ingress-nginx-controller
# output
spec:
      containers:
      - args:
        - /nginx-ingress-controller
        - --publish-service=$(POD_NAMESPACE)/ingress-nginx-controller
        - --election-id=ingress-nginx-leader
        - --controller-class=k8s.io/ingress-nginx
        - --ingress-class=nginx
        - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
        - --validating-webhook=:8443
        - --validating-webhook-certificate=/usr/local/certificates/cert
        - --validating-webhook-key=/usr/local/certificates/key
        - --enable-metrics=false
        - --default-backend-service=default/error-page # gelmesini istediğimiz sayfanın uygulama namespace/servicename eklenecek en alt satıra
````
- ingress yaml dosyasında aşağıdaki annotations ile defaultbackend bloğu eklenecek

````bash
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_pass_header RefreshToken;
      proxy_set_header RefreshToken $http_refreshtoken;
    nginx.ingress.kubernetes.io/custom-http-errors: "400,401,402,403,404,405,406,415,501,502,503,504,505"

spec:
  defaultBackend:
    service:
      name: error-page
      port:
        number: 80
````