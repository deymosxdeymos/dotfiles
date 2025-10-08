use std/clip
use std null_device

$env.config.history.file_format = "sqlite"
$env.config.history.isolation = false
$env.config.history.max_size = 10_000_000
$env.config.history.sync_on_enter = true

$env.config.show_banner = false

$env.config.rm.always_trash = false

$env.config.recursion_limit = 100

$env.config.edit_mode = "vi"

$env.config.cursor_shape.emacs = "line"
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"

$env.CARAPACE_BRIDGES = "inshellisense,carapace,zsh,fish,bash"

$env.config.completions.algorithm = "substring"
$env.config.completions.sort = "smart"
$env.config.completions.case_sensitive = false
$env.config.completions.quick = true
$env.config.completions.partial = true
$env.config.completions.use_ls_colors = true

$env.config.use_kitty_protocol = true

$env.config.shell_integration.osc2 = true
$env.config.shell_integration.osc7 = true
$env.config.shell_integration.osc8 = true
$env.config.shell_integration.osc9_9 = true
$env.config.shell_integration.osc133 = true
$env.config.shell_integration.osc633 = true
$env.config.shell_integration.reset_application_mode = true

$env.config.bracketed_paste = true

$env.config.use_ansi_coloring = "auto"

$env.config.error_style = "fancy"

$env.config.highlight_resolved_externals = true

$env.config.display_errors.exit_code = false
$env.config.display_errors.termination_signal = true

$env.config.footer_mode = 25

$env.config.table.mode = "single"
$env.config.table.index_mode = "always"
$env.config.table.show_empty = true
$env.config.table.padding.left = 1
$env.config.table.padding.right = 1
$env.config.table.trim.methodology = "wrapping"
$env.config.table.trim.wrapping_try_keep_words = true
$env.config.table.trim.truncating_suffix =  "..."
$env.config.table.header_on_separator = true
$env.config.table.abbreviated_row_count = null
$env.config.table.footer_inheritance = true
$env.config.table.missing_value_symbol = $"(ansi magenta_bold)nope(ansi reset)"

$env.config.datetime_format.table = null
$env.config.datetime_format.normal = $"(ansi blue_bold)%Y(ansi reset)(ansi yellow)-(ansi blue_bold)%m(ansi reset)(ansi yellow)-(ansi blue_bold)%d(ansi reset)(ansi black)T(ansi magenta_bold)%H(ansi reset)(ansi yellow):(ansi magenta_bold)%M(ansi reset)(ansi yellow):(ansi magenta_bold)%S(ansi reset)"

$env.config.filesize.unit = "metric"
$env.config.filesize.show_unit = true
$env.config.filesize.precision = 1

$env.config.render_right_prompt_on_last_line = false

$env.config.float_precision = 2

$env.config.ls.use_ls_colors = true

$env.config.hooks.pre_prompt = []

$env.config.hooks.pre_execution = [
  {||
    commandline
    | str trim
    | if ($in | is-not-empty) { print $"(ansi title)($in) — nu(char bel)" }
  }
]

$env.config.hooks.env_change = {}

$env.config.hooks.display_output = {||
  tee { table --expand | print }
  # SQLiteDatabase doesn't support equality comparisions
  | try { if $in != null { $env.last = $in } }
}

$env.config.hooks.command_not_found = []

# `nu-highlight` with default colors
#
# Custom themes can produce a lot more ansi color codes and make the output
# exceed discord's character limits
def nu-highlight-default [] {
  let input = $in
  $env.config.color_config = {}
  $input | nu-highlight
}

# Copy the current commandline, add syntax highlighting, wrap it in a
# markdown code block, copy that to the system clipboard.
#
# Perfect for sharing code snippets on Discord.
def "nu-keybind commandline-copy" []: nothing -> nothing {
  commandline
  | nu-highlight-default
  | [
    "```ansi"
    $in
    "```"
  ]
  | str join (char nl)
  | clip copy --ansi
}

