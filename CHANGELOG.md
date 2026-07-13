# Changelog

All notable changes to **AchievementRarity**. The library name's major (`-1.0`) tracks the
raw API contract; the LibStub *minor* (days since 2020-01-01 of the snapshot) bumps on every
data refresh and is what freshest-wins arbitration keys on.

## 2026.07.13 — initial release

The Wizzleworks' achievement rarity data library, now installable standalone. Data
snapshot as of **2026-07-13**, built from 830,000+ tracked accounts across US and EU.

Ships with:

- **Rarity** — the share of accounts holding each achievement (US / EU / global),
  for 8,349 achievements.
- **Rank-at-earn** — per-achievement earn-date curves: *"you were in the first N% to
  earn this"*, retroactive for achievements earned years ago.
- **Collection standing** — a rarity-weighted score for a whole collection, read out
  against all tracked accounts: *"your achievements are rarer than N% of accounts"*.
- **Tier opinion layer** — loot-quality bands (legendary < 0.1%, epic < 5%, rare < 15%,
  uncommon < 40%, common < 70%) with colours and formatters; consumers can use them
  as-is or band the raw numbers their own way.
- **Freshest-wins** — LibStub-versioned by snapshot date, so this standalone copy
  transparently upgrades any addon that embeds the library; no configuration.

Data honesty, baked in: only accounts active in the last 30 days count and every figure
is a floor; achievements with too few tracked earners ship no rank curve; unreliably old
earn dates are suppressed; retired achievements are excluded.

MIT licensed — full API and methodology at
[github.com/wizzleworks-gg/achievement-rarity](https://github.com/wizzleworks-gg/achievement-rarity).
