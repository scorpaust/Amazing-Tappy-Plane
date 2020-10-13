extends SoundManager

####################################################################
#	SOUND MANAGER MODULE FOR GODOT 3.1
#			Version 2.3
#			© Xecestel
####################################################################
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
#####################################
#variables#
export (String, DIR) var BGM_DIR_PATH	= "res://sound_manager/dock";
export (String, DIR) var BGS_DIR_PATH	= "res://sound_manager/dock";
export (String, DIR) var SFX_DIR_PATH	= "res://sound_manager/dock";
export (String, DIR) var MFX_DIR_PATH	= "res://sound_manager/dock";
export (bool) var preload_resources		= false;
export (bool) var preinstantiate_nodes	= false;

onready var BGM_Audiostream		= get_node("BGM");
onready var BGS_Audiostreams	= $BackgroundSounds.get_children();
onready var SE_Audiostreams		= $SoundEffects.get_children();
onready var ME_Audiostreams		= $MusicEffects.get_children();
onready var soundmgr_dir_rel_path = self.get_script().get_path().get_base_dir();

var bgm_playing				: String;
var bgs_playing				: Array		= [ "BGS0" ];
var se_playing				: Array		= [ "SE0" ];
var me_playing				: Array		= [ "ME0" ];

var bgm_bus					: String = "Master";
var bgs_bus					: String = "Master";
var sfx_bus					: String = "Master";
var mfx_bus					: String = "Master";

var Preloaded_Resources : Dictionary = {};
###########

func _ready() -> void:
	get_sound_manager_settings();
	load_settings();
	
	if (preload_resources && Preloaded_Resources.empty()):
		print_debug("Preloading...");
		self.preload_audio_files();
	if (preinstantiate_nodes):
		print_debug("Instantiating nodes...");
		self.preinstantiate_nodes();
#end

#####################################
#	SOUND MANAGER SETTINGS HANDLING	#
#####################################

#Load the Sound Manager settings from the JSON file:  SoundManager.json
func get_sound_manager_settings()-> void:
	var data_settings : Dictionary;
	var file: File = File.new();
	file.open("res://addons/sound_manager/SoundManager.json", File.READ);
	var json : JSONParseResult = JSON.parse(file.get_as_text());
	file.close();
	if (typeof(json.result) == TYPE_DICTIONARY):
		data_settings = json.result;
		BGM_DIR_PATH = data_settings["BGM_DIR_PATH"];
		BGS_DIR_PATH = data_settings["BGS_DIR_PATH"];
		SFX_DIR_PATH = data_settings["SFX_DIR_PATH"];
		MFX_DIR_PATH = data_settings["MFX_DIR_PATH"];
		
		bgm_bus = data_settings["BGM_BUS_NAME"];
		bgs_bus = data_settings["BGS_BUS_NAME"];
		sfx_bus = data_settings["SFX_BUS_NAME"];
		mfx_bus = data_settings["MFX_BUS_NAME"];
	
		Audio_Files_Dictionary = data_settings["Dictionary"];
		
		preload_resources = data_settings["PRELOAD_RES"];
		preinstantiate_nodes = data_settings["PREINSTANTIATE_NODES"];
	else:
		print_debug("Failed to load the sound manager's settings file: " + 'res://addons/sound_manager/SoundManager.json');
		return;
#end


func load_settings() -> void:
	BGM_DIR_PATH = self.normalize_path(BGM_DIR_PATH);
	BGS_DIR_PATH = self.normalize_path(BGS_DIR_PATH);
	SFX_DIR_PATH = self.normalize_path(SFX_DIR_PATH);
	MFX_DIR_PATH = self.normalize_path(MFX_DIR_PATH);
	
	BGM_Audiostream.set_bus(bgm_bus);
	BGS_Audiostreams[0].set_bus(bgs_bus);
	SE_Audiostreams[0].set_bus(sfx_bus);
	ME_Audiostreams[0].set_bus(mfx_bus);
#end


func normalize_path(path : String) -> String:
	if (path == "res://"):
		path = path.substr(0, 5);
	return path;
#end

#####################
#	BGM HANDLING	#
#####################