$env.config.keybindings ++= [
  {
    name: copy_color_commandline
    modifier: control_alt
    keycode: char_c
    mode: [ emacs vi_insert vi_normal ]
    event: {
      send: executehostcommand
      cmd: 'nu-keybind commandline-copy'
    }
  }
]

$env.config.color_config.bool = {||
  if $in {
    { fg: "#459a65", attr: b }
  } else {
    { fg: "#cd0400", attr: b }
  }
}

$env.config.color_config.string = {||
  if $in =~ "^(#|0x)[a-fA-F0-9]+$" {
    $in | str replace "0x" "#"
  } else {
    "white"
  }
}

$env.config.color_config.row_index = { fg: "#f6c443", attr: b }
$env.config.color_config.header = { fg: "#f6c443", attr: b }

$env.config.color_config.shape_command = "#459a65"
$env.config.color_config.shape_external = "#459a65"
$env.config.color_config.shape_string = "#ea3d8d"
$env.config.color_config.shape_keyword = "#f6c443"
$env.config.color_config.shape_flag = "#3477f6"
$env.config.color_config.shape_option = "#3477f6"
$env.config.color_config.hints = "#484747"

do --env {
  $env.PROMPT_COMMAND = {||
    let hostname = try { hostname } catch { "arch" }
    let current_dir = pwd | path basename
    $"(ansi white)❬($hostname)❭ (ansi green)($current_dir)(ansi red) ●(ansi reset) "
  }
  $env.PROMPT_INDICATOR = ""
  $env.PROMPT_INDICATOR_VI_NORMAL = ""
  $env.PROMPT_INDICATOR_VI_INSERT = ""
  $env.PROMPT_MULTILINE_INDICATOR = ""
  $env.PROMPT_COMMAND_RIGHT = ""

  $env.TRANSIENT_PROMPT_INDICATOR = ""
  $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = ""
  $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = ""
  $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""
  $env.TRANSIENT_PROMPT_COMMAND = $env.PROMPT_COMMAND
  $env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
}

let menus = [
  {
    name: completion_menu
    only_buffer_difference: false
    marker: $env.PROMPT_INDICATOR
    type: {
      layout: ide
      min_completion_width: 0
      max_completion_width: 150
      max_completion_height: 25
      padding: 0
      border: false
      cursor_offset: 0
      description_mode: "prefer_right"
      min_description_width: 0
      max_description_width: 50
      max_description_height: 10
      description_offset: 1
      correct_cursor_pos: true
    }
    style: {
      text: white
      selected_text: white_reverse
      description_text: yellow
      match_text: { attr: u }
      selected_match_text: { attr: ur }
    }
  }
  {
    name: history_menu
    only_buffer_difference: true
    marker: $env.PROMPT_INDICATOR
    type: {
      layout: list
      page_size: 10
    }
    style: {
      text: white
      selected_text: white_reverse
    }
  }
]

$env.config.menus = $env.config.menus
| where name not-in ($menus | get name)
| append $menus

# Retrieve the output of the last command.
def _ []: nothing -> any {
  $env.last?
}

# Create a directory and cd into it.
def --env mc [path: path]: nothing -> nothing {
  mkdir $path
  cd $path
}

# Create a directory, cd into it and initialize version control.
def --env mcg [path: path]: nothing -> nothing {
  mkdir $path
  cd $path
  jj git init --colocate
}

# Load aliases
source aliases.nu

# Zoxide integration (smart cd with frecency)
source zoxide.nu

# Downloads housekeeping helpers
# Generate a non-clobbering destination path by appending " (n)" suffix
def __downloads-unique-dest [dest: path]: nothing -> path {
  if not ($dest | path exists) {
    $dest
  } else {
    let parsed = ($dest | path parse)
    let candidate = (
      (2..1000)
      | each {|i|
          if ($parsed.extension | is-empty) {
            $parsed.parent | path join $"($parsed.stem) ($i)"
          } else {
            $parsed.parent | path join $"($parsed.stem) ($i).($parsed.extension)"
          }
        }
      | prepend $dest
      | where {|p| not ($p | path exists) }
      | first
    )
    $candidate
  }
}

