BASE = src/ti.coffee
APP = src/app/index.coffee src/app/properties.coffee
PLATFORM = src/platform/index.coffee
XML = src/xml/index.coffee
NETWORK = src/network/index.coffee
UI = src/ui/index.coffee \
	src/ui/iphone/index.coffee \
	src/ui/views/base.coffee \
	src/ui/views/activity_indicator.coffee \
	src/ui/views/button.coffee \
	src/ui/views/image_view.coffee \
	src/ui/views/label.coffee \
	src/ui/views/picker.coffee \
	src/ui/views/progress_bar.coffee \
	src/ui/views/scroll_view.coffee \
	src/ui/views/search_bar.coffee \
	src/ui/views/slider.coffee \
	src/ui/views/switch.coffee \
	src/ui/views/tabbed_bar.coffee \
	src/ui/views/tab_group.coffee \
	src/ui/views/table.coffee \
	src/ui/views/text_area.coffee \
	src/ui/views/text_field.coffee \
	src/ui/views/toolbar.coffee \
	src/ui/views/web_view.coffee \
	src/ui/views/window.coffee \
	src/ui/iphone/navigation_group.coffee \
	src/ui/ipad/split_window.coffee \
	src/ui/ios/ad_view.coffee

TI = $(BASE) $(APP) $(PLATFORM) $(XML) $(UI) $(NETWORK)

dist.js: $(TI)
	coffee --bare --join dist.js --compile $(TI)

.PHONY: build
