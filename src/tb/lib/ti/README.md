# Current API supported by our custom $

## Extend:

### $()
* **$(el)**: Creates an array-like `ElementCollection` which the provided element (such as a Titanium View) as the first element of the collection.
* **$('<*viewName*>')**: Creates a new Titanium View based on the provided viewName and adds it to a new ElementCollection. For example:
	* `$('<View>')` creates a new [Titanium.UI.View](http://docs.appcelerator.com/titanium/latest/#!/api/Titanium.UI.View)
	* `$('<Button>')` creates a new [Titanium.UI.Button](http://docs.appcelerator.com/titanium/latest/#!/api/Titanium.UI.Button)
	* `$('<iPhone::NavigationGroup')` creates a new [Titanium.UI.iPhone.NavigationGroup](http://docs.appcelerator.com/titanium/latest/#!/api/Titanium.UI.iPhone.NavigationGroup)
* **$()** or **$(undefined)**: Creates an empty ElementCollection

## Attributes:

### .attr

**Note:** `class` is a reserved keyword in Javascript, so the `.attr` method will transparently change any `class` key passed to `.attr` to `_class`.

* **$(el).attr(key)**: Return the attribute specified by `key` for the first element in the collection.
* **$(el).attr(key, value)**: Set the attribute specified by `key` to `value` for each element in the collection.
* **$(el).attr(key, null)**: Remove the attribute specified by `key` for each element in the collection.
* * **$(el).attr(attrHash)**: Sets the attributes specified by `attrHash` for each element in the collection.

### .removeAttr

* **$(el).removeAttr(key)**: Remove the attribute specified by `key` for each element in the collection.

### .hasClass

* **$(el).hasClass(className)**: Determine whether any of the matched elements are assigned the given class.

### .addClass

* **$(el).addClass(className)**: Adds the specified class(es) to each of the set of matched elements.

### .removeClass

* **$(el).removeClass(className)**: Remove a single class, multiple classes, or all classes from each element in the set of matched elements.

### .text

The `text` method will set or get the appropriate attribute depending on the view type. For example, it will act against a Label's `text` attribute but a Button's `title` attribute.

* **$(el).text(newValue): Sets the text content of el.
* **$(el).text()**: Returns the text content of el

## Events:

### .on (alias 'bind')

* **$(el).on(event, handler)**: Binds `handler` to `event`.
* **$(el).on(event, selector, handler)**: Binds `handler` to the `event` on the closest element to `el` that matches `selector`.

### .off (alias 'unbind')

* **$(el).off(event, handler)**: Removes binding of `handler` to `event`.
* **$(el).off(event, selector, handler)**: Removes binding of `handler` to the `event` on the closest element to `el` that matches `selector`.
* **$(el).off(event)**: Removes all `event` handlers on `el`.
* **$(el).off()**: Removes all bindings on `el`.

### .delegate

* **$(el).delegate(selector, event, handler)**: Attach a `handler` to an `event` for all elements that match the `selector`, now or in the future, and are descendants of `el`.

### .undelegate

* **$(el).undelegate(selector, event, handler)**: Remove a `handler` from the `event` for all elements which match the `selector` and are descendants of `el`.

### .trigger

* **$(el).trigger(event, extraParameters)**: Execute all handlers and behaviors attached to the matched elements for the given event type.

### .triggerHandler

* **$(el).triggerHandler(event, extraParameters)**: Execute all handlers attached to an element for an event.

## Manipulation:

### .append

* **$(el).append(*childEl*)**: Insert content, specified by the `childEl` parameter, to the end of each element in the set of matched elements. `childEl` can be an existing element, an element collection, or a string used to create a new element (such as `<View>`).

### .appendTo

* **$(el).appendTo(*parentEl*)**: Append the `el` to `parentEl`. `parentEl` can be an existing element or an element collection (in which case the `el` will be appended to the first child).

### .remove

* **$(el).remove()**: Remove `el` from its parent if it has one.

### .empty

* **$(el).empty()**: Remove all children from `el`.

### .html

* **$(el).html(*childEl*)**: Replace the contents of el with childEl. This essentially combines $.empty() and $.append() and, while the name may not be optimal for this context (what is 'html' in Titanium?) it allows easier use of other Backbone libraries.

### .show

* **$(el).show()**: Show each element in the ElementCollection (`el` in this example).

### .hide

* **$(el).hide()**: Hide each element in the ElementCollection (`el` in this example).

## Traversal

### .each

* **$(el).each(fn)**: Iterate over an ElementCollection, executing a function (`fn`) for each matched element.

### .find

* **$(el).find(selector)**: Return an ElementCollection whose elements match the elements in the existing ElementCollection that match the provided selector.

### .map

* **$(el).map(fn)**: Pass each element in the current matched set through a function (`fn`), producing a new ElementCollection containing the return values.

### .get

* **$(el).get()**: Returns an array of all elements in the ElementCollection.
* **$(el).get(index)**: Returns the element (such as a Titanium View) at the specified index.

### .children

* **$(el).children()**: Returns an array of all child views of the ElementCollection. *Note: The returned children are NOT wrapped in an ElementCollection.*

### .parent

* **$(el).parent()**: Get the parent of each element in the current ElementCollection. *Note: The returned parent IS wrapped in an ElementCollection.*

### .is

* **$(el).is(selector)**: Returns a boolean indicating whether all elements in the current ElementCollection (`el` in this case) match the provided selector. This currently supports the following selectors:

	* *.someClass*: matches el with `_class='someClass'`
	* *#someId*: matches el with `id='someId'`
	* *View* # matches el with `_viewName='View'`. *`_viewName` (or an equivalent) is not provided by Titanium, at least not in a way that I've been able to find, so this attribute is added by ti.createView.*
  * *View.someClass*: matches el with `viewName='View'` and `_class='someClass'`

### .closest

* **$(el).closest(selector)**: For each element in the set, get the first element that matches the `selector` by testing the element itself and traversing up through its ancestors.