# Tidy up your Downloads folder by moving files into categorized subfolders.
# Simple: runs by default; add --dry-run to preview.
def "downloads tidy" [
  --dry-run (-n)              # preview only
  --path (-p): path           # explicit downloads directory
]: nothing -> any {
  let default_dir = if ($env.XDG_DOWNLOAD_DIR? | is-not-empty) { $env.XDG_DOWNLOAD_DIR } else { $env.HOME | path join "Downloads" }
  let root = (if ($path | is-not-empty) { $path } else { $default_dir }) | path expand

  if not ($root | path exists) {
    error make { msg: $"Downloads folder not found: ($root)" }
  }

  let categories = [
    { name: "Images"        , exts: [ "jpg","jpeg","png","gif","webp","bmp","tiff","tif","svg","heic","heif","avif" ] }
    { name: "Videos"        , exts: [ "mp4","mkv","webm","mov","avi","flv","wmv","m4v" ] }
    { name: "Audio"         , exts: [ "mp3","aac","flac","wav","ogg","oga","m4a","opus" ] }
    { name: "Archives"      , exts: [ "zip","tar","gz","tgz","bz2","xz","zst","7z","rar" ] }
    { name: "Documents"     , exts: [ "pdf","txt","md","rtf","odt","rtfd","tex","djvu","doc","docx","xps","json" ] }
    { name: "Spreadsheets"  , exts: [ "csv","tsv","xls","xlsx","ods" ] }
    { name: "Presentations" , exts: [ "ppt","pptx","key","odp" ] }
    { name: "Code"          , exts: [ "sh","bash","zsh","nu","py","js","mjs","ts","tsx","rs","go","c","h","cpp","hpp","java","kt","rb","php","html","css","yaml","yml","toml","sql","ipynb" ] }
    { name: "Fonts"         , exts: [ "ttf","otf","woff","woff2" ] }
    { name: "Books"         , exts: [ "epub","mobi","azw","azw3","cbz","cbr" ] }
    { name: "Subtitles"     , exts: [ "srt","ass","vtt","sub" ] }
    { name: "DiskImages"    , exts: [ "iso","img","dmg" ] }
    { name: "Installers"    , exts: [ "deb","rpm","pkg","msi","exe","appimage","apk","pup" ] }
    { name: "Torrents"      , exts: [ "torrent" ] }
    { name: "Logs"          , exts: [ "log" ] }
    { name: "Temp"          , exts: [ "crdownload","part","partial","tmp","zsync" ] }
  ]

  let ext_map = (
    $categories
    | reduce --fold {} {|row, acc|
        $row.exts
        | reduce --fold $acc {|e, acc2| $acc2 | upsert ($e | str downcase) $row.name }
      }
  )

  let files = (ls -a $root | where type == file)

  let plan = (
    $files
    | each {|f|
        let parsed = ($f.name | path parse)
        let ext = (try { $parsed.extension | str downcase } catch { "" })
        let cat = (try { $ext_map | get $ext } catch { "Other" })
        let dest_dir = ($root | path join $cat)
        let dest = (__downloads-unique-dest ($dest_dir | path join ($f.name | path basename)))
        { src: $f.name, dest: $dest, category: $cat, size: $f.size }
      }
  )

  if ($plan | is-empty) {
    print $"No files to move in ($root)."
  } else if $dry_run {
    print "Dry run:"
  } else {
    $plan | get dest | each {|p| mkdir ($p | path dirname) } | ignore
    $plan | each {|m| mv $m.src $m.dest } | ignore
    print $"Moved ($plan | length) files into categorized folders under ($root)."
  }

  $plan | select category src dest size | sort-by category src
}
