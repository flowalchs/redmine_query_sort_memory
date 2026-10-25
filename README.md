# Redmine Query Sort Memory Plugin

[![build](https://github.com/flowalchs/redmine_query_sort_memory/actions/workflows/build.yml/badge.svg)](https://github.com/flowalchs/redmine_query_sort_memory/actions/workflows/build.yml)
[![Last release](https://img.shields.io/github/v/release/flowalchs/redmine_query_sort_memory?label=latest%20release&logo=github&style=flat-square)](https://github.com/flowalchs/redmine_query_sort_memory/releases/latest)
[![Rate at redmine.org](http://img.shields.io/badge/rate%20at-redmine.org-blue.svg?style=flat-square)](https://www.redmine.org/plugins/redmine_query_sort_memory)
[![Redmine](https://img.shields.io/badge/redmine->=6.0-blue?logo=redmine&logoColor=%23B32024&labelColor=f0f0f0)](https://www.redmine.org)
[![codecov](https://codecov.io/gh/flowalchs/redmine_query_sort_memory/graph/badge.svg)](https://codecov.io/gh/flowalchs/redmine_query_sort_memory)

This plugin remembers the sort order selected in a saved query, for each user. When you sort a saved query by clicking on a column header, switch to other queries and come back later, your sort order is used again instead of the sort order defined in the query.

## 🧠 How it works

In Redmine, selecting a saved query always applies the sort order defined in the query. This plugin keeps the sort order you selected yourself:

- **One sort order per query**: Each saved query remembers the sort order you selected by clicking on a column header.
- **Your own sort order only**: Queries that you never sorted manually keep the sort order defined in the query.
- **Per user**: Other users are not affected and still get the sort order of the query, also for public and global queries.
- **Consistent navigation**: The remembered sort order is also used when going back to the issue list and for the Previous/Next links and the "x of y" link on the issue page.
- **No database changes**: The sort orders are stored in the session or in the user preference. No migration is needed.

## 🌟 Features

- **Remembered sort order per saved query and user**
- **Configurable storage** – Keep the sort orders in the session, in the user preference until the next login, or permanently in the user preference
- **Limited number of queries** – Only the sort orders of the most recently sorted queries are kept (default: 10)
- **Reset link** – "Reset sort order" in the sidebar of the issue list, shown when the current query has a remembered sort order
- **Automatic reset** – Sorting the list by the sort order of the query forgets the remembered sort order
- **REST API unaffected** – API requests always use the sort order of the query
- **No additional gems and no migration**

## 💡 Typical Use Case

An issue passes through several saved queries until it is done, e.g. "New", "In progress", "Review" and "Done":

1. Select the query "In progress" and sort it by "Updated", descending
2. Switch to the query "Review" and sort it by "Priority"
3. Switch back to "In progress": the list is sorted by "Updated" again
4. Switch back to "Review": the list is sorted by "Priority" again

## ⚙️ Plugin Configuration

Configure the plugin under **Administration → Plugins → Redmine Query Sort Memory → Configure**:

| Setting                        | Description                                                                                       |
| ------------------------------ | ------------------------------------------------------------------------------------------------- |
| Storage of the sort orders     | **Session (until logout)** (default), **User preference, cleared at login** or **User preference, kept** |
| Remembered queries per user    | Maximum number of queries whose sort order is remembered (default: 10)                            |

The session of Redmine is stored in a cookie with a limited size. The sort orders are stored compactly, and the number of remembered queries is limited for this reason.

## 🌐 Internationalization
The plugin supports 14 languages, including English, German, Japanese, French, Spanish, and more.
- <u>Full Support:</u> English and German are currently the primary maintained languages.
- <u>Experimental:</u> Other languages are currently in an experimental state.
- <u>Contribute:</u> Pull Requests to improve or add translations for your language are highly welcome!

## 📋 Requirements

- **Redmine**: 6.0 or higher
- **Ruby**: as required by your Redmine version (tested with 3.2 – 4.0)
- **Database**: MySQL or PostgreSQL
- **Rails**: Compatible with Redmine's Rails version

The plugin does not require the Redmine fix from [#44667](https://www.redmine.org/issues/44667), but works with it.

## 🚀 Installation

```bash
cd $REDMINE_ROOT/plugins
git clone https://github.com/flowalchs/redmine_query_sort_memory.git
```
Restart your Redmine server to load the plugin. No database migration is needed.

## 🧪 Tests

```bash
cd $REDMINE_ROOT
bundle exec rake redmine:plugins:test NAME=redmine_query_sort_memory RAILS_ENV=test
```

## ❌ Uninstall

Remove the directory `plugins/redmine_query_sort_memory` and restart your Redmine server.

## 📝 Background

See [#44406](https://www.redmine.org/issues/44406) on redmine.org.

## 🤝 Contributing
Pull requests, translations, and feedback are welcome.

## 📜 License
MIT License
