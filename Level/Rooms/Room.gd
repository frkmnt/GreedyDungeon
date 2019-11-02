extends Node2D

export (Vector2) var _PORTAL_POSITION
export (Array, Vector2) var _ENEMY_POSITIONS 
export (Array, Vector2) var _CHEST_POSITIONS 

var _tilemap
var _money_container



func initialize():
	_tilemap = $MainTileMap
	_money_container = $MoneyContainer

