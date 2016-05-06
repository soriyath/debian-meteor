# Use the test case

## Docker
1. Install docker toolbox
2. Get the swissvm to have the localized version and time
3. Install docker-osx-dev
4. Get the image `docker pull soriyath/debian-nodejsmongodb`

## Demo data
1. Get demo data
2. Run docker-osx-dev `docker-osx-dev -s $(pwd -P)` (-P is important, symbolic links...)
2. Run the container `docker run -it -p 80:3000 -P -v $(pwd -P):/srv/www soriyath/debian-nodejsmongodb`
3. Run a bash prompt : `docker exec -it <container_name> /bin/bash`
4. Populate the mongo db.

```
use nodetest1
db.usercollection.insert({ "username" : "testuser1", "email" : "testuser1@testdomain.com" })
newstuff = [{ "username" : "testuser2", "email" : "testuser2@testdomain.com" }, { "username" : "testuser3", "email" : "testuser3@testdomain.com" }]
db.usercollection.insert(newstuff);
``

5. Install dependencies and start the server: 

```
cd /srv/www/
npm install
npm start
``` 