#Plays a given bgm
func play_bgm(bgm : String, reset_to_defaults : bool = true, full_path : bool = false) -> void:
	if (bgm == "" || bgm == null):
		print_debug("No BGM selected.");
		return;
	if (self.is_bgm_playing(bgm)):
		return;
	
	var bgm_file_name = bgm if (bgm.get_extension() != "") else Audio_Files_Dictionary.get(bgm);
	if (bgm_file_name == null):
		print_debug("Error: file not found " + bgm);
		return;
	
	var Stream;
	if (preload_resources && Preloaded_Resources.has(bgm_file_name)):
		Stream = Preloaded_Resources.get(bgm_file_name);
	else:
		var bgm_file_path = BGM_DIR_PATH + "/" + bgm_file_name if (full_path == false) else bgm_file_name;
		Stream = load(bgm_file_path);
		
		if (Stream == null):
			print_debug("Failed to load file from path: " + bgm_file_path);
			return;
	
	self.stop_bgm();
	self.pause_bgm(false);
	
	if (reset_to_defaults):
		self.set_bgm_pitch_scale(1.0);
		self.set_bgm_volume_db(0.0);
	BGM_Audiostream.set_stream(Stream);
	BGM_Audiostream.play();
	bgm_playing = bgm;
#end

func stop_bgm(bgm : String = "") -> void:
	if (bgm != ""):
		if (self.is_bgm_playing(bgm)):
			BGM_Audiostream.stop();
			return;
			
	BGM_Audiostream.stop();
#end

func is_bgm_playing(bgm : String = "") -> bool:
	if (bgm == null || bgm == ""):
		return BGM_Audiostream.is_playing();
	return (bgm_playing == bgm && BGM_Audiostream.is_playing());
#end

func set_bgm_volume_db(volume_db : float) -> void:
	BGM_Audiostream.set_volume_db(volume_db);
#end

func get_bgm_volume_db() -> float:
	return BGM_Audiostream.get_volume_db();
#end

func set_bgm_pitch_scale(pitch : float) -> void:
	BGM_Audiostream.set_pitch_scale(pitch);
#end

func get_bgm_pitch_scale() -> float:
	return BGM_Audiostream.get_pitch_scale();
#end

func pause_bgm(paused : bool) -> void:
	BGM_Audiostream.set_stream_paused(paused);
#end

func is_bgm_paused() -> bool:
	return BGM_Audiostream.get_paused();
#end


#####################
#	BGS HANDLING	#
#####################

#Plays a given bgm
func play_bgs(bgs : String, reset_to_defaults : bool = true, full_path : bool = false, override_current_sound : bool = true, sound_to_override : String = "") -> void:
	if (bgs == "" || bgs == null):
		print_debug("No BGS selected.");
		return;
	BGS_Audiostreams = $BackgroundSounds.get_children();
		
	if (preinstantiate_nodes):
		var bgs_index = self.find_bgs(bgs);
		if (bgs_index < 0):
			print_debug("BGS not found");
			return;
		BGS_Audiostreams[bgs_index].play();
		return;
		
	if (override_current_sound):
		if (self.is_bgs_playing(bgs)):
			return;
			
	var bgs_file_name = bgs if (bgs.get_extension() != "") else Audio_Files_Dictionary.get(bgs);
	if (bgs_file_name == null):
		print_debug("Error: file not found " + bgs);
		return;
		
	var Stream;
	if (preload_resources && Preloaded_Resources.has(bgs_file_name)):
		Stream = Preloaded_Resources.get(bgs_file_name);
	else:
		var bgs_file_path = BGS_DIR_PATH + "/" + bgs_file_name if (full_path == false) else bgs_file_name;
		Stream = load(bgs_file_path);
		
		if (Stream == null):
			print_debug("Failed to load file from path: " + bgs_file_path);
			return;
		
	var bgs_index = 0;
	
	if (override_current_sound):
		if (sound_to_override != "" && sound_to_override != null):
			bgs_index = bgs_playing.find(sound_to_override);
			
		if (bgs_index < 0):
			print_debug("Sound not found: " + sound_to_override);
		
		if (reset_to_defaults):
			self.stop_bgs(sound_to_override);
			self.pause_bgs(false, sound_to_override);
			self.set_bgs_pitch_scale(1.0, sound_to_override);
			self.set_bgs_volume_db(0.0, sound_to_override);
	else:
		bgs_index = self.add_background_sound(bgs);
		
	BGS_Audiostreams[bgs_index].set_stream(Stream);
	BGS_Audiostreams[bgs_index].play();
	bgs_playing[bgs_index] = bgs;
