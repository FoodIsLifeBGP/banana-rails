# THE BANANA APP: Ruby on Rails/Postgres backend

Banana App is an open-source, not-for-profit project of The Be Good Foundation.  We can reduce hunger by simplifying food donation.  We make it easy for grocery stores and restaurants to donate good food that would otherwise be disposed of.  Users will be able to find active donations, view the business's food rating, and claim a portion.

# Installation (Mac/OSX)

All of The Banana App family (Donor, Client, & Admin) runs off of this backend.  Install this first.

The following commands in Terminal will install:
- GPG
- RVM
- Ruby 2.6.3
- Rails
- Postgres

You'll need [Homebrew](https://docs.brew.sh/Installation) to install GPG.

- `brew install gnupg`
- `gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB`
- `\curl -sSL https://get.rvm.io | bash`
- `rvm install 2.6.3 && rvm use 2.6.3`
- `gem install rails`
- `gem install pg`

Install Postgres by following the instructions on https://postgresapp.com/.

Back in Terminal, run
- `git clone https://github.com/256hz/banana-rails.git && cd banana-rails`

From inside `banana-rails`, run:
- `bundle` (package installer)
- `rails db:setup` (creates, migrates, and seeds your local DB)
and finally
- `rails s`
to start the server.  Once that's running, your terminal should look something like:

```terminal
=> Booting Puma
=> Rails 6.0.0 application starting in development 
=> Run `rails server --help` for more startup options
Puma starting in single mode...
* Version 3.12.1 (ruby 2.6.3-p62), codename: Llamas in Pajamas
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://localhost:3000
Use Ctrl-C to stop
```

Once you see that, open a web browser, and navigate to `http://localhost:3000`.  If you see this:

```json
{
	"message": "Please log in."
}
```

You're done!  You can now move on to installing the Donor, Client, or Admin apps at the following URLs:

## [Donor/Client](https://github.com/FoodIsLifeBGP/banana-rn)

## Admin: TBD

# Endpoints

## Complete:
- admin_auth/create
- donor_auth/create
- client_auth/create

- client/create
- client/update

- donor/create
- donor/get
- donor/scan -- complete a claim scanned from the donor frontend app

- claims/update -- client cancels donation, or donor marks as claimed
- client/get_donations (by location) -- client searching for nearby donations, and getting donation detail (should be moved to donations controller)

- donations/create -- donor listing a donation
- donations/update -- donor updating donation info
- donations/get_donations (active, by user) -- donor seeing their donation list
- donations/:id/claim -- client creates a claim on a donation

### To do:
- donor/account_status --> donor/update
- client/get_claims -- client pulling up their current claims and QR code info
- push notifications
