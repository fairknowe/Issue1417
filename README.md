
### Demonstration of Shopify app install issue using Rails and the shopify_app API
#### See [https://github.com/Shopify/shopify_app/issues/1417](https://github.com/Shopify/shopify_app/issues/1417)

**This repository provides instructions on building a Docker container and a Shopify public embedded app, named "embed", to illustrate a browser-related issue with the app install.**

*This demonstration was developed using Docker Desktop Version 4.7.1 running on MacOS Version 10.15.7. Container software versions are below.*

**Required:**

1. An ngrok.yml file at the repository root, containing:

> authtoken: [your ngrok auth token]
>
> web_addr: 0.0.0.0:4041

2. A Shopify Partner account and development store. See [here](https://shopify.dev/apps/getting-started/create).

**Instructions:**

1. Copy `Dockerfile` to your local machine.
2. Make a directory named "dev" in the same place as the Dockefile.
1. Run `docker build -t mbed_image:dev --progress plain -f Dockerfile .`
2. Run `docker run -dit --name mbed_container -p 3000:3000 -p 3456:3456 -p 4041:4041 --mount type=bind,src=$PWD/dev,dst=/usr/dev --restart no mbed_image:dev`
3. Run `docker exec -it mbed_container /bin/bash`

At the container bash prompt:

4. Run `shopify login`
5. Run `shopify app create rails --name=mbed --db=sqlite3`
[NOTE: Choose to build a Public app, and select a development store that has some products]
6. Run `cd mbed`
7. Run `shopify app serve`

8. Using Chrome, install "mbed" app in the development store. Note that install completes and the store app admin iframe lists the store products. Uninstall app.

9. Using Safari, install "mbed" app in the development store. Note that during the install process the admin iframe switches to a full browser window, and stalls there; products are not listed. Navigate to the store admin/apps and see that the app is installed. Click on the app and note that the products are not listed. Uninstall app.

10. Using a Firefox private window, install "mbed" app in the development store. Note that during the install process the admin iframe switches to a full browser window, and stalls there; products are not listed. Navigate to the store admin/apps and see that the app is installed. Click on the app and note that the products are not listed.

**Container software**
- `Debian 11 (bullseye)`
- `Ruby 3.1.2p20`
- `Rails 7.0.2.3`
- `Node.js v17.9.0`
- `shopify-cli 2.15.6`
- `shopify_api 10.0.2`
- `shopify_app 19.0.1`