#end

func stop_bgs(bgs : String = "") -> void:
	var bgs_index = 0;
	if (bgs != "" && bgs != null):
		if (self.is_bgs_playing(bgs)):
			bgs_index = bgs_playing.find(bgs);
			if (preinstantiate_nodes == false):
				self.erase_background_sound(bgs);
			
	BGS_Audiostreams[bgs_index].stop();
#end

func is_bgs_playing(bgs : String = "") -> bool:
	var bgs_index = self.find_bgs(bgs);
	
	if (bgs_index < 0):
		return false;
	elif (bgs_index >= 1):
		return true;
			
	return BGS_Audiostreams[0].is_playing();
#end

func set_bgs_volume_db(volume_db : float, bgs : String = "") -> void:
	var bgs_index = self.find_bgs(bgs);
	if (bgs_index < 0):
		print_debug("Sound not found: " + bgs);
		return;
	BGS_Audiostreams[bgs_index].set_volume_db(volume_db);
#end

func get_bgs_volume_db(bgs : String = "") -> float:
	var bgs_index = self.find_bgs(bgs);
	if (bgs_index < 0):
		print_debug("Sound not found: " + bgs);
		return -1.0;
	return BGS_Audiostreams[bgs_index].get_volume_db();
#end
	
func set_bgs_pitch_scale(pitch : float, bgs : String = "") -> void:
	var bgs_index = self.find_bgs(bgs);
	if (bgs_index < 0):
		print_debug("Sound not found: " + bgs);
		return;
	BGS_Audiostreams[bgs_index].set_pitch_scale(pitch);
#end

func get_bgs_pitch_scale(bgs : String = "") -> float:
	var bgs_index = self.find_bgs(bgs);
	if (bgs_index < 0):
		print_debug("Sound not found: " + bgs);
		return -1.0;
			
	return BGS_Audiostreams[bgs_index].get_pitch_scale();
#end
	
func pause_bgs(paused : bool, bgs : String = "") -> void:
	var bgs_index = self.find_bgs(bgs);
	if (bgs_index < 0):
		print_debug("Sound not foun: " + bgs);
		return;
	BGS_Audiostreams[bgs_index].set_stream_paused(paused);
#end

func is_bgs_paused(bgs : String = "") -> bool:
	var bgs_index = self.find_bgs(bgs);
	if (bgs_index < 0):
		print_debug("Sound not found: " + bgs);
		return false;
		
	return BGS_Audiostreams[bgs_index].get_stream_paused();
#end

#############################
#	SOUND EFFECTS HANDLING	#
#############################

#Plays selected Sound Effect
func play_se(sound_effect : String, reset_to_defaults : bool = true, full_path : bool = false, override_current_sound : bool = true, sound_to_override : String = "") -> void:
	if (sound_effect == "" || sound_effect == null):
		print_debug("No sound effect selected.");
		return;
	SE_Audiostreams = $SoundEffects.get_children();
		
	if (preinstantiate_nodes):
		var se_index = self.find_se(sound_effect);
		if (se_index < 0):
			print_debug("BGS not found");
			return;
		SE_Audiostreams[se_index].play();
		return;
	if (override_current_sound):
		if (self.is_se_playing(sound_effect)):
			return;
		
	var sound_effect_file_name = sound_effect if (sound_effect.get_extension() != "") else Audio_Files_Dictionary.get(sound_effect);
	if (sound_effect_file_name == null):
		print_debug("Error: file not found " + sound_effect);
		return;
		
	var Stream;
	if (preload_resources && Preloaded_Resources.has(sound_effect_file_name)):
		Stream = Preloaded_Resources.get(sound_effect_file_name);
	else:
		var sound_effect_path = SFX_DIR_PATH + "/" + sound_effect_file_name if (full_path == false) else sound_effect_file_name;
		Stream = load(sound_effect_path);
		
		if (Stream == null):
			print_debug("Failed to load file from path: " + sound_effect_path);
			return;
	
	var se_index = 0;
	
	if (override_current_sound):
		if (sound_to_override != "" && sound_to_override != null):
			se_index = se_playing.find(sound_to_override);
			
		if (se_index < 0):
			print_debug("Sound not found: " + sound_to_override);
			return;
			 
		if (reset_to_defaults):
			self.set_se_pitch_scale(1.0, sound_to_override);
			self.set_se_volume_db(0.0, sound_to_override);
	else:
		se_index = self.add_sound_effect(sound_effect);
		
	SE_Audiostreams[se_index].set_stream(Stream);
	SE_Audiostreams[se_index].play();
	SE_Audiostreams[se_index].set_sound_name(sound_effect);
	se_playing[se_index] = sound_effect;
