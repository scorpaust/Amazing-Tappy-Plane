## SOUND MANAGER MODULE FOR GODOT 3.1
## Version 2.3
## © Xecestel 2019
## Licensed Under MPL 2.0 (see below)

This Sound Manager gives the users a better control over the audio of their games. Setting the SoundManager.tscn scene as an AutoLoad on the ProjectSettings it is possible to play every sound of the game using just simple method calls. No more long AudioStreamPlayer lists inside your scenes nor long method to handle the audio inside every script.
It also gives you a better control over the Background Music. With this script it will not stop between scenes anymore, giving you the power to stop it and play  it whenever and however you want.


## How does it work?
This script uses some methods (you can see them below) that basically replace the default AudioStreamPlayer methods for easier usage. The only thing you need is to place all your game's sounds and musics of the same type (sound effects, bgms, bgss, music effects) on the same directories.


## Configuration
To use this script you have to set the scene as an AutoLoad in the ProjectSettings/AutoLoad tab. Remember: you need to set as an AutoLoad the scene (.tscn file) not the script (.gd file).

Configure the script is pretty simple:
First things first: if loading the scene from your editor throws you dependency issue with the script, just fix it clicking on the little folder icon on the left and selecting the SoundManager.gd file from you project directory.
First of all, you have to tell the script where your files are located. To do so, the script exports three variables: `BGM_DIR_PATH`, `BGS_DIR_PATH`, `SFX_DIR_PATH`, `MFX_DIR_PATH`. Open the SoundManager scene on the Godot editor and use the property tab to select the directories. They can be wherever you want inside your project main directory.

At this point, you have to use the dictionary. It allows you to use different strings for method calls and for the file names. This way, even if your audio file is called "*sfx_audio_jump.ogg*", you can set it in the dictionary to call it as a simple "Jump", adding a simple row `"Jump" : "sfx_audio_jump.ogg"`. This way, whenever you want to play that particular audio file, you will just have to call `SoundManager.play_se("Jump")` and the script will do the rest.
The dictionary is located inside the SoundManager_config file. You can place it wherever you want inside your project directory.
You can also edit the dictionary file from inside the scene editor, by working on the custom property. On the dictionary there is a placeholder key-value pair to give you an hint on the formatting expected from Godot.
You can also play sounds using their file names or absolute path. So if you want to play, from the example above, `"sfx_audio_jump.ogg"` you can either call `play_se("Jump")`, `play_se("sfx_audio_jump.ogg")` or `play_se("res://Assets/Audio/sfx_audio_jump.ogg")`. If you want to populate the dictionary, to just change the file names to something easier to remember or just use absolute paths it's up to you!

There are also other two useful, more advanced, variables:
- "Preload Resources". It's a boolean variable: if you set it to true the module will automatically load every audio resource from the given paths at `_ready()`. Note that this will slow down game start (especially in projects with a long list of audio files) but will make it faster to play sounds. It's completely optional.
- "Preinstantiate nodes". It's another boolean variable: if it's set to true the module will instantiate every needed AudioStreamPlayer node from start. This will make playing multiple sounds at once much faster, but note that it may also slow down your game.

## Methods
The main methods of this script are just 12, three for each section of the script (Background Music, Background Sounds, Sound Effects and Music Effecs), plus some useful setters and getters.

### Main Methods
#### Background Music
The main methods are basically the same but with some differents for background musics (see below), the only difference between them in the method calls is the suffix on the name (`play_bgm` instead of `play_me` for example, or `is_bgm_playing` instead of `is_me_playing`). They can be summarized in three categories:

- `func play(audio : String, reset_to_defaults : bool = true, full_path : bool = false) -> void`: this method lets you play the selected audio, passed as a string. If the audio is already playing, it won't do anything to avoid weird outcomes (or it will replace the previous one for BGMs). The `reset_to_defaults` argument lets you decide if you want the default values for the player property or not. It's useful if you often change volume and pitch (default value: `true`). `full_path` is a boolean variable that tells the Sound Manager if the given `audio` string is just a name, or the full absolute path of the resource. Note that you can't use `play_bgm` to play a sound effect or music effect and vice versa.

- `func stop(audio : String = "") -> void`: this method lets you stop the stream from playing. The argument (default value: `""`) gives you the ability to tell the stream to stop only if a specific sound is playing. You can either use the sound name, the file name or the file absolute path: the only thing that matters is that you use the same `audio` string you used to play the sound. Note that you can't use `stop_bgm` to stop a sound effect or music effect and vice versa.

- `func is_playing(audio : String = "") -> bool`: this method returns `true` if the selected stream is plaing and `false` if not. The argument (default value: `""`) gives you the ability to check if is playing a specific audio file by passing its name. You can either use the sound name, the file name or the file absolute path: the only thing that matters is that you use the same `audio` string you used to play the sound. Note that you can't use `is_bgm_playing` to check on a sound effect or music effect and vice versa.

#### Music Effects, Sound Effects and Background Sounds
From version 1.8 you can play multiple musice effects, multiple sound effects and multiple background sounds at once! This means that the methods to work with them are a little bit different in the method calls and require some more words:

