buildTi:
	coffee --bare --join ti/dist.js --compile \
		ti/src/ti.coffee \
		ti/src/app/index.coffee \
		ti/src/app/properties.coffee \
		ti/src/platform/index.coffee \
		ti/src/ui/index.coffee \
		ti/src/ui/views/base.coffee \
		ti/src/ui/iphone/index.coffee \
		ti/src/ui/views/button.coffee \
		ti/src/ui/views/label.coffee \
		ti/src/ui/views/scroll_view.coffee \
		ti/src/ui/views/search_bar.coffee \
		ti/src/ui/views/tab_group.coffee \
		ti/src/ui/views/table.coffee \
		ti/src/ui/views/text_area.coffee \
		ti/src/ui/views/text_field.coffee \
		ti/src/ui/views/window.coffee \
		ti/src/ui/iphone/navigation_group.coffee \
		ti/src/map/index.coffee \
		ti/src/map/view.coffee

.PHONY: buildTi