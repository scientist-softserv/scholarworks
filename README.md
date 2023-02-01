# CSU ScholarWorks

## Getting Started

### Using Docker

#### Install Docker
Download [Docker Desktop](https://www.docker.com/products/docker-desktop) and log in

### Install Dory

On OS X or Linux we recommend running [Dory](https://github.com/FreedomBen/dory). It acts as a proxy allowing you to access domains locally such as app.test or tenant.app.test, making multitenant development more straightforward and prevents the need to bind ports locally. Be sure to [adjust your ~/.dory.yml file to support the .test tld](https://github.com/FreedomBen/dory#config-file).

```bash
gem install dory
```

_You can still run in development via docker with out Dory, but to do so please uncomment the ports section in docker-compose.yml_

#### Clone the repository

```
git clone https://github.com/csuscholarworks/scholarworks.git
cd scholarworks
```

#### Build Docker containers

```
docker compose build
```

#### Start Dory and Docker containers

```
dory up
docker compose up
```

#### Run commands inside the container

To execute commands inside of the web container

```
docker compose exec web bash
```

### Without Docker

Install Ruby, Java, Postgres, etc., [prerequisites from Hyrax](https://github.com/samvera/hyrax).

Create a database and user using the development settings in `config/database.yml`

```
git clone https://github.com/csuscholarworks/scholarworks.git
cd scholarworks
vi .solr_wrapper      // change solr version to 6.6.1, uncomment port
bundle install
rails db:migrate RAILS_ENV=development
rails hydra:server
```

launch new ssh window

```
rails hyrax:default_admin_set:create
rails hyrax:default_collection_types:create
rails hyrax:migrate:add_collection_type_and_permissions_to_collections
```

Register a new user in Hyrax. And make that user an administrator.

`rails c`
```
admin = Role.create(name: 'admin')
admin.users << User.find_by_user_key('your_admin_users_email@fake.email.org')
admin.save
```

## Campus-based Submissions

First, remove all depositors from the default admin set.  This way users can only deposit into a specific campus admin set and only see that option in the 'relationships' tab when depositing.

Create a new admin set and give it the name 'Stanislaus'. Add the group 'stanislaus' as depositor. Create a new user 'test@stanislaus.edu'.

That user should now be able to deposit into the Staniaus admin set, and all submissions will use Stanislaus controlled vocabularies and have the campus field set to 'Stanislaus'.

Other campuses and users can be created for dev/test in this same way.  See `app\models\ability.rb` for mapping.

## DSpace Import

The packager:aip rake task performs the basic functions of importing [DSpace AIP packages](https://wiki.lyrasis.org/display/DSDOC5x/DSpace+AIP+Format) into Hyrax.  The rake task takes two arguments: the campus identifier and the name of the AIP package.  Here's an example for Channel Islands:

```
bundle exec rake packager:aip[channel,COLLECTION@10139-722.zip]
```

The campus identifier corresponds to the name of the config file in `config/packager`, so in this example `config/packager/channel.yml`.  That includes configurations for where the AIP packages are located, various fixed metadata elements, and a metadata mapping of DSpace fields to those in Hyrax.

The AIP package can be for a single item, or more typically for an entire DSpace collection or community.

# Branching

## Quick Legend

<table>
  <thead>
    <tr>
      <th>Instance</th>
      <th>Branch</th>
      <th>Description, Instructions, Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Production</td>
      <td>production</td>
      <td>Accepts merges from Working and Hotfixes</td>
    </tr>
    <tr>
      <td>Working</td>
      <td>master</td>
      <td>Accepts merges from Features/Issues and Hotfixes</td>
    </tr>
    <tr>
      <td>Features</td>
      <td>feature-*</td>
      <td>Always branch off HEAD of Working</td>
    </tr>
    <tr>
      <td>Issues</td>
      <td>bug-*</td>
      <td>Always branch off HEAD of Working</td>
    </tr>
    <tr>
      <td>Hotfix</td>
      <td>hotfix-*</td>
      <td>Always branch off Production</td>
    </tr>
  </tbody>
</table>

## Main Branches

The main repository will always hold two evergreen branches:

* `master`
* `production`

The main branch should be considered `origin/master` and will be the main branch where the source code of `HEAD` always reflects a state with the latest delivered development changes for the next release. As a developer, you will be branching and merging from `master`.

Consider `origin/production` to always represent the latest code deployed to production. During day to day development, the `production` branch will not be interacted with.

When the source code in the `master` branch is stable and has been deployed, all of the changes will be merged into `production` and tagged with a release number. *How this is done in detail will be discussed later.*

## Supporting Branches

Supporting branches are used to aid parallel development between team members, ease tracking of features, and to assist in quickly fixing live production problems. Unlike the main branches, these branches always have a limited life time, since they will be removed eventually.

The different types of branches we may use are:

* Feature branches
* Bug branches
* Hotfix branches

Each of these branches have a specific purpose and are bound to strict rules as to which branches may be their originating branch and which branches must be their merge targets. Each branch and its usage is explained below.

### Feature Branches

Feature branches are used when developing a new feature or enhancement which has the potential of a development lifespan longer than a single deployment. When starting development, the deployment in which this feature will be released may not be known. No matter when the feature branch will be finished, it will always be merged back into the master branch.

During the lifespan of the feature development, the lead should watch the `master` branch (network tool or branch tool in GitHub) to see if there have been commits since the feature was branched. Any and all changes to `master` should be merged into the feature before merging back to `master`; this can be done at various times during the project or at the end, but time to handle merge conflicts should be accounted for.

`<tbd number>` represents the project to which Project Management will be tracked.

* Must branch from: `master`
* Must merge back into: `master`
* Branch naming convention: `feature-<tbd number>`

#### Working with a feature branch

If the branch does not exist yet (check with the Lead), create the branch locally and then push to GitHub. A feature branch should always be 'publicly' available. That is, development should never exist in just one developer's local branch.

```
$ git checkout -b feature-id master                 // creates a local branch for the new feature
$ git push origin feature-id                        // makes the new feature remotely available
```

Periodically, changes made to `master` (if any) should be merged back into your feature branch.

```
$ git merge master                                  // merges changes from master into feature branch
```

When development on the feature is complete, the lead (or engineer in charge) should merge changes into `master` and then make sure the remote branch is deleted.

```
$ git checkout master                               // change to the master branch  
$ git merge --no-ff feature-id                      // makes sure to create a commit object during merge
$ git push origin master                            // push merge changes
$ git push origin :feature-id                       // deletes the remote branch
```

### Bug Branches

Bug branches differ from feature branches only semantically. Bug branches will be created when there is a bug on the live site that should be fixed and merged into the next deployment. For that reason, a bug branch typically will not last longer than one deployment cycle. Additionally, bug branches are used to explicitly track the difference between bug development and feature development. No matter when the bug branch will be finished, it will always be merged back into `master`.

Although likelihood will be less, during the lifespan of the bug development, the lead should watch the `master` branch (network tool or branch tool in GitHub) to see if there have been commits since the bug was branched. Any and all changes to `master` should be merged into the bug before merging back to `master`; this can be done at various times during the project or at the end, but time to handle merge conflicts should be accounted for.

`<tbd number>` represents the Basecamp project to which Project Management will be tracked.

* Must branch from: `master`
* Must merge back into: `master`
* Branch naming convention: `bug-<tbd number>`

#### Working with a bug branch

If the branch does not exist yet (check with the Lead), create the branch locally and then push to GitHub. A bug branch should always be 'publicly' available. That is, development should never exist in just one developer's local branch.

```
$ git checkout -b bug-id master                     // creates a local branch for the new bug
$ git push origin bug-id                            // makes the new bug remotely available
```

Periodically, changes made to `master` (if any) should be merged back into your bug branch.

```
$ git merge master                                  // merges changes from master into bug branch
```

When development on the bug is complete, [the Lead] should merge changes into `master` and then make sure the remote branch is deleted.

```
$ git checkout master                               // change to the master branch  
$ git merge --no-ff bug-id                          // makes sure to create a commit object during merge
$ git push origin master                            // push merge changes
$ git push origin :bug-id                           // deletes the remote branch
```

### Hotfix Branches

A hotfix branch comes from the need to act immediately upon an undesired state of a live production version. Additionally, because of the urgency, a hotfix is not required to be be pushed during a scheduled deployment. Due to these requirements, a hotfix branch is always branched from a tagged `production` branch. This is done for two reasons:

* Development on the `master` branch can continue while the hotfix is being addressed.
* A tagged `production` branch still represents what is in production. At the point in time where a hotfix is needed, there could have been multiple commits to `master` which would then no longer represent production.

`<tbd number>` represents the Basecamp project to which Project Management will be tracked.

* Must branch from: tagged `production`
* Must merge back into: `master` and `production`
* Branch naming convention: `hotfix-<tbd number>`

#### Working with a hotfix branch

If the branch does not exist yet (check with the Lead), create the branch locally and then push to GitHub. A hotfix branch should always be 'publicly' available. That is, development should never exist in just one developer's local branch.

```
$ git checkout -b hotfix-id production              // creates a local branch for the new hotfix
$ git push origin hotfix-id                         // makes the new hotfix remotely available
```

When development on the hotfix is complete, [the Lead] should merge changes into `production` and then update the tag.

```
$ git checkout production                           // change to the production branch
$ git merge --no-ff hotfix-id                       // forces creation of commit object during merge
$ git tag -a <tag>                                  // tags the fix
$ git push origin production --tags                 // push tag changes
```

Merge changes into `master` so not to lose the hotfix and then delete the remote hotfix branch.

```
$ git checkout master                               // change to the master branch
$ git merge --no-ff hotfix-id                       // forces creation of commit object during merge
$ git push origin master                            // push merge changes
$ git push origin :hotfix-id                        // deletes the remote branch
```