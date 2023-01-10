SHELL = bash
EMACS = emacs

THEME_ROOT = org/themes
ORG_HTML_THEMES = $(THEME_ROOT)/org-html-themes
THEME_DIR_CURRENT = $(THEME_ROOT)/current
THEME_SETUP = $(THEME_DIR_CURRENT)/theme.setup
THEME_STATIC_SRC = $(THEME_DIR_CURRENT)/static/src
#THEME_STATIC = $(THEME_STATIC_DIR)/theme.static

all: build

help:
	@echo "Usage:"
	@echo "  make build              ドキュメントを生成します。"
	@echo "  make dist               配布物を生成します。"
	@echo "  make theme-readtheorg   テーマを Read the org にします。"
	@echo "  make theme-bigblow      テーマを Bigblow にします。"

fix-clock-wsl:
	@if [ ! -n "$$INVOKED_FROM_MYSELF" ] && [[ $$(uname -r) =~ microsoft-standard-WSL2 ]]; then skew=$$(ntpdate -p 1 -d ntp.nict.jp 2>/dev/null | egrep "^offset" | tail -1 | sed -e 's,^offset \([0-9]*\).*$$,\1,'); if [ $$skew -ge 5 ]; then echo "時刻が $$skew 秒ずれています。クロックを修正します"; sudo ntpdate ntp.nict.jp; $(MAKE) -f $(lastword $(MAKEFILE_LIST)) INVOKED_FROM_MYSELF=1 $(MAKECMDGOALS); fi; fi;

build: | prep-once fix-clock-wsl
	$(RM) org/build; cd org; $(EMACS) -q -l org-publish.el -f 'kill-emacs'

build-debug: | prep-once fix-clock-wsl
	$(RM) org/build; cd org; $(EMACS) -q --debug-init -l org-publish.el --eval '(switch-to-buffer "*Messages*")'

dist: build
	rm -rf dist
	cp -rT org/build dist
	find dist -type f -name '*~' | xargs rm -f
	cp setup/setup.bat -t dist
	cp -r setup/scripts -t dist

clean:
	$(RM) -r build

distclean: clean
	$(RM) -r dist

prep-once:
	@if ! which "$(EMACS)" >/dev/null; then \
		if [[ "$(EMACS)" =~ ^(/usr/bin/)?emacs$$ ]]; then \
			sudo apt-get install -y emacs; \
		else \
			echo "$(EMACS) が見つかりません"; \
		fi; \
	fi
	@if [ ! -d org/themes/current ]; then $(MAKE) theme-readtheorg; fi
	@if [ ! -d org/htmlize ]; then git -C org clone "https://github.com/hniksic/emacs-htmlize.git" htmlize; fi

theme-pre-copy:
	if [ ! -d $(ORG_HTML_THEMES) ]; then mkdir -p themes; git -C themes clone "https://github.com/fniessen/org-html-themes.git"; fi
	rm -rf $(THEME_DIR_CURRENT)
	mkdir -p $(THEME_STATIC_SRC)
	cp -r $(ORG_HTML_THEMES)/src/lib $(THEME_STATIC_SRC)

theme-readtheorg: | theme-pre-copy
	cp $(ORG_HTML_THEMES)/org/theme-readtheorg-local.setup $(THEME_SETUP)
	mkdir -p $(THEME_STATIC_SRC)/readtheorg_theme
	cp -r $(ORG_HTML_THEMES)/src/readtheorg_theme/* $(THEME_STATIC_SRC)/readtheorg_theme
	rm $(THEME_STATIC_SRC)/readtheorg_theme/readtheorg.org

theme-bigblow: | theme-pre-copy
	cp $(ORG_HTML_THEMES)/org/theme-bigblow-local.setup $(THEME_SETUP)
	mkdir -p $(THEME_STATIC_SRC)/bigblow_theme
	cp -r $(ORG_HTML_THEMES)/src/bigblow_theme/* $(THEME_STATIC_SRC)/bigblow_theme
	rm $(THEME_STATIC_SRC)/bigblow_theme/bigblow.org

.PHONY: all build dist clean distclean prep-once theme-pre-copy theme-readtheorg theme-bigblow