#end

#Stops selected Sound Effect
func stop_se(sound_effect : String = "") -> void:
	var se_index = 0;
	if (sound_effect != "" && sound_effect != null):
		if (self.is_se_playing(sound_effect)):
			se_index = se_playing.find(sound_effect);
			if (preinstantiate_nodes == false):
				self.erase_sound_effect(sound_effect);
	
	SE_Audiostreams[se_index].stop();
#end

#Returns true if the selected Sound Effect is already playing
func is_se_playing(sound_effect : String = "") -> bool:
	if (sound_effect != "" || sound_effect != null):
		var se_index = se_playing.find(sound_effect);
		if (se_index < 0):
			return false;
		elif (se_index >= 1):
			return true;
			
	return SE_Audiostreams[0].is_playing();
#end

func set_se_volume_db(volume_db : float, sound_effect : String = "") -> void:
	var se_index = self.find_se(sound_effect);
	if (se_index < 0):
		print_debug("Sound not found: " + sound_effect);
		return;
	SE_Audiostreams[se_index].set_volume_db(volume_db);
#end

func get_se_volume_db(sound_effect : String = "") -> float:
	var se_index = self.find_se(sound_effect);
	if (se_index < 0):
		print_debug("Sound not found: " + sound_effect);
		return -1.0;
	return SE_Audiostreams[se_index].get_volume_db();
#end
	
func set_se_pitch_scale(pitch : float, sound_effect : String = "") -> void:
	var se_index = self.find_se(sound_effect);
	if (se_index < 0):
		print_debug("Sound not found: " + sound_effect);
		return;
	SE_Audiostreams[se_index].set_pitch_scale(pitch);
#end

func get_se_pitch_scale(sound_effect : String = "") -> float:
	var se_index = self.find_se(sound_effect);
	if (se_index < 0):
		print_debug("Sound not found: " + sound_effect);
		return -1.0;
	return SE_Audiostreams[se_index].get_pitch_scale();
	
func pause_se(paused : bool, sound_effect : String = "") -> void:
	var se_index = self.find_se(sound_effect);
	if (se_index < 0):
		print_debug("Sound not found: " + sound_effect);
		return;
	SE_Audiostreams[se_index].set_stream_paused(paused);
#end

func is_se_paused(sound_effect : String = "") -> bool:
	var se_index = self.find_se(sound_effect);
	if (se_index < 0):
		print_debug("Sound not found: " + sound_effect);
		return false;
	return SE_Audiostreams[se_index].get_stream_paused();
#end

#############################
#	Music Effects Handling	#
#############################

