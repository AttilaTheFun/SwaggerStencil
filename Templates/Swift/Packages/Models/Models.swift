{% include "header.stencil" %}
import Foundation

{% for name,schema in swagger.definitions %}
public struct {{ name|toPascal }}: Codable {
{% set contents %}
{% for propertyName,propertySchema in schema.type.object.properties %}
{% set description %}{{ propertySchema.metadata.description }}{% endset %}
{% if description %}

{{ description|wrapWidth:120,"// " }}
{% endif %}
public let {{ propertyName|toCamel }}: {{ propertySchema|schemaType:"swift" }}
{% endfor %}
enum CodingKeys: String, CodingKey {
{% for propertyName,propertySchema in schema.type.object.properties %}
    case {{ propertyName|toCamel }} = "{{ propertyName }}"
{% endfor %}
}
{% endset %}
{{ contents|setIndentation:"    " }}
}

public struct {{ name|toPascal }}Builder {
{% set contents %}
{% for propertyName,propertySchema in schema.type.object.properties %}
public var {{ propertyName|toCamel }}: {{ propertySchema|schemaType:"swift" }}
{% endfor %}

{% set parameters %}{% for propertyName,propertySchema in schema.type.object.properties %}{{ propertyName|toCamel }}: {{ propertySchema|schemaType:"swift" }}, {% endfor %}{% endset %}
public init({{ parameters|trimTrailingComma }}) {
{% for propertyName,propertySchema in schema.type.object.properties %}
    self.{{ propertyName|toCamel }} = {{ propertyName|toCamel }}
{% endfor %}
}

public init(copying building: {{ name|toPascal }}) {
{% for propertyName,propertySchema in schema.type.object.properties %}
    self.{{ propertyName|toCamel }} = building.{{ propertyName|toCamel }}
{% endfor %}
}

{% set buildParameters %}{% for propertyName,propertySchema in schema.type.object.properties %}{{ propertyName|toCamel }}: self.{{ propertyName|toCamel }}, {% endfor %}{% endset %}
public func build() -> {{ name|toPascal }} {
    return {{ name|toPascal }}({{ buildParameters|trimTrailingComma }})
}
{% endset %}
{{ contents|setIndentation:"    " }}
}

{% endfor %}
