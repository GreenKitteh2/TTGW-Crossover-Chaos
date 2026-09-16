extends GPUParticles3D


var tmpMesh = ArrayMesh.new()
var vertices: PackedVector3Array = []
var uvs: PackedVector2Array = []
var mat = StandardMaterial3D.new()
var color = Color(0.9, 0.1, 0.1)

@export var center_color: Color
@export var edge_color: Color

func _ready():
	vertices.push_back(position)
	vertices.push_back(position + Vector3(1.0, 0.0, 0.0))
	vertices.push_back(position)
	vertices.push_back(position + Vector3(-1.0, 0.0, 0.0))
	vertices.push_back(position)
	vertices.push_back(position+Vector3(0.0, 1.0, 0.0))
	vertices.push_back(position)
	vertices.push_back(position+Vector3(0.0, -1.0, 0.0))
	vertices.push_back(position)
	vertices.push_back(position+Vector3(0.0, 0.0, 1.0))
	vertices.push_back(position)
	vertices.push_back(position+Vector3(0.0, 0.0, -1.0))
	
	uvs.push_back(Vector2(0, 0))
	uvs.push_back(Vector2(0, 1))
	uvs.push_back(Vector2(1, 1))
	uvs.push_back(Vector2(1, 0))
	uvs.push_back(Vector2(0, 0))
	uvs.push_back(Vector2(0, 1))
	uvs.push_back(Vector2(1, 1))
	uvs.push_back(Vector2(1, 0))
	uvs.push_back(Vector2(0, 0))
	uvs.push_back(Vector2(0, 1))
	uvs.push_back(Vector2(1, 1))
	uvs.push_back(Vector2(1, 0))
	
	mat.albedo_color = Color.WHITE
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINES)
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.vertex_color_use_as_albedo = true
	st.set_material(mat)
	
	for v in vertices.size(): 
		if v % 2 == 0:
			st.set_color(center_color)
		else:
			st.set_color(edge_color)
		st.set_uv(uvs[v])
		st.add_vertex(vertices[v])
	
	st.commit(tmpMesh)
	
	ResourceSaver.save(tmpMesh, 'res://pixiedust.tres')
