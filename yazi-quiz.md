# Yazi 高阶玩法 — 反向出题

> 每道题先给场景描述，自己想出操作步骤后再翻转查看答案。
> 难度分三级：🟢 基础 → 🟡 进阶 → 🔴 高阶

---

## 🟢 Level 1 — 基础操作

### Q1
你刚启动 yazi，想快速打开 `~/Downloads` 里的一个文件，但当前在家目录。最少需要几步？

<details>
<summary>答案</summary>

1. `gd` — 跳转到 `~/Downloads`
2. `u`/`e` 导航到目标文件
3. `i` — smart-enter 直接打开

共 3 步（不含导航滚动）。
</details>

---

### Q2
你在一个 git 仓库里，想看某个文件夹内部是否有未提交的修改，但不想打开 lazygit。怎么做？

<details>
<summary>答案</summary>

不需要做任何操作。git plugin 会**自动在文件列表右侧显示状态标记**，对文件夹会向上冒泡显示最高优先级的状态。悬停在文件夹上即可判断：
- 看到黄色 ` ` → 内部有 modified 文件
- 看到紫色 `? ` → 内部有 untracked 文件
</details>

---

### Q3
你想把当前目录的所有文件复制路径到剪贴板，以便粘贴到其他地方。当前悬停在 `config.toml` 上，需要的是**不含扩展名的文件名**。

<details>
<summary>答案</summary>

`yn` — 复制 name_without_ext，剪贴板内容为 `config`
</details>

---

### Q4
你有 3 个 tab 开着不同目录，想直接跳到第 2 个 tab。

<details>
<summary>答案</summary>

按 `2`。数字键直接切换到对应编号的 tab。
</details>

---

## 🟡 Level 2 — 插件与组合操作

### Q5
你经常访问 `~/Projects/myapp/src`，想在不翻目录的情况下，以后一键到达。今天第一次访问时需要怎么做？下次怎么跳？

<details>
<summary>答案</summary>

**首次（添加书签）：**
1. 导航到 `~/Projects/myapp/src`
2. 悬停在 `src` 目录上（或者已经在 src 目录内均可）
3. `'a` → 弹出 tag 输入框，输入 `src`（或任意别名）
4. 弹出 key 输入框，输入 `s`（可选，用于 which 快跳）

**下次跳转：**
- `''` 打开 fzf，输入 `src` 回车，即可跳转

也可以直接用 which 菜单：`'` 后的 which 列表中选 `s`。
</details>

---

### Q6
你选了 5 个 `.log` 文件，想打包成 `logs.tar.gz` 并且设置密码。压缩插件的绑定是 `ca`，但当前绑定没有带 `-p` 参数。怎么在不修改 keymap 的情况下完成加密压缩？

<details>
<summary>答案</summary>

当前绑定 `ca` 对应 `plugin compress`（无参数），无法临时加 `-p`。

需要走变通路径：
1. 选中文件
2. `;` 进入交互 shell
3. 手动执行：`tar czf logs.tar.gz --files-from <(echo "file1.log\nfile2.log")` 配合 `openssl` 或 `gpg` 加密

或者更正确的做法是**临时修改 keymap.toml**，将 `ca` 改为 `plugin compress -p`，操作完后改回。

> 如果想长期支持密码压缩，建议新增一个绑定（如 `cA`）专门带 `-p` 参数。
</details>

---

### Q7
你在 yazi 里看到状态栏左侧显示 ` 3  󰆐 2`，这两个数字分别代表什么？

<details>
<summary>答案</summary>

- ` 3` — 当前选中（selected）的文件数量为 3
- `󰆐 2` — 当前 yank（复制或剪切）的文件数量为 2

图标和颜色会随状态变化：yank 状态为剪切时显示红色，复制时显示绿色。
</details>

---

### Q8
你打开了 spotter（`P`），想通过 spotter 快速浏览文件内容并复制某个单元格的值。操作流程？

<details>
<summary>答案</summary>

1. 悬停在目标文件上
2. `P` — 打开 spotter（全屏预览）
3. `u`/`e` 上下翻行
4. `<C-u>`/`<C-e>` 快速翻动（每次 5 行）
5. 看到目标内容后按 `y` — 复制当前单元格到剪贴板
6. `q` 或 `<Esc>` 关闭 spotter
</details>

---

### Q9
当前 yazi 的 header 区域显示的不是普通路径，而是一个带有 git 分支名和颜色的 Starship 提示词。如果想**临时禁用** Starship 提示词，恢复显示普通路径，不需要重启 yazi，怎么做？

<details>
<summary>答案</summary>

Starship plugin 通过 `ps.sub("cd", ...)` 订阅事件实现更新。它没有提供运行时切换开关。

正确做法是修改 `init.lua`：注释掉 `require("starship"):setup { ... }` 那行，然后**重启 yazi**（`Q` 退出再启动）。

无法不重启的情况下实现切换——这是 starship plugin 当前的局限。
</details>

---

## 🔴 Level 3 — 深度理解与边界场景

### Q10
你在一个大仓库里，yazi 退出时总弹出 "有任务正在运行" 的确认对话。你知道是 preloader 导致的，但不想禁用所有预加载。正确的一行配置修改是什么？

<details>
<summary>答案</summary>

在 `yazi.toml` 的 `[tasks]` 部分，将：
```toml
suppress_preload = false
```
改为：
```toml
suppress_preload = true
```

这**不会禁用 preloader**（图片/视频/PDF 预缓存仍然正常工作），只是让 preload 任务不计入退出时的"正在运行"任务列表。
</details>

---

