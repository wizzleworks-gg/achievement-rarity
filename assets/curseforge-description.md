# AchievementRarity

**The achievement rarity data library, by the Wizzleworks.** For any achievement in the
game it answers three questions:

- **How rare is it?** — the share of accounts that have earned it, measured for US, EU,
  and globally.
- **How early was an earn?** — rank-at-earn: the share of all tracked accounts that had it
  before a given date. *"You were in the first 0.4% to earn this."*
- **How rare is a whole collection?** — collection standing: a rarity-weighted score over
  everything a player has earned, read out against all tracked accounts. *"Your
  achievements are rarer than 96% of EU accounts."*

## Data only — bring your own UI

The library draws nothing and saves nothing: no UI, no slash commands, no saved
variables. Addons embed it and build their own surfaces on top — the reference consumer
is **How Rare?**. It also ships an optional opinion layer: rarity tiers banded through
WoW's loot-quality palette (legendary under 0.1%, epic under 5%, …), which consumers can
use as-is or ignore and band the raw numbers their own way.

## For players

Installing this standalone copy alongside an addon that uses the library keeps that
addon's numbers fresh: the library is LibStub-versioned, so the freshest copy on your
system transparently supersedes any embedded one, no configuration needed. Without it, a
consumer addon simply rides the snapshot it embedded — also fine.

## For addon authors

```lua
local AR = LibStub("AchievementRarity-1.0", true) -- silent: nil if not installed
if AR then
    local pct = AR:GetRarity(achievementID)       -- e.g. 2.7 (percent of accounts)
    print(AR:Format(achievementID))               -- "3%" (or "<1%")
    print(AR:GetTier(achievementID))              -- "epic"
end
```

Rarity, raw counts, rank-at-earn, collection weight/score/standing, tier bands and
colours — the full API, the embedding guide, and the methodology live in the
[GitHub README](https://github.com/wizzleworks-gg/achievement-rarity). **MIT licensed**:
embed it in anything, including closed-source addons.

## Where the numbers come from

Built by the Wizzleworks from the **public** Blizzard armory — the same character pages
anyone can view. Characters are grouped into the account that owns them (account-wide
achievements complete at the same instant on every character a player owns), each account
is represented by its most-complete character, and only accounts active in the last 30
days count. Over 830,000 accounts are tracked across US and EU today.

Every figure is a **floor**: the tracked population leans toward engaged players, so the
true share can only be rarer than shown. Only aggregates are ever published — nothing
that identifies an individual player — and a character that goes private drops out of the
records.

Honesty rules ship in the data: achievements with too few tracked earners carry no rank
curve (a percentile would be noise), unreliably old earn dates are suppressed rather than
trusted, and retired achievements — still in the game files but removed from Blizzard's
own achievement index — are excluded rather than passed off as ultra-rare.

## Snapshots and freshness

Every release embeds a dated snapshot — `GetMeta().asOf` says exactly how fresh the
numbers are, and each figure a consumer shows can carry that date. The library's version
minor derives from the snapshot date, so among however many copies are on a system —
embedded or standalone — the newest data always wins, automatically.

---

Data and library by **the Wizzleworks**. Issues, API questions, and source:
[github.com/wizzleworks-gg/achievement-rarity](https://github.com/wizzleworks-gg/achievement-rarity).
