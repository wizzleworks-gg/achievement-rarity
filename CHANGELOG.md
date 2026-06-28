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
- Data snapshot as of 2026-06-28.
