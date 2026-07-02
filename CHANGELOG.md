# Changelog

All notable changes to **AchievementRarity**. The library name's major (`-1.0`) tracks the
raw API contract; the LibStub *minor* (days since 2020-01-01 of the snapshot) bumps on every
data refresh and is what freshest-wins arbitration keys on.

## Unreleased

- Initial extraction of the rarity data + tier opinion layer out of the **How Rare?** addon
  into a standalone, embeddable LibStub library (`AchievementRarity-1.0`). How Rare? becomes
  the reference consumer.
- Raw contract: `GetRarity` / `GetCount` / `GetData` / `GetMeta`.
- Opinion layer: `GetTier` / `GetColor` / `GetTiers` / `Format` / `FormatPct`.
- **Rank-at-earn**: the data file now ships per-achievement earn-date curves (percentile →
  day-offset breakpoints: `rankLadder` / `rankFloor` / `ranks`), and the API gains
  `RankAtEarn(id, earnTime[, scope])` — the share of **all** tracked accounts that earned an
  achievement before a given date (denominator-consistent with `GetRarity`; never exceeds it),
  plus the earner-only percentile as a second return. On suppression it returns nil plus a
  reason ("off-snapshot" / "no-curve" / "date-floor"), so consumers can explain a missing
  rank without touching the data tables.
- Scopes accept explicit region names ("us" / "eu" / "global") besides "region"/"global",
  so a consumer can read a specific column (e.g. a three-region detail line) through the
  API instead of indexing the packed count triples.
- The static API half is freshest-API-wins gated (`_apiMinor`), independently of the data
  snapshot's freshest-data-wins minor.
- Data snapshot as of 2026-07-01.
