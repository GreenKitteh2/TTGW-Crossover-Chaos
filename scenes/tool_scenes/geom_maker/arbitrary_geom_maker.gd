extends Node3D



@export var vertices : PackedVector3Array
var uvs : PackedVector2Array = []
var color = Color(0.9, 0.1, 0.1)
@export var mesh_type : Mesh.PrimitiveType


func generate() -> void:
	var tmpMesh = ArrayMesh.new()
	
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.WHITE
	
	var st = SurfaceTool.new()
	st.begin(mesh_type)
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	st.set_material(mat)
	
	for v in vertices.size(): 
		st.set_color(Color.WHITE)
		st.add_vertex(vertices[v])
		
	st.commit(tmpMesh)
	
	
	$MeshInstance3D.mesh = tmpMesh

func _process(_delta) -> void:
		generate()
	
