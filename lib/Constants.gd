extends Node

enum SceneId { StartMenu, World, PlanetSurface }

enum HullType { Harrier, Falcon }

enum EngineType { IonDrive }

var JumpTime: float = 1.5

enum Sound { JumpBegin, JumpComplete, Message }

#export var SceneId: _SceneId
