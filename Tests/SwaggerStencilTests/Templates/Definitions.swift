{% for structure in swagger.definitions %}
public struct {{ structure.name }} {
    {% for property in structure.structure.object.properties %}
    {{ property }}
    {% endfor %}
}
{% endfor %}
