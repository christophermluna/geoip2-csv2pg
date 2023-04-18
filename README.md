# 🔎 MaxMind CSV to Pg

The purpose of this repository is to make it easy to import MaxMind's
GeoLite2/GeoIP2 CSV databases into a local Docker 🐳 container which is running
PostgreSQL. This is meant to provide an easy way to query the CSV data in
PostgreSQL. It's not meant as a solution to deploy to production.

## Step 1: Download the databases

Before you get started, edit the `DATABASES` variable in
`bin/download/download-db.sh`. The currently tested list of databases is:
`"GeoIP2-Anonymous-IP" "GeoLite2-City" "GeoIP2-Enterprise"`. Once you are happy
with this list you are ready to build the container.

### Build the Docker container which runs the downloader

```text
./bin/download/docker-build.sh
```

Run the following script, replacing the word `SEEKRIT` with a MaxMind license
key.

```text
MM_LICENSE_KEY=SEEKRIT ./bin/download/docker-run.sh
```

You may run this script as often as you like. It will download a database if
none exists locally or if there is a newer version available to download.

## Step 2: Build Your Docker Image

```text
./bin/docker-build.sh
```

## Step 3: Run Your Docker Image

```text
./bin/docker-run.sh
```

## Step 4: Connect to PostgreSQL

If you have `psql` installed locally, use this command. When prompted for your password, enter "foo".

```text
./bin/psql.sh
```

If you'd rather connect without a wrapper script, you can do something like:


```text
psql -h localhost -U root -d mm_database
```

If you'd like to connect to the Docker container directly, get the Docker
container ID by running `docker ps`. You can then use the id in the following
command:

```text
docker exec --rm -it CONTAINER_ID bash
```

Once you're inside the container, use the same command as above:

```text
psql -h localhost -U root -d mm_database
```