### Q11
你想在 yazi 的文件列表中，对**同一个目录内的文件**按修改时间逆序排列，同时让状态栏右侧也显示修改时间而不是文件大小。一个命令序列完成。

<details>
<summary>答案</summary>

按 `om`。

查看 keymap.toml 可知：
```toml
{ on = ["o", "m"], run = ["sort mtime --reverse", "linemode mtime"] }
```

这是一个**多命令绑定**：同时执行 `sort mtime --reverse`（逆序排列）和 `linemode mtime`（切换显示为修改时间）。一次按键完成两个操作。
</details>

---

### Q12
你的 yazi 文件列表里，某些特殊文件（如 `.dockerignore`, `docker-compose.yml`) 显示的图标颜色与普通文件不同。这种颜色是哪里配置的？如何为自己的项目文件（如 `Makefile.j2`) 添加自定义图标？

<details>
<summary>答案</summary>

颜色来自 `theme.toml` 的 `[icon]` 部分，在 `files` 数组中按文件名匹配：
```toml
{ name = "dockerfile", text = "󰡨", fg_dark = "#458ee6", fg_light = "#2e5f99" }
```

添加自定义图标：在 `theme.toml` 的 `[icon]` → `files` 数组中新增一条：
```toml
{ name = "Makefile.j2", text = "", fg_dark = "#6d8086", fg_light = "#526064" }
```

如果是按扩展名匹配（如所有 `.j2` 文件），则应加在 `exts` 数组中：
```toml
{ ext = "j2", text = "", fg_dark = "#6d8086", fg_light = "#526064" }
```

如果是带通配符的复杂匹配（如 `*.test.ts`），则加在 `globs` 数组中：
```toml
{ glob = "*.test.ts", text = "", fg_dark = "#4CAF50", fg_light = "#2E7D32" }
```

优先级：`globs` > `files` > `exts` > 默认。
</details>

---

### Q13
你同时打开了 3 个 tab：tab1 在 `~/src`，tab2 在 `~/docs`，tab3 在 `~/deploy`。你在 tab1 中 `yy` 复制了一个文件，切换到 tab3，想粘贴。但切换过程中你发现 tab2 内的某个文件也需要先移动过来。最少操作步骤数是多少？

<details>
<summary>答案</summary>

**最优路径（5 步）：**

1. tab1：悬停在目标文件，`yy`（复制）
2. `3`（切换到 tab3）
3. `pp`（粘贴 tab1 的文件）
4. `2`（切换到 tab2）
5. 悬停在要移动的文件，`dd`（剪切）
6. `3`（切换回 tab3）
7. `pp`（粘贴）

实际是 **7 步**。无法更短——yank 缓冲区是全局的但每次 yank 会覆盖上次，必须先完成 tab1 的粘贴再去处理 tab2。
</details>

---

### Q14
你的 `init.lua` 里的状态栏自定义组件显示了当前文件的 `owner:group`。如果悬停的是一个你无权 `stat` 的文件（如 `/root/.bashrc`），这个组件会显示什么？为什么不会崩溃？

<details>
<summary>答案</summary>

显示的是 **UID 和 GID 的数字值**（如 `0:0`），不会崩溃。

原因在 `init.lua` 的代码逻辑：
```lua
ya.user_name(h.cha.uid) or tostring(h.cha.uid)
ya.group_name(h.cha.gid) or tostring(h.cha.gid)
```

`ya.user_name()` 如果无法解析名称会返回 `nil`，`or tostring(...)` 作为 fallback 直接输出数字 UID。

同时，`h.cha` 中的 `uid`/`gid` 来自 yazi 内部的 `fs::cha`，在 macOS 上 `stat` 本身不要求读权限，只要父目录可执行即可获取元数据。所以 `/root/.bashrc` 在通常情况下**会显示 `0:0`**。
</details>

---

### Q15
你想理解 yazi 的 git plugin 为什么对文件夹显示的是"最高优先级"状态而不是全部状态。从代码逻辑解释 `bubble_up` 的机制。

<details>
<summary>答案</summary>

在 `plugins/git.yazi/main.lua` 中，`bubble_up` 函数遍历所有已变更的文件路径，对每一级父目录都记录状态码，**取 code 值更大的那个**：

```lua
new[s] = (new[s] or CODES.unknown) > code and new[s] or code
```

优先级（code 值从高到低）：
```
untracked(5) > modified(4) > added(3) > deleted(2) > updated(1) > unknown(0)
```

所以如果一个文件夹内同时有 `modified` 和 `untracked` 的文件，文件夹显示的是 `untracked`（紫色 `?`），因为 5 > 4。

这是一种实用的信息压缩：让你一眼就能看到"这个文件夹里有多么乱"——有 untracked 的必然比全是 modified 的更需要你的注意。
</details>

---

## 附：常见易错点

| 场景 | 易错操作 | 正确操作 |
|:---|:---|:---|
| 想选多个文件再复制 | 先 `yy` 再选 | 先 `<Space>` 选中多个，再 `yy` |
| 想回到上次访问的目录 | 按 `n`（会进父目录） | 按 `N`（历史后退） |
| 想看当前排序方式 | 无明显提示 | 看 linemode 显示内容可猜测；或按 `~` 打开 help 过滤 `sort` |
| 想删除文件到垃圾桶 | 按 `d` | 当前配置 `d` 前缀是 cut；删除到垃圾桶的快捷未绑定，需用 `:` shell 手动执行 `rm -t ~/.Trash` 或在 keymap 中新增绑定 |
| 想在当前 tab 新开一个 tab | 按 `t` | 应该按 `tu`（`t` 单独不绑定） |