func play_me(music_effect : String, reset_to_defaults : bool = true, full_path : bool = false, override_current_sound : bool = true, sound_to_override : String = "") -> void:
	if (music_effect == "" || music_effect == null):
		print_debug("No sound effect selected.");
		return;
	ME_Audiostreams = $MusicEffects.get_children();
		
	if (preinstantiate_nodes):
		var me_index = self.find_me(music_effect);
		if (me_index < 0):
			print_debug("BGS not found");
			return;
		ME_Audiostreams[me_index].play();
		return;
	if (override_current_sound):
		if (self.is_me_playing(music_effect)):
			return;
	
	
	var music_effect_file_name = music_effect if (music_effect.get_extension() != "") else Audio_Files_Dictionary.get(music_effect);
	if (music_effect_file_name == null):
		print_debug("Error: file not found " + music_effect);
		return;
	
	var Stream;
	if (preload_resources && Preloaded_Resources.has(music_effect_file_name)):
		Stream = Preloaded_Resources.get(music_effect_file_name);
	else:
		var music_effect_path = MFX_DIR_PATH + "/" + music_effect_file_name if (full_path == false) else music_effect_file_name;
		Stream = load(music_effect_path);
		
		if (Stream == null):
			print_debug("Failed to load file from path: " + music_effect_path);
			return;
		
	var me_index = 0;
	
	if (override_current_sound):
		if (sound_to_override != "" && sound_to_override != null):
			me_index = me_playing.find(sound_to_override);
			
			if (me_index < 0):
				print_debug("Sound not found: " + sound_to_override);
				return;
			if (reset_to_defaults):
				self.set_me_pitch_scale(1.0, sound_to_override);
				self.set_me_volume_db(0.0, sound_to_override);
		else:
			me_index = add_music_effect(music_effect);
		
	ME_Audiostreams[me_index].set_stream(Stream);
	ME_Audiostreams[me_index].play();
	ME_Audiostreams[me_index].set_sound_name(music_effect);
	me_playing[me_index] = music_effect;
#end

func stop_me(music_effect : String = "") -> void:
	var me_index = 0;
	if (music_effect != "" && music_effect != null):
		if (self.is_me_playing(music_effect)):
			me_index = me_playing.find(music_effect);
			if (preinstantiate_nodes == false):
				self.erase_music_effect(music_effect);
			
	ME_Audiostreams[me_index].stop();
#end

func is_me_playing(music_effect : String = "") -> bool:
	if (music_effect != "" || music_effect != null):
		var me_index = me_playing.find(music_effect);
		if (me_index < 0):
			return false;
		elif (me_index >= 1):
			return true;
	return ME_Audiostreams[0].is_playing();
#end

func set_me_volume_db(volume_db : float, music_effect : String = "") -> void:
	var me_index = self.find_me(music_effect);
	if (me_index < 0):
		print_debug("Sound not found: " + music_effect);
		return;
	ME_Audiostreams[me_index].set_volume_db(volume_db);
#end

func get_me_volume_db(music_effect : String = "") -> float:
	var me_index = self.find_me(music_effect);
	if (me_index < 0):
		print_debug("Sound not found: " + music_effect);
		return -1.0;
	return ME_Audiostreams[me_index].get_volume_db();
#end
	
func set_me_pitch_scale(pitch : float, music_effect : String = "") -> void:
	var me_index = self.find_me(music_effect);
	if (me_index < 0):
		print_debug("Soud not found: " + music_effect);
		return;
		
	ME_Audiostreams[me_index].set_pitch_scale(pitch);
#end

func get_me_pitch_scale(music_effect : String = "") -> float:
	var me_index = self.find_me(music_effect);
	if (me_index < 0):
		print_debug("Sound not found: " + music_effect);
		return -1.0;
	return ME_Audiostreams[me_index].get_pitch_scale();
#end

func pause_me(paused : bool, music_effect : String = "") -> void:
	var me_index = self.find_me(music_effect);
	if (me_index < 0):
		print_debug("Sound not found: " + music_effect);
		return;
	ME_Audiostreams[me_index].set_stream_paused(paused);
#end

func is_me_paused(music_effect : String = "") -> bool:
	var me_index = self.find_me(music_effect);
	if (me_index < 0):
		print_debug("Sound not found: " + music_effect);
		return false;
	return ME_Audiostreams[me_index].get_stream_paused();
#end


#################################
#		GETTERS AND SETTERS		#
#################################

#Returns the name of the currently playing (or last played) bgm
func get_playing_bgm() -> String:
	return bgm_playing;
#end

#Returns the name of the currently playing (or last played) bgs
func get_playing_bgs() -> Array:
	return bgs_playing;
#end

#Returns the name of the currently playing sound effects
func get_playing_se_array() -> Array:
	return se_playing;
#end

#Returns the name of the currently playing music effects
func get_playing_me() -> Array:
	return me_playing;
#end

#Returns the config dictionary
func get_configuration_dictionary() -> Dictionary:
	return Audio_Files_Dictionary;