- `func play(sound : String, reset_to_defaults : bool = true, full_path : bool = false, override_current_sound : bool = true, sound_to_override : String = "") -> void`: this method is basically the same as the other `play` methods, but comes with some more arguments. `override_current_sound` is an optional boolean variable that allows you to tell the Sound Manager to just replace an already playing sound with a new one. The default value is `true`, but if you go with a `false` the Sound Manager will play the sound without stopping the others, simultaneously. If you go with `true`, however, you can also decide which sound you want to override, by adding the sound name in the optional `sound_to_override` argument. If you don't do that, the Sound Manager automatically overrides the main stream (the one that is already on the scene).

- `stop` and `is_playing` are basically te same as the other sections, they just work differently internally. Note that whenever a Sound Effect or a Background Sound stream player stops (besides the main one), it's deleted from the scene.

- All the getters and setters now require the sound name in order to work. This argument is however always optional: if you don't put any argument in the method call, they'll just assume you are referring to the main AudioStreamPlayer.

- The `get_playing` method now returns an Array of all the currently playing sounds.

### Getters and Setters
- `func set_volume_db(volume_db : float) -> void`: this method allows you to change the selected stream volume via script. `volume_db` is the volume in decibels. (`set_bgm_volume_db` for bgm)

- `func get_volume_db() -> float`: this method return the volume of the given stream. (`get_bgm_volume_db` for bgm)

- `func set_pitch_scale(pitch : float) -> void`: this method allows you to set the pitch scale of the selected stream via script. (`set_bgm_pitch_scale` for bgm)

- `func get_pitch_scale() -> float`: this method returns the pitch scale of the given stream. (`get_bgm_pitch_scale` for bgm)

- `func pause(paused : bool) -> void`: this method allows you to pause or unpause the selected stream. (`pause_bgm` for bgm)

- `func is_paused() -> bool)`: this method returns `true` if the selected stream is paused. (`is_bgm_paused` for bgm)

- `func get_playing() -> String`: this methods (one for each type of audio) return a String contaning the currently playing or last played bgm, bgs, se, or me. (`get_playing_bgm` for bgm)

- `func get_configuration_dictionary() -> Dictionary`: this method returns the configuration dictionary as the user configured it.

- `func get_config_value(stream_name : String) -> String`: this method returns the file name of the given stream name. Returns `null` if an error occured.

- `func set_config_key(new_stream_name : String, new_stream_file : String) -> void`: this method allows the user to edit an existng value on the configuration dictionary, or add a new one in runtime. `new_stream_name` is the name of your choice for the stream (the key in the dictionary), while `new_stream_file` is the name of the file linked to it (the value in the dictionary).

- `func is_preload_resources_enabled() -> bool`: this method returns true if the module has been set to preload resources.


## IMPORTANT NOTES:
If this docs wasn't enough for you to understand how this module works, or you just want to see it in action, check out my game [*50 Years Later*](https://gitlab.com/Xecestel/50-years-later).

You cannot use this SoundManager to handle AudioStreamPlayer2D or AudioStreamPlayer3D nodes. Those kind of players can only be handled inside the scenes that need to play them.

If you have issues or concerns about this script you can contact me by opening an issue ticket on my [GitLab](https://gitlab.com/xecestel). You can also find me on Twitter ([@Xecestel](https://twitter.com/xecestel)) if you want to contact me.


# Credits
I'd like to thank Simón Olivo (@sarturo) for the help and support he's providing on this project.


# Licenses
Sound Manager
Copyright (C) 2019  Celeste Privitera

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at [https://mozilla.org/MPL/2.0/](https://mozilla.org/MPL/2.0/).

You can find more informations in the LICENSE.txt file.


# Changelog

### Version 1.0
- Script complete.

### Version 1.1
- Added getters and setters.

### Version 1.2
- Improved `stop` methods.
- Fixed a bug in the `play_me` method code.

### Version 1.3
- Audio File Dictionary exported to the scene editor: now you can edit it from the scene itself.
- Bug fix: fixed a code line on the `stop_bgm` method.
- Moved the scripts into the internal_scripts folder and the scene outside to make it more visible.

### Version 1.3.1
- Bug fixes

### Version 1.3.2
- Fixed script dependency bug (thanks to @sarturoDev!)

### version 1.4
- Added BGS node to control Background Sounds (like rain or birds chirping)
- Added new setters and getters for node properties, like volume and pitch

### Version 1.5
- Now you can play more sound effects at once

### Version 1.5.1
- Moved files on a single directory

### Version 1.5.2
- Fixed a bug in SoundEffects.gd script

### Version 1.6
- Now the dictionary is optional: see configuration section for more informations
- Bug fix and optimizations

### Version 1.7
- Now you can play multiple Background Sounds at once
- Fixed bugs, improved optimization and readability

### Version 1.8
- Now you can play multiple Music Effects at once
- Fixed bugs, improved readability

## Version 2.0
- Now the module is part of the Sound Manager Plugin

## Version 2.1
- Added optional resource preloading

## Version 2.2
- Added optional node pre-instantiation

## Version 2.3
- Now you can pass absolute path to the module to play sounds
