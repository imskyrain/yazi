# Yazi 配置对比报告

> **生成日期**：2026-02-04
> **Yazi 版本**：0.3.3 (Homebrew)
> **备份版**：`/Tools/git_core/github/.config/yazi/`（Git 仓库，含 plugins）
> **在用版**：`~/.config/yazi/`（当前生效配置）

---

## 一、版本兼容性警告

当前安装的 Yazi 0.3.3 使用**新版 API**，在用版的部分配置使用的是旧版 API，存在失效风险：

| 在用版（旧 API） | 备份版（新 API） | 状态 |
|:---|:---|:---|
| `[manager]` | `[mgr]` | 在用版字段名不被识别 |
| `name = "*/"` (open rules) | `url = "*/"` | 在用版匹配规则失效 |
| `[select]` | `[pick]` | 在用版 section 名错误 |
| `fetchers = [...]` | `prepend_fetchers = [...]` | 在用版 fetcher 无法正常注册 |
| `sort modified` / `sort created` | `sort mtime` / `sort btime` | 在用版排序命令报错 |
| `arrow -99999999` | `arrow top` | 在用版用了数字偏移代替语义命令 |

**结论：在用版需要更新到新 API，否则核心功能不稳定。**

---

## 二、文件结构对比

| 文件 | 备份版 | 在用版 | 备注 |
|:---|:---:|:---:|:---|
| `yazi.toml` | ✓ | ✓ | 核心配置 |
| `keymap.toml` | ✓ | ✓ | 键映射 |
| `theme.toml` | ✓ | ✓ | 在用版为完整版 |
| `init.lua` | ✓ | ✗ | Plugin 初始化脚本 |
| `package.toml` | ✓ | ✗ | Plugin 版本锁定 |
| `starship.toml` | ✓ | ✗ | Starship 提示词 |
| `plugins/` | ✓ (6个) | ✗ | 见下方 Plugin 列表 |

### 备份版 Plugin 列表

| Plugin | 功能 |
|:---|:---|
| `yaziline` | 自定义 status bar（curvy 分隔符） |
| `starship` | Starship 提示词集分 |
| `git` | 文件列表显示 git 状态 |
| `smart-enter` | Enter 键智能行为（文件夹进入/文件打开） |
| `yamb` | fzf 驱动的书签管理 |
| `compress` | 选中文件一键归档压缩 |

---

## 三、yazi.toml 详细对比

### 3.1 布局与排序 — `[mgr]`

| 配置项 | 备份版 | 在用版 | 推荐 | 理由 |
|:---|:---|:---|:---:|:---|
| `ratio` | `[1, 3, 4]` | `[1, 4, 3]` | 看喜好 | `[1,4,3]` 预览区更宽适合浏览；`[1,3,4]` 文件列表更宽 |
| `sort_by` | `alphabetical` | `created` | **备份** | 字母序是默认惯例，按创建时间默认显示混乱 |
| `sort_reverse` | `false` | `true` | 与 sort_by 挂钩 | — |
| `sort_dir_first` | `true` | `false` | **备份** | 目录优先是文件管理器惯例 |
| `linemode` | `size` | `none` | **备份** | 显示文件大小信息量更大 |

### 3.2 确认对话框

| 对比维度 | 备份版 | 在用版 | 推荐 |
|:---|:---|:---|:---:|
| 所属 section | `[input]` 内 | 独立 `[confirm]` | **在用版** |
| 位置 | `top-center` | `center` | **在用版** |
| 尺寸 | 小（50×3） | 大（70×20） | **在用版** |
| API 兼容 | 符合新 API | 旧 API（需修改 section 名） | 内容好但 section 名需修正 |

> 在用版的确认对话设计更好（居中大弹框适合危险操作），但 `[confirm]` 是新版 yazi 才正式支持的 section，需确认版本兼容。

### 3.3 Plugin Fetchers

| 备份版 | 在用版 | 推荐 |
|:---|:---|:---:|
| `prepend_fetchers` + git fetcher | `fetchers` + mime fetcher | **合并两者** |

- `mime` fetcher：确保正确识别文件 MIME 类型
- `git` fetcher：提供 git 状态信息（配合 git plugin）