#end

#Returns the file name of the given stream name
#Returns null if an error occures.
func get_config_value(stream_name : String) -> String:
	return Audio_Files_Dictionary.get(stream_name);
#end

#Allows you to change or add a stream file and name to the dictionary in runtime
func set_config_key(new_stream_name : String, new_stream_file : String) -> void:
	if (new_stream_file == "" || new_stream_name == ""):
		print_debug("Invalid arguments");
		return;
	
	Audio_Files_Dictionary[new_stream_name] = new_stream_file;
	
	if (preload_resources):
		var res = self.preload_resource(new_stream_file);
		Preloaded_Resources[new_stream_file] = res;
#end

func enable_preload_resources(enabled : bool = true) -> void:
	self.preload_resources = true;
#end

func is_preload_resources() -> bool:
	return self.preload_resources;
#end

#############################
#	INTERNAL METHODS		#
#############################

func add_background_sound(sound_name : String) -> int:
	var bgs_index;
	var new_audiostream = AudioStreamPlayer.new();
	var background_sound_script = load(soundmgr_dir_rel_path + "/Sounds.gd");
	
	$BackgroundSounds.add_child(new_audiostream);
	if (preinstantiate_nodes == false):
		new_audiostream.set_script(background_sound_script);
		new_audiostream.set_type("BGS");
		new_audiostream.connect_signals();
	new_audiostream.set_bus(bgs_bus);
	bgs_index = new_audiostream.get_index();
	bgs_playing.append(sound_name);
	BGS_Audiostreams.append(new_audiostream);
	
	return bgs_index;
#end

func erase_background_sound(sound_name : String) -> void:
	var bgs_index = bgs_playing.find(sound_name);
	
	if (bgs_index <= 0):
		return;
		
	bgs_playing.erase(sound_name);
	BGS_Audiostreams.remove(bgs_index);
	$BackgroundSounds.get_children()[bgs_index].queue_free();
#end

func find_bgs(bgs : String = "") -> int:
	var bgs_index = 0;
	if (bgs != null && bgs != ""):
		bgs_index = bgs_playing.find(bgs);
	return bgs_index;
#end

func _on_BGS_finished(sound_name):
	self.erase_background_sound(sound_name);
#end

func add_sound_effect(sound_name : String) -> int:
	var se_index;
	var new_audiostream = AudioStreamPlayer.new();
	var sound_effect_script = load(soundmgr_dir_rel_path + "/Sounds.gd");
	
	if (preinstantiate_nodes == false):
		new_audiostream.set_script(sound_effect_script);
		new_audiostream.set_type("SE");
		new_audiostream.connect_signals();
	$SoundEffects.add_child(new_audiostream);
	new_audiostream.set_bus(sfx_bus);
	se_index = new_audiostream.get_index();
	se_playing.append(sound_name);
	SE_Audiostreams.append(new_audiostream);
	
	return se_index;
#end

func erase_sound_effect(sound_name : String) -> void:
	var se_index = se_playing.find(sound_name);
	
	if (se_index <= 0):
		return;
		
	se_playing.erase(sound_name);
	SE_Audiostreams.remove(se_index);
	$SoundEffects.get_children()[se_index].queue_free();
#end

func find_se(se : String = "") -> int:
	var se_index = 0;
	if (se != null && se != ""):
		se_index = se_playing.find(se);
	return se_index;
#end

func _on_SE_finished(sound_name):
	self.erase_sound_effect(sound_name);
#end

func add_music_effect(sound_name : String) -> int:
	var me_index;
	var new_audiostream = AudioStreamPlayer.new();
	var music_effects_script = load(soundmgr_dir_rel_path + "/Sounds.gd");
	
	if (preinstantiate_nodes == false):
		new_audiostream.set_script(music_effects_script);
		new_audiostream.set_type("ME");
		new_audiostream.connect_signals();
	$MusicEffects.add_child(new_audiostream);
	new_audiostream.set_bus(mfx_bus);
	me_index = new_audiostream.get_index();
	me_playing.append(sound_name);
	ME_Audiostreams.append(new_audiostream);
	
	return me_index;
#end

