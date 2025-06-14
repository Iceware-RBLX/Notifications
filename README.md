# IceWare Notification Library




## 🖼️ Preview
![Preview](https://cdn.vudgor.wtf/api/Notif%20Preview.png)

---

## 📦 Usage

**1.** Load the library:
```lua
local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Iceware-RBLX/IceWare-Notification-Library/refs/heads/main/Notif.lua"))()
```

**2.** Push a notification:
```lua
Notify:Push("Hello this is the content", 5, "Title", "rbxassetid://iconid")
```

---

## 🚀 API

### `Notify:Push(message, duration, title, icon)`
- **message** *(string, required)*: The main text of the notification.
- **duration** *(number, required)*: How long (in seconds) the notification stays on screen.
- **title** *(string, optional)*: The title text. Defaults to "Notification".
- **icon** *(string, optional)*: The icon asset id. Defaults to a bell icon.

**Example:**
```lua
Notify:Push("Waiting for game to load...", 4, "Notification", "rbxassetid://70856241901857")
```

---




## 🙏 Credits
- UI : @neuillesque

