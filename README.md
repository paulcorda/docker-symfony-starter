# Docker Symfony Starter
This project contains a minimal setup for a 'typical' Symfony based PHP project.  
It is based on `Docker` and `Docker Compose`.  

## Changelog
### 1.0.0
Implemented a very basic setup of php-fpm, nginx & mariadb.  

## Development
1. Install [Docker for Desktop](https://www.docker.com/products/docker-desktop) on your development machine.
2. Add the following mapping to your hosts file: ```127.0.0.1   symfony.local``` (optional)
3. Run the following command to spin up the required containers: ```$ docker-compose up -d```

### Notes
* You can define a non-versioned ```docker-compose.override.yml``` file in the project root  
to override any host-specific settings you might have over the default Compose file.
* You can enable xdebug on non-linux systems by including the following lines into your ```docker-compose.override.yml``` file:
```yaml
    app:
        volumes:
            - ./docker/app/config/debug.extra.ini:/usr/local/etc/php/conf.d/91-debug.ini:ro
```
