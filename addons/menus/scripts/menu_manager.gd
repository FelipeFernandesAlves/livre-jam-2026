class_name MenuManager
extends Control

## The parent node of your [MenuPage]
## If null, the parent is set as this node.
@export var page_parent: Node

## The first page of the menu. [br]
## If null, the [member initial_page] is set as the first page in the node tree.
@export var initial_page: MenuPage

var pages: Dictionary[String, MenuPage]
var current_page: MenuPage
var last_page: MenuPage

func _format_page_name(page_name: String) -> String:
	return page_name.to_lower().strip_edges()

func _ready() -> void:
	if (!page_parent):
		page_parent = self

	for child in page_parent.get_children():
		if (child is MenuPage):
			add_page(child)
			page_parent.remove_child(child)
	
	change_page(_format_page_name(initial_page.name))

## Add a [MenuPage] in the [MenuManager] at runtime.
func add_page(new_page: MenuPage):
	pages.set( _format_page_name(new_page.name), new_page)
	new_page.change_page.connect(change_page)
	new_page.go_to_last_page.connect(go_to_last_page)

## Remove a [MenuPage] in the [MenuManager] at runtime.
func remove_page(page: MenuPage):
	pages.erase(_format_page_name(page.name))
	page.change_page.disconnect(change_page)
	page.go_to_last_page.disconnect(go_to_last_page)

## Change the active [MenuPage] given its name.
func change_page(page_name: String):
	var new_page: MenuPage = pages.get(_format_page_name(page_name))
	if (!new_page):
		push_error("Trying to access non-existing menu page: ", page_name)
		return
	
	if (current_page):
		current_page.page_exited.emit()
		await current_page.on_page_exited()
		last_page = current_page
		page_parent.remove_child(current_page)
	
	current_page = new_page
	page_parent.add_child(new_page)
	new_page.page_entered.emit()
	await new_page.on_page_entered()

## Change the active [MenuPage] to the last active page if it exists.
func go_to_last_page():
	if (last_page):
		change_page(_format_page_name(last_page.name))