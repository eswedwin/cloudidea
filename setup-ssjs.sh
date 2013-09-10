#!/bin/bash
# Install node packages from packages.json in app-directory
npm install

echo -e "\n\nNOW ENTER YOUR HEROKU PASSWORD"
# Set up heroku.
# - devcenter.heroku.com/articles/config-vars
# - devcenter.heroku.com/articles/heroku-postgresql
heroku login
#3 lines below when fresh ec2
#heroku create
#ssh-keygen -t rsa
#heroku keys:add
#staging
heroku addons:add heroku-postgresql:dev --app eswedwin-bitstarter-s-mooc
heroku pg:promote `heroku config  --app eswedwin-bitstarter-s-mooc | grep HEROKU_POSTGRESQL | cut -f1 -d':'` --app eswedwin-bitstarter-s-mooc
heroku plugins:install git://github.com/ddollar/heroku-config.git --app eswedwin-bitstarter-s-mooc
#production
heroku addons:add heroku-postgresql:dev --app eswedwin-bitstarter-mooc
heroku pg:promote `heroku config  --app eswedwin-bitstarter-mooc | grep HEROKU_POSTGRESQL | cut -f1 -d':'` --app eswedwin-bitstarter-mooc
heroku plugins:install git://github.com/ddollar/heroku-config.git --app eswedwin-bitstarter-mooc

# Set up heroku configuration variables
# https://devcenter.heroku.com/articles/config-vars
# - Edit .env to include your own COINBASE_API_KEY and HEROKU_POSTGRES_URL.
# - Modify the .env.dummy file, and DO NOT check .env into the git repository.
# - See .env.dummy for details.
cp .env.dummy .env

# For local: setup postgres (one-time) and then run the local server
./pgsetup.sh

STRING=$( cat <<EOF
Great. You've now set up local and remote postgres databases for your
app to talk to.\n\n   Now do the following:\n\n

1) Get your API key from coinbase.com/account/integrations\n\n
2) Paste it into the .env file.\n\n
3) To run the server locally, do:\n
     $ foreman start\n
4) To deploy to heroku\n
heroku config:push --app eswedwin-bitstarter-s-mooc
heroku config:push --app eswedwin-bitstarter-mooc
   Try placing some orders and then clicking '/orders' at the top.\n
EOF
)
echo -e $STRING
