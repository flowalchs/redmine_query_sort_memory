# Redmine Query Sort Memory

Remembers the sort order selected in a saved query, for each user.

In Redmine, selecting a saved query always applies the sort order defined in
the query. If you sort the list differently by clicking on a column header and
then switch to another query, your sort order is lost when you come back.

With this plugin, each saved query remembers the sort order you selected:

1. Select a saved query and sort the list by clicking on a column header.
2. Switch to other queries.
3. When you select the first query again, your sort order is used.

Queries that you never sorted manually keep their own sort order. Other users
are not affected and still get the sort order of the query.

The remembered sort order is also used when going back to the issue list and
for the Previous/Next links and the "x of y" link on the issue page.

## Features

* One remembered sort order per saved query and user
* Storage of the sort orders, configurable in the plugin settings:
  * **Session (until logout)**: the sort orders are only kept in the session
  * **User preference, cleared at login**: the sort orders are kept in the
    user preference until the next login
  * **User preference, kept**: the sort orders are kept permanently
* Maximum number of remembered queries per user (default: 10). Only the sort
  orders of the most recently sorted queries are kept.
* "Reset sort order" link in the sidebar of the issue list, shown when the
  current query has a remembered sort order
* Sorting the list by the sort order of the query also forgets the remembered
  sort order
* API requests are not affected
* No database migration and no additional gems

## Requirements

* Redmine 6.0 or higher

The plugin does not require the Redmine fix from
[#44667](https://www.redmine.org/issues/44667), but works with it.

## Installation

```
cd /path/to/redmine/plugins
git clone https://github.com/flowalchs/redmine_query_sort_memory.git
```

Restart Redmine. No database migration is needed.

Configure the plugin in *Administration » Plugins » Redmine Query Sort Memory
» Configure*.

## Uninstallation

Remove the `plugins/redmine_query_sort_memory` directory and restart Redmine.

## Running the tests

```
bin/rails test plugins/redmine_query_sort_memory/test
```

## Background

See [#44406](https://www.redmine.org/issues/44406) on redmine.org.

## License

MIT, see [LICENSE](LICENSE).
