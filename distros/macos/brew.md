# Homebrew

## Auto update

Automatically update Homebrew every 24 hours (or given number of
seconds), upgrade formulae and casks (`--upgrade`), and clean cache and
logs (`--cleanup`):

```sh
brew autoupdate start --upgrade --cleanup
```

View current status:

```sh
brew autoupdate status
```

## Analytics

Homebrew [collects analytics](https://docs.brew.sh/Analytics) via Google
Analytics.

Opt out of analytics:

```sh
export HOMEBREW_NO_ANALYTICS=1
```

Alternatively, prevent analytics from ever being sent:

```sh
brew analytics off
```

View all analytics sent (also stops any analytics from being sent):

```sh
export HOMEBREW_ANALYTICS_DEBUG=1
```
