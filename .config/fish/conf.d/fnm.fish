# fnm
set PATH "/Users/ingvar/Library/Application Support/fnm" $PATH
fnm env | source

# fnm
set FNM_PATH "/home/ingvar/.local/share/fnm"
if [ -d "$FNM_PATH" ]
  set PATH "$FNM_PATH" $PATH
  fnm env | source
end
