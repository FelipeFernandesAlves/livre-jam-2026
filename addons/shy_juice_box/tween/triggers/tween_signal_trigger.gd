@tool
class_name TweenSignalTrigger
extends TweenTrigger

var once_signal: String = ""
var show_signal: String = ""
var hide_signal: String = ""

func _init() -> void:
    if not target_changed.is_connected(_on_target_changed):
        target_changed.connect(_on_target_changed)

func _on_target_changed() -> void:
    if Engine.is_editor_hint():
        set_target_editor()
    else:
        connect_runtime_signals()

func set_target_editor() -> void: 
    if target:
        if not target.has_signal(show_signal): show_signal = ""
        if not target.has_signal(hide_signal): hide_signal = ""
        if not target.has_signal(once_signal): once_signal = ""
    notify_property_list_changed()

func connect_runtime_signals() -> void:
    if not target: return
    if target.has_signal(show_signal) and not target.is_connected(show_signal, trigger_start):
        target.connect(show_signal, trigger_start)
    if target.has_signal(hide_signal) and not target.is_connected(hide_signal, trigger_end):
        target.connect(hide_signal, trigger_end)
    if target.has_signal(once_signal) and not target.is_connected(once_signal, trigger_once):
        target.connect(once_signal, trigger_once)

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []
    var signal_options: String = ""

    if target:
        var signal_list: Array = target.get_signal_list()
        var signal_names: Array[String] = []
        for sig in signal_list:
            signal_names.append(sig["name"])
        signal_options = ",".join(signal_names)

    if tweener == null or tweener is TweenOnce:
        properties.append({
            "name": "once_signal",
            "type": TYPE_STRING,
            "hint": PROPERTY_HINT_ENUM, 
            "hint_string": signal_options,
            "usage": PROPERTY_USAGE_DEFAULT
        })

    if tweener == null or tweener is AutoTween:
        properties.append({
            "name": "show_signal",
            "type": TYPE_STRING,
            "hint": PROPERTY_HINT_ENUM, 
            "hint_string": signal_options,
            "usage": PROPERTY_USAGE_DEFAULT
        })
        properties.append({
            "name": "hide_signal",
            "type": TYPE_STRING,
            "hint": PROPERTY_HINT_ENUM, 
            "hint_string": signal_options,
            "usage": PROPERTY_USAGE_DEFAULT
        })
    
    return properties