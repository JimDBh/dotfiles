# NeoVim config

Fancy screenshot for you:
![Neovim](https://user-images.githubusercontent.com/19470159/38351495-64efb4da-38b8-11e8-8454-f2e3d597b82c.png)
## Features:

### Plugins and stuff

#### Plugins
  - Linting C/C++ code via [ALE](https://github.com/w0rp/ale).
  - Autocompleting C/C++ via [deoplete.nvim](https://github.com/Shougo/deoplete.nvim) + [deoplete-clang](https://github.com/zchee/deoplete-clang).
  - Linting and autocompleting Rust via [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim) + [deoplete.nvim](https://github.com/Shougo/deoplete.nvim).
  - Generating ctags on the fly via [vim-autotag](https://github.com/craigemery/vim-autotag) and browsing current file tags with [tagbar](https://github.com/majutsushi/tagbar).
  - Snippets privided by [UltiSnips](https://github.com/sirver/UltiSnips), [vim-snippets](https://github.com/honza/vim-snippets) and my own ninja viml technique.
  - Browsing files with [Nerdtree](https://github.com/scrooloose/nerdtree).
  - Automatically inserting delimiters with [delimitMate](https://github.com/Raimondi/delimitMate).
  - Fuzzy finding any file, mru, tag via [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)

#### Some C/C++ cool stuff
  - Special regular expressions, to highlight language facilities like
  ```cpp
  typedef struct container {
  	int item1;
  	int item2;
  } container_t;
  
  container_t c;
  container_t* pc;
  
  c.item1;
  pc->item2;
  ```
  will look like so:
  
  ![image](https://user-images.githubusercontent.com/19470159/38468381-8797eeca-3b4d-11e8-9536-e82d79df3a75.png)
  - Some color fixes, so no end of buffer `~`s and less distracting signcolumn, and some nontext color fixes.
  
### Mappings and functions

#### Mappings:

  - <kbd>F1</kbd> - NOTHING
  - <kbd>F2</kbd> - Search and replace word under cursor
  - <kbd>*</kbd> - Highlight all occuriences of word under cursor, but dont move. No jumps added to jumplist.
  - <kbd>g</kbd><kbd>f</kbd> - Open file under cursor in new tab
  - <kbd>Alt</kbd>+<kbd>t</kbd> - Toggle bottom terminal window
  - <kbd>Alt</kbd>+<kbd>b</kbd> - Toggle tagbar window
  - <kbd>Alt</kbd>+<kbd>n</kbd> - Toggle nerdtree window
  - <kbd>g</kbd><kbd>b</kbd> - Go to next buffer
  - <kbd>g</kbd><kbd>B</kbd> - Go to privious buffer
  
  Danger zone:
  - <kbd>Ctrl</kbd>+<kbd>j</kbd> - Jump to next placeholder (my own snippets only)
  - <kbd>Ctrl</kbd>+<kbd>h</kbd> - Jump to next placeholder and replace all occurences (my own snippets only)

#### Functions:
  - `HighlightTypes()` - **WIP** not ready to use. Automatically highlights C/C++ user types as vim Type highlight group.
  - `RemoveTrailingSpaces()` - Removes all trailing whitespace on filesave
  - `Term_toggle(height)` - Toggless terminal on and off
  - `ExecuteMacroOverVisualRange()` - allows to execute <kbd>@</kbd> macro over visual selection
  - `ExpandOrClosePopup()` - allows to use <kbd>Enter</kbd> to expand UltiSnips snippet.
  - `SmartTab()` and `SmartSTab()` - allows to use <kbd>Tab</kbd> to jump through UltiSnips placeholders, and complete via deoplete.


## My snippets:
My snippets are based on abbreviations. It wasn't mentioned to use by enione else, but since i'm hosting my dotfiles on github, I think hat I should provide some explanations. That's main reason why my neovim dotfiles are filled up with comments.  
There are 4 categories for now:

1. Normal mode snippets:  
Snippet begins with comma and ends with Tab keypress. Basically the simplest one out there to use, all you need is to type ,snippetName and hit Tab to expand it. Cursor will be placed accordingly to snippet context, and mode will be changed to insert
                                                                             
2. Insert mode snippets:  
Snippets that are just abbreviations, yet a snippet with some cursor positioning.
                                                                             
3. Insert mode interactive snippets:  
These snippets are abbreviations too, but they end with a `/` symbol. The complicated part to understand is that these snippets must be ended with double press of `/` button: first press is part of abbreviation and the second one is part of `:%s///g` command that is executed at the end. This command will be used to replace all template names in the snippet to desired one.
                                                                             
4. Snippets with placeholders:  
I bet you never seen such stupid thing in your life. This snippets contain special markers, that can be jumped at. Markers are: `${1: }` - empty placeholder and `${1:text}` - placeholder containing standard text entry. When jump preformed with <kbd>Ctrl</kbd>+<kbd>j</kbd> (usable from any mode, be careful) the mapping will automatically delete all unnecessary symbols, and will leave you with placeholder text selected in select mode. You can modify it, or jump to next placeholder if you satisfied with standard placeholder's text. Examples can be found [here](https://github.com/andreyorst/dotfiles/blob/fde47c4417bd057707c2f34fbdbd366925acaf15/config/nvim/snippets.vim#L80)

### Here are some gifs:

#### Class snippet and getter+setter snippets:

![class](https://user-images.githubusercontent.com/19470159/38161104-1f8ef1c0-34d1-11e8-9ef6-3f4d6756b768.gif)

#### Main and for snippets:

![main_for](https://user-images.githubusercontent.com/19470159/38161066-c1d26f6c-34d0-11e8-8dcc-52c8aa5fd9d3.gif)

Placeholders will remain in text if you forget to jump on it. You can check if there any by pressing jump trigger again, but I agree that this is not best practice. There are plenty of snippet engines, like Ultisnips, snipMate, neosnippet and others may exist, but I've found it funny to create this on pure vim functional. It's not even a plugin, but just a sequence of keystrokes, mapped to abbreviations. It has some limitations, but can be used when snippet manager isn't avalible.

Other configurations may be found in config files itself. They are provided with comments, so it won't be big problem for you, if you will desire to try my setup, to figure out what is going on here and there.

Some plugins have huge comments like this one:
```vim
" NOTE: This piece of code is used to generate clang options for ALE,
" because we aren't using any build system. You may delete this, or
" rewrite to your project needs. Basically you can refer to a specific
" file in your project root, and automatically pass desired options to
" ALE, and later to Clang. But the main reason I wrote it because, we
" have special config file, that contains current includepath, for our
" own build system, so I need to pass it to ALE somehow and detect if
" it was changed. You can go further and have a separate if() for each
" project, I have two for now. I understand that this is not the most
" beautiful way of doing this, but, still, it works fine, and I'm kinda
" happy with this variant for now.
if filereadable("./testkit.settings")
	let g:includepath = system('echo -n
				\ -I $(pwd)/include
				\ -I $(pwd)/testpacks/SPW_TESTS/spw_lib_src
				\ -I $(pwd)/testpacks/CAN/can_lib_src
				\ -I $(pwd)/platforms/$(cat ./testkit.settings | grep "?=" |  sed -E "s/.*= //")/include
				\')
elseif filereadable("./startf.S")
	let g:includepath = system('echo -n
				\ -I $(pwd)/include
				\ -I $(pwd)/include/cp2
				\ -I $(pwd)/include/hdrtest
				\ -I $(pwd)../../include
				\')
endif

let g:ale_c_clang_options.= g:includepath
let g:ale_c_gcc_options.= g:includepath
```
You should pay attention to colored marks in comment sections, like `WARNING:`, `NOTE:` etc.

If you encounter any problem with my setup, feel free to open issue, we'll se what we can do here.
