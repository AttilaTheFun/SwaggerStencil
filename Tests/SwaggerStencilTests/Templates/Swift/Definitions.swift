{% for structure in swagger.definitions %}
public struct {{ structure.name }}: Codable {
    {% for property in structure.structure.object.properties %}
    let {{ property|snakeToCamelCase|lowerFirstWord }}: Type
    {% endfor %}
}
{% endfor %}
