class_name MenuFocusGroup
extends Control

@export var wrap_around: bool = true ## Se verdadeiro, ir para baixo no último item volta para o primeiro.
@export_enum("Vertical", "Horizontal") var orientation: int = 0 ## Define se a navegação usa cima/baixo ou esquerda/direita.

@export_custom(PROPERTY_HINT_INPUT_NAME, "show_builtin") var down_input: String = "ui_down"
@export_custom(PROPERTY_HINT_INPUT_NAME, "show_builtin") var up_input: String = "ui_up"
@export_custom(PROPERTY_HINT_INPUT_NAME, "show_builtin") var left_input: String = "ui_left"
@export_custom(PROPERTY_HINT_INPUT_NAME, "show_builtin") var right_input: String = "ui_right"

var _focusable_children: Array[Control] = []
var _current_focus_index: int = 0
var _can_redirect_focus: bool = false

func _ready() -> void:
	focus_mode = FocusMode.FOCUS_ALL
	call_deferred("_setup_children")
	focus_entered.connect(_on_focus_entered)

func _process(delta: float) -> void:
	if (_can_redirect_focus && !_focusable_children.is_empty()):
		_on_focus_entered()

func _setup_children() -> void:
	_focusable_children.clear()
	
	for child in get_children():
		if (child is Control && child.focus_mode != FocusMode.FOCUS_NONE):
			_focusable_children.append(child)
			
			if (!child.gui_input.is_connected(_on_child_gui_input.bind(child))):
				child.gui_input.connect(_on_child_gui_input.bind(child))
				
			if (!child.focus_entered.is_connected(_on_child_focus_entered.bind(child))):
				child.focus_entered.connect(_on_child_focus_entered.bind(child))

			if (!child.mouse_entered.is_connected(_on_child_mouse_entered.bind(child))):
				child.mouse_entered.connect(_on_child_mouse_entered.bind(child))

func _on_focus_entered() -> void:
	if (!_focusable_children.is_empty()):
		_current_focus_index = clampi(_current_focus_index, 0, _focusable_children.size() - 1)
		_focusable_children[_current_focus_index].grab_focus()
		_can_redirect_focus = false
	else:
		_can_redirect_focus = true

func _on_child_mouse_entered(child: Control) -> void:
	child.grab_focus()

func _on_child_focus_entered(child: Control) -> void:
	var index = _focusable_children.find(child)
	if index != -1:
		_current_focus_index = index

func _on_child_gui_input(event: InputEvent, child: Control) -> void:
	if not event.is_pressed() or event.is_echo():
		return

	var navigated := false
	
	if orientation == 0: # Vertical
		if event.is_action(down_input):
			_navigate(1)
			navigated = true
		elif event.is_action(up_input):
			_navigate(-1)
			navigated = true
	else: # Horizontal
		if event.is_action(right_input):
			_navigate(1)
			navigated = true
		elif event.is_action(left_input):
			_navigate(-1)
			navigated = true

	if navigated:
		child.accept_event() 

func _navigate(direction: int) -> void:
	if _focusable_children.is_empty():
		return
		
	_current_focus_index += direction
	
	if wrap_around:
		_current_focus_index = posmod(_current_focus_index, _focusable_children.size())
	else:
		_current_focus_index = clampi(_current_focus_index, 0, _focusable_children.size() - 1)
		
	_focusable_children[_current_focus_index].grab_focus()