### 3.4 其他

| 项目 | 备份版 | 在用版 | 推荐 |
|:---|:---|:---|:---:|
| `[preview] wrap` | 无 | `"no"` | 无影响 |
| `[preview] image_delay` | 无 | `30` | 无影响 |
| `[input] create_title` | `["Create:", "Create (dir):"]` | `"Create:"` | **备份** |
| `[log] enabled` | 无 | `false` | 无影响 |

---

## 四、keymap.toml 详细对比

### 4.1 导航键映射哲学

两套配置的核心分歧在于**基础导航键的选择**：

| 方向 | 备份版 | 在用版（标准 vim） |
|:---|:---|:---|
| 上 | `u` | `k` |
| 下 | `e` | `j` |
| 左（parent） | `n` | `h` |
| 右（enter） | 无单键 | `l` |
| 历史后退 | `N` | `H` |
| 历史前进 | `I` | `L` |

**推荐在用版的 `hjkl` 体系。** 标准 vim 键映射，肌肉记忆最强，且在 input 模式内也保持一致。

### 4.2 翻页与滚动

| 功能 | 备份版 | 在用版 | 推荐 |
|:---|:---|:---|:---:|
| 半页上/下 | `<C-u>` / `<C-e>` | `<C-u>` / `<C-d>` | **在用版** |
| 全页上/下 | 无 | `<C-b>` / `<C-f>` | **在用版** |
| 快速上/下 5 行 | `U` / `E` | 无 | 备份版有此功能 |
| 预览 seek | 无 | `K` / `J` | **在用版** |

### 4.3 文件操作键

| 功能 | 备份版 | 在用版 | 推荐 |
|:---|:---|:---|:---:|
| 复制(yank) | `yy` | `y` | **在用版**（单键更快） |
| 剪切(cut) | `dd` | `x` | **在用版**（单键，符合惯例） |
| 粘贴 | `pp` / `pP` | `p` / `P` | **在用版** |
| Trash | 无快捷 | `d` | **在用版**（先丢垃圾桶更安全） |
| 永久删除 | `dD` | `D` | **在用版** |
| 打开文件 | `r`（interactive） | `o` / `O` / `<Enter>` | **在用版**（`<Enter>` 打开文件最自然） |
| 创建文件 | `T`(file) / `M`(dir) | `a` | 看喜好 |
| 重命名 | `k`/`a`/`A`/`cw` 四种 | `r` 单键 | **备份版**更灵活（多种 cursor 定位） |
| 复制路径 | `yp`/`yf`/`yd`/`yn` | `cc`/`cf`/`cd`/`cn` | 看喜好 |

### 4.4 备份版独有的实用快捷

| 快捷键 | 功能 | 依赖 |
|:---|:---|:---|
| `<C-g>` | 启动 lazygit | 无 |
| `'a` / `''` / `'r` | 添加/跳转/删除书签 | yamb plugin |
| `ca` | 压缩选中文件 | compress plugin |
| `P` | 打开 spotter | 内置 |
| `i` / `<Enter>` | smart-enter（智能进入） | smart-enter plugin |
| `R` | 刷新当前目录 | 无 |

**这些快捷键全部值得保留，需移植到最终配置中。**

### 4.5 排序键

| 维度 | 备份版 | 在用版 | 推荐 |
|:---|:---|:---|:---:|
| 前缀键 | `o` | `,` | **在用版**（`o` 和 open 冲突） |
| 随机排序 | 无 | `,r` | **在用版** |

### 4.6 Goto 快捷

| 路径 | 备份版 | 在用版 |
|:---|:---:|:---:|
| `/` (root) | `gr` ✓ | ✗ |
| `~` (home) | `gh` ✓ | `gh` ✓ |
| `~/.config` | `gc` ✓ | `gc` ✓ |
| `~/Downloads` | `gd` ✓ | `gd` ✓ |
| `~/Desktop` | `gD` ✓ | ✗ |
| `~/Github` | `gi` ✓ | ✗ |
| `~/.config/nvim` | `gfn` ✓ | ✗ |
| `~/.config/yazi` | `gfy` ✓ | ✗ |
| `~/.config/zsh` | `gfz` ✓ | ✗ |
| `~/.config/jesseduffield/lazygit` | `gfl` ✓ | ✗ |
| Interactive cd | `g<Space>` ✓ | `g<Space>` ✓ |

