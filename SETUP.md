## Monitoring
To start prometheus + grafana, run the following command:
```
kubectl apply -f k8s-config/monitoring
```

After applying this configuration, the grafana tab will work.

## Consul
To start consul and consul-k8s, run the following command:
```
helm install k8s-config/consul
```

After applying this configuration, the consul tab will work.

## Emojify
To start the webapp, run the following command:
```
kubectl apply -f k8s-config/app
```

After applying this configuration, the emojify tab will work.