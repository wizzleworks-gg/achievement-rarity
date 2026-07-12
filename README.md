# AchievementRarity

**An embeddable World of Warcraft data library, by the [Wizzleworks](https://github.com/wizzleworks-gg).**
For any achievement, it answers two questions: *how rare is it?* — the share of accounts that
have completed it, across the US and EU regions and globally — and *how early was a given earn?*
— the share of all tracked accounts that had earned it before a given date (rank-at-earn).

It is **just the data** (plus an optional house tier scheme). It has no UI, no slash commands,
and no saved variables. Addons embed it and build their own surfaces on top; the reference
consumer is the **How Rare?** addon.

- **MIT licensed** — embed it in anything, including closed-source addons. Keep the notice.
- **LibStub-versioned** — `AchievementRarity-1.0`. Multiple copies coexist; the freshest wins.
- **Two layers** — a raw contract (the percentage) that never depends on the opinion layer
  (our tier bands), so you can take just the number and band it your own way.

---

## Using it

Resolve the library through LibStub and call its getters:

```lua
local AR = LibStub("AchievementRarity-1.0", true) -- silent: nil if not installed
if AR then
    local pct = AR:GetRarity(achievementID)       -- e.g. 2.7  (percent, 0–100)
    if pct then
        print(AR:Format(achievementID))           -- "3%"  (or "<1%")
        print(AR:GetTier(achievementID))          -- "epic"
    end
end
```

Always handle `nil`: a getter returns `nil` for any achievement **newer than the embedded
snapshot**. There is no built-in fallback — that is the consumer's call.

### Embedding (recommended)

Copy two folders into your addon and load them **before** your own code:

```
YourAddon/
  Libs/
    LibStub/LibStub.lua                       -- skip if you already ship LibStub
    AchievementRarity-1.0/
      AchievementRarity-Data-1.0.lua          -- the snapshot (loads first)
      AchievementRarity-1.0.lua               -- the API     (loads second)
```

In your `.toc`, list them ahead of the files that use them:

```
Libs\LibStub\LibStub.lua
Libs\AchievementRarity-1.0\AchievementRarity-Data-1.0.lua
Libs\AchievementRarity-1.0\AchievementRarity-1.0.lua
# ... your addon's files ...
```

Your addon now works standalone, frozen at whatever snapshot you embedded.

### Standalone (optional freshness)

This repo is also a loadable addon in its own right. A player who installs it **as well**
gets the latest snapshot on its own update cadence; because the library is LibStub-versioned,
the freshest copy on the system transparently supersedes every embedded one at runtime
(order-independent). A player who doesn't simply rides whatever a consumer embedded — fine by
default.

---

## API

All getters take an optional `scope`: `"region"` (the player's home region — the default),
`"global"`, or an explicit region name (`"us"` / `"eu"`) when you want a specific column
regardless of where the player plays. Every getter returns `nil` for an achievement outside
the snapshot.

### Raw — the hard contract

| Call | Returns |
|---|---|
| `AR:GetRarity(id [, scope])` | attainment as a percent, `0`–`100` (e.g. `2.7`) |
| `AR:GetCount(id [, scope])` | the raw account count behind the percentage (for "one of only N") |
| `AR:GetData()` | the whole `{ [id] = {us, eu, global} }` count table — for scanning every id (treat read-only) |
| `AR:GetMeta()` | `{ asOf, accounts = {us, eu, global}, region, minor, rankFloor }` — snapshot date, per-region denominators, the player's home region, the data version, and the rank floor date (nil in a data file without rank support) |
| `AR:RankAtEarn(id, earnTime [, scope])` | rank-at-earn for an earn at `earnTime` (epoch seconds), as **two returns**: the share (`0`–`100`) of **all** tracked accounts that earned it before then (never exceeds the rarity — same denominator), and the percentile (`0`–`100`) among the achievement's earners only (for gating on "notably early"). On suppression the first return is `nil` and the second is the **reason**: `"off-snapshot"`, `"no-curve"` (too few earners for a stable percentile), or `"date-floor"` (earn date at/below the unreliable floor — see below) |
| `AR:CollectionWeight(id)` | one achievement's contribution to the collection score (its "surprise": −log2 of the global attainment share), or `nil` when there is nothing to weigh — off-snapshot, or zero recorded global holders |
| `AR:CollectionScore(isEarned)` | a whole-collection score: the summed weight of every snapshot achievement for which the `isEarned(id)` callback returns true (the callback keeps game-API calls out of the library) |
| `AR:CollectionStanding(score [, scope])` | where that score stands among tracked accounts: the share (`0`–`100`) that scores **below** it — "your achievements are rarer than N%". `nil` in a data file (or scope) without a standing distribution |

### Opinion — house style, optional and overridable

We band the raw percentage into tiers borrowed from WoW's loot-quality palette. This is *our*
editorial opinion; if you disagree, take `GetTiers()` (or just `GetRarity`) and band it
yourself.

| Call | Returns |
|---|---|
| `AR:GetTier(id [, scope])` | tier name: `"legendary"` / `"epic"` / `"rare"` / `"uncommon"` / `"common"` / `"junk"` |
| `AR:CollectionTier(score [, scope])` | the tier verdict for a whole collection ("your achievements are **Epic**"), banding `CollectionStanding` through the same scale (top 0.1% of accounts = legendary, top 5% = epic, …); returns tier name, the standing, and the tier's `r, g, b` |
| `AR:GetColor(id [, scope])` | `r, g, b` (each `0`–`1`) of the tier colour |
| `AR:GetTiers()` | the bands, rarest first: `{ {name, maxPct, r, g, b}, ... }` — `maxPct` is the % below which the tier applies |
| `AR:Format(id [, scope])` | formatted string, `"3%"` / `"<1%"` |
| `AR:FormatPct(pct)` | the same formatter, for a percentage you already hold |

The current bands: **legendary** < 0.1%, **epic** < 5%, **rare** < 15%, **uncommon** < 40%,
**common** < 70%, **junk** otherwise.

### Fields

- `AR.source` — `"the Wizzleworks"`, for crediting the data.

---

## How the numbers work

These numbers measure one thing: **how rare** an achievement is — *"earned by 4%"*. That share
is measured against the population of WoW accounts the Wizzleworks actively tracks, **not**
against every account that has ever existed.

**One count per player, not per character.** A single player usually has several characters.
To avoid counting the same person many times, we group a player's characters together — we can
tell them apart because account-wide achievements complete at the *same moment* on every
character someone owns, so characters sharing those exact earn-times are almost certainly the
same account. Each account is then represented by its **most-complete character**, and that
character's achievements are what the account counts as holding. (This uses only public
achievement data; we never touch Battle.net logins or account details.)

**What "active" means.** An account counts as active when at least one of its characters has
logged in within the last 30 days. Accounts that go quiet drop out of the denominator, so the
figures reflect the players currently in the game.

**It's a floor, not the whole game.** We can only see characters discovered through public
data, and that population leans toward more engaged players. So every figure is best read as
*among active, trackable players* — which makes a rarity number a **floor** on how rare
something truly is: the real share can only be lower (rarer), never higher.

**Rank-at-earn — "you were in the first N% to earn this."** Besides *how many* hold an
achievement, the library ships *when* its earners earned it: per achievement, a small curve of
dates by which each slice of today's earners had it. Looking up an earn date against that curve
gives the share of **all** tracked accounts that earned it before then — the same denominator as
the rarity figure, so the two read consistently side by side (an account that never earned it
can't have earned it before you). Every earner of a 4%-rarity achievement is somewhere within
its "first ~4%"; the earliest are "first <0.1%". Two honesty rules: achievements with too few
tracked earners ship no curve (a percentile would be noise), and earn dates at or before the
achievement system's launch (14 Oct 2008, `rankFloor`) are suppressed — WoW back-credits old
account-wide earns to that date, so it can't be trusted.

**Collection standing — "how rare are YOU?"** Beyond single achievements, the library can
place a player's *whole collection*: every earned achievement contributes points for how
*surprising* it is to hold (an achievement half of players have is worth ~1 point, a 3% one
~5, a 0.1% one ~10 — the rule is logarithmic, so rare earns count more but no single
achievement dominates). The data file ships the distribution of that score across all
tracked accounts, so a player's recomputed score reads out as "rarer than 96% of accounts".
Because everyone is scored by the identical rule against the identical snapshot, the
standing is a pure ranking — and the same active-trackable-players caveat applies, so the
true standing can only be better than shown.

**Regions.** **US** and **EU** are measured separately, each against its own active population.
**Global** combines them — today that means US + EU only; other regions (KR, TW) fold into the
global figure as we begin tracking them.

**Data & privacy.** Every number is built from the **public** Blizzard armory — the same
character pages anyone can view. We publish only **aggregates** (how many accounts hold an
achievement), never anything that identifies an individual player. When a character is made
private or stops appearing in the public armory, it drops out of our records and stops counting.

Each release is a dated **snapshot** (`AR:GetMeta().asOf`), refreshed on a regular cadence.

---

## Versioning

- **Name major (`AchievementRarity-1.0`)** is the *contract*. It only changes on a breaking
  change to the raw API — rare, and announced.
- **LibStub minor** is *data freshness*: days since 2020-01-01 of the snapshot date. It rises
  with every fresh snapshot, so freshest-wins arbitration always loads the newest copy on the
  system. Re-publishing the same snapshot yields the same minor (no churn).

---

## Licence & attribution

MIT — see [LICENSE](LICENSE). The rarity figures are facts compiled by the Wizzleworks; the
MIT notice is the attribution hook. If you surface the data to players, a credit to **the
Wizzleworks** is appreciated (`AR.source` is provided for exactly this).
