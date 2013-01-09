BASE = src/ti.coffee
APP = src/app/index.coffee src/app/properties.coffee
PLATFORM = src/platform/index.coffee
UI = src/ui/index.coffee \
	src/ui/iphone/index.coffee \
	src/ui/views/base.coffee \
	src/ui/views/button.coffee \
	src/ui/views/label.coffee \
	src/ui/views/tab_group.coffee \
	src/ui/views/table.coffee \
	src/ui/views/text_field.coffee \
	src/ui/views/window.coffee \
	src/ui/iphone/navigation_group.coffee

TI = $(BASE) $(APP) $(PLATFORM) $(UI)

dist.js: $(TI)
	coffee --bare --join dist.js --compile $(TI)

.PHONY: build