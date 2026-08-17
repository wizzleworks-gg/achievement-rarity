# AchievementRarity

**The rarity data behind the numbers, by wizzleworks.** For any achievement in the
game, this knows how many players actually have it. On its own it shows you nothing — no
windows, no tooltips, no commands. It's the data other addons read.

## Want to see rarity in game? Install How Rare?

**[How Rare?](https://www.curseforge.com/wow/addons/how-rare)** is the addon that puts
these numbers where you'll see them — on every achievement tooltip, on chat announcements,
on rows in the achievement panel, and on a screenshot-ready toast when you earn something.
It already carries this data inside it, so **How Rare? is all you need to install.**

This page is that data on its own, for two audiences: players who want it kept up to date,
and addon authors who want to use it.

## Should players install this as well?

Only if you want the freshest numbers. It's optional, and it changes nothing on screen.

Any addon that shows rarity carries a copy of the data inside it, frozen on the day that
addon was last released. This standalone copy updates on its own, more often. Install it
and every rarity addon on your machine quietly starts using the newer numbers instead —
nothing to configure, nothing to switch on. Skip it and those addons just use the copy
they shipped with, which is perfectly fine.

## What the data knows

- **How rare is an achievement?** — the share of accounts that have earned it, measured
  separately for US and EU, and globally. *"3% of players have this."*
- **How early were you?** — for an achievement you already hold, the share of tracked
  accounts that had it before you did. *"You were in the first 0.4% to earn this."*
- **How rare is a whole collection?** — a score across everything a player has earned,
  weighted so rare things count for more, read out against everyone tracked. *"Your
  achievements are rarer than 96% of EU accounts."*

It also ships an optional house scheme that bands rarity through WoW's loot-quality
colours (legendary under 0.1%, epic under 5%, and so on). Addons can use those bands as
they are, or take the raw numbers and band them their own way.

## Where the numbers come from

Built by wizzleworks from the **public** Blizzard armory — the same character pages
anyone can look up. A player usually has several characters, so characters are grouped
back into the account that owns them, each account is represented
by its most-complete character, and only accounts played in the last 30 days count. That's
over 700,000 accounts across US and EU today.

Every figure is a **floor**: the tracked population leans toward engaged players, so the
true share can only be rarer than shown, never more common. Only totals are ever published
— nothing that identifies an individual player — and a character that goes private drops
out of the records.

Every release is a dated snapshot, and addons can show that date next to the number, so
you always know how fresh a figure is.

## For addon authors

Data only — no UI, no slash commands, no saved variables. **MIT licensed**: embed it in
anything, including closed-source addons.

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
[GitHub README](https://github.com/wizzleworks-gg/achievement-rarity). The library is
LibStub-versioned and its minor derives from the snapshot date, so among however many
copies are on a system — embedded or standalone — the newest data always wins,
automatically.

---

Data and library by **wizzleworks**. Issues, API questions, and source:
[github.com/wizzleworks-gg/achievement-rarity](https://github.com/wizzleworks-gg/achievement-rarity).
