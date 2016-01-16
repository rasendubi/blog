---
title: Fix Skype under Awesome wm
author: Alexey Shmalko
tags: awesome, fix, skype
keywords: awesome wm,awesome,skype,fix,size
description: How to fix skype size under awesome wm.
---

By default, Skype behaves strangely under awesome wm. For example, view profile window is so small that even name isn't displayed.

<img src="/images/skype_profile_under_awesome.png" alt="skyper profile bug" />

Yes, that's Skype profile in the middle.

<!--more-->

After investigation with __xprop__, the reason is pretty clear.

```
WM_NORMAL_HINTS(WM_SIZE_HINTS):
        user specified size: 300 by 10
        program specified size: 300 by 10
        program specified minimum size: 300 by 573
        program specified maximum size: 300 by 10
        window gravity: NorthWest
```

The window's maximum size is smaller than minimum one. That's why it's impossible to resize Skype profile window.

Another problem is that Skype chat window's minimal size is big enough to go beyond the boundaries of my second screen when two or more windows are open.

### Fix
Both problems are fixed at once with adding the proper rule to your _rc.lua_:

```lua
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Skype" }, -- This one!!!
      properties = { size_hints_honor = false } },
}
```

`size_hints_honor = false` specifies that awesome should ignore program-specified minimum and maximum window sizes. After that, Skype works just great.

<img src="/images/skype_profile_fixed.png" class="img-responsive" />