func erase_music_effect(sound_name : String) -> void:
	var me_index = me_playing.find(sound_name);
	
	if (me_index <= 0):
		return;
		
	me_playing.erase(sound_name);
	ME_Audiostreams.remove(me_index);
	$MusicEffects.get_children()[me_index].queue_free();
#end

func find_me(me : String = "") -> int:
	var me_index = 0;
	if (me != null && me != ""):
		me_index = me_playing.find(me);
	return me_index;
#end

func _on_ME_finished(sound_name):
	self.erase_music_effect(sound_name);
#end

func preload_audio_files() -> void:
	if (BGM_DIR_PATH != null && BGM_DIR_PATH != ""):
		self.preload_resource_from_path(BGM_DIR_PATH);
	if (BGS_DIR_PATH != null && BGS_DIR_PATH != ""):
		self.preload_resource_from_path(BGS_DIR_PATH);
	if (SFX_DIR_PATH != null && SFX_DIR_PATH != ""):
		self.preload_resource_from_path(SFX_DIR_PATH);
	if (MFX_DIR_PATH != null && MFX_DIR_PATH != ""):
		self.preload_resource_from_path(MFX_DIR_PATH);
#end

func preload_resource_from_path(path : String) -> void:
	var dir = Directory.new();
	if dir.open(path + "/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if (file_name.get_extension() == "wav" ||
				file_name.get_extension() == "ogg" ||
				file_name.get_extension() == "opus"):
				var res = load(dir.get_current_dir() + file_name);
				Preloaded_Resources[file_name] = res;
			file_name = dir.get_next();
	else:
		print("An error occurred when trying to access the path: " + path);
#end
		
func preload_resource(res_name : String) -> Resource:
	var resPaths = [(BGM_DIR_PATH + "/"), (BGS_DIR_PATH + "/"),
					(SFX_DIR_PATH + "/"), (MFX_DIR_PATH + "/")];
	var res = null;
	var i = 0;
	while (res == null):
		res = load(resPaths[i] + res_name);
		i += 1;
		if (i >= 4):
			break;
			
	return res;
#end

func preinstantiate_nodes() -> void:
	if (BGS_DIR_PATH != null && BGS_DIR_PATH != ""):
		bgs_playing.remove(0);
		BGS_Audiostreams.remove(0);
		$BackgroundSounds.get_children()[0].free();
		preinstantiate_nodes_from_path(BGS_DIR_PATH, "BGS");
	if (SFX_DIR_PATH != null && SFX_DIR_PATH != ""):
		se_playing.remove(0);
		SE_Audiostreams.remove(0);
		$SoundEffects.get_children()[0].free();
		preinstantiate_nodes_from_path(SFX_DIR_PATH, "SFX");
	if (MFX_DIR_PATH != null && MFX_DIR_PATH != ""):
		se_playing.remove(0);
		ME_Audiostreams.remove(0);
		$MusicEffects.get_children()[0].free();
		preinstantiate_nodes_from_path(MFX_DIR_PATH, "MFX");
#end

func preinstantiate_nodes_from_path(path : String, type : String) -> void:
	var dir = Directory.new();
	if dir.open(path + "/") == OK:
		dir.list_dir_begin();
		var file_name = dir.get_next();
		var sound_index = 0;
		while (file_name != ""):
			if (file_name.get_extension() == "wav" ||
				file_name.get_extension() == "ogg" ||
				file_name.get_extension() == "opus"):
				if (type.to_lower() == "bgs"):
					sound_index = self.add_background_sound(file_name);
					var Stream = load(BGS_DIR_PATH + "/" + file_name);
					BGS_Audiostreams[sound_index].set_stream(Stream);
				elif (type.to_lower() == "sfx"):
					sound_index = self.add_sound_effect(file_name);
					var Stream = load(SFX_DIR_PATH + "/" + file_name);
					SE_Audiostreams[sound_index].set_stream(Stream);
				elif (type.to_lower() == "mfx"):
					sound_index = self.add_music_effect(file_name);
					var Stream = load(MFX_DIR_PATH + "/" + file_name);
					ME_Audiostreams[sound_index].set_stream(Stream);
			file_name = dir.get_next();
	else:
		print("An error occurred when trying to access the path: " + path);
#end