**推荐保留备份版的全部 goto 路由。**

### 4.7 Tab 管理

| 功能 | 备份版 | 在用版 | 推荐 |
|:---|:---|:---|:---:|
| 新 tab | `tu` | `t` | **在用版**（单键） |
| 切换 tab | `tn` / `ti` | `[` / `]` | **在用版**（符合惯例） |
| 交换 tab | 无 | `{` / `}` | **在用版** |

### 4.8 Input 模式映射

| 功能 | 备份版 | 在用版 | 推荐 |
|:---|:---|:---|:---:|
| 进入 insert | `k` | `i` | **在用版** |
| 左右移动 | `n` / `i` | `h` / `l` | **在用版** |
| 行首/行尾 | `N` / `I` | `0` / `$` | **在用版** |
| Word end | `h` | `e` | **在用版** |
| Undo | `l` | `u` | **在用版** |

**在用版 input 模式是标准 vim 映射。备份版的 input 映射和 manager 层映射互相冲突，容易误操作。**

---

## 五、theme.toml 对比

| 维度 | 备份版 | 在用版 |
|:---|:---|:---|
| 有效配置行数 | ~6 行 | ~780 行 |
| manager 高亮 | 仅 border | 完整（hovered/find/marker/tab/count） |
| status bar | 仅 mode 颜色 | 完整（separator/progress/permissions） |
| select/input/tasks | 无 | 全套样式 |
| filetype 颜色 | 无 | 按 mime 类型着色 |
| icon 映射 | 无 | dirs/files/exts/conds 600+ 条 |

**推荐在用版 theme，备份版几乎是空白。**

---

## 六、最终推荐方案

### 从在用版保留（基础层）

- `hjkl` 标准 vim 键映射体系
- Input 模式全套 vim 标准映射
- `,` 排序前缀 + 随机排序
- `[]/{}` Tab 操作
- `o`/`<Enter>` 打开文件
- `d`(trash) / `D`(permanent) 删除逻辑
- `K`/`J` 预览 seek
- `<C-b>`/`<C-f>` 全页翻页
- 完整 theme.toml
- `[confirm]` 对话框设计

### 从备份版移植（功能层）

- `init.lua` — Plugin 初始化 + 自定义 status bar
- `package.toml` — Plugin 版本管理
- `starship.toml` — Starship 配置
- 全部 6 个 plugins
- `<C-g>` 启动 lazygit
- `'` 前缀 yamb 书签操作
- `ca` 压缩快捷
- `P` spotter
- `smart-enter` 绑定到 `<Enter>`
- `R` 刷新目录
- 多种 rename 快捷（`k`/`a`/`A`/`cw`）
- 完整 goto 路由（`gr`/`gD`/`gi`/`gf` 子菜）
- `sort_by = alphabetical` + `sort_dir_first = true` + `linemode = size`

### 合并处理

- **fetchers**：同时保留 git fetcher（`prepend_fetchers`）和 mime fetcher
- **API**：统一使用 v0.3.3 新 API（`[mgr]`/`url`/`[pick]`/`prepend_fetchers`）
- **theme**：用在用版的完整 theme，补上备份版缺少的 `tab_width = 12`（如需要）

---

## 七、需要注意的冲突点

1. **`a` 键冲突**：在用版 `a`=create，备份版 `a`=rename(before_ext)。推荐保留 `a`=create，rename 用 `r`。
2. **`n`/`N` 键冲突**：在用版 `n`/`N`=find_arrow，备份版 `n`=leave。采用在用版方案（`hjkl` 导航后 `n/N` 自然给 find）。
3. **`o` 键冲突**：备份版 `o` 前缀用于排序。在用版 `o`=open，排序改用 `,`。
4. **`P` 键冲突**：备份版 `P`=spot，在用版 `P`=paste --force。spot 可考虑绑到其他键（如 `<C-p>` 原本给 fzf）。
