extends Control

func fill_bar():
	$Prompt.visible = false
	$ProgressBar.visible = true
	$Loading_label.visible = true
	var tween = create_tween()
	tween.tween_property($ProgressBar, "value", 100, 3)
