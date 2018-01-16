{% include "header.stencil" %}
import Foundation

{% for name,schema in swagger.definitions %}
public struct {{ name }}: Codable {
{% set contents %}
{% for propertyName,propertySchema in schema.type.object.properties %}
{% set description %}{{ propertySchema.metadata.description }}{% endset %}
{% if description %}

{{ description|wrapWidth:120,"// " }}
{% endif %}
public let {{ propertyName|toCamel }}: {{ propertySchema|swiftSchemaType }}
{% endfor %}
enum CodingKeys: String, CodingKey {
{% for propertyName,propertySchema in schema.type.object.properties %}
    case {{ propertyName|toCamel }} = "{{ propertyName }}"
{% endfor %}
}
{% endset %}
{{ contents|setIndentation:"    " }}
}

public struct {{ name }}Builder {
{% set contents %}
{% for propertyName,propertySchema in schema.type.object.properties %}
public var {{ propertyName|toCamel }}: {{ propertySchema|swiftSchemaType }}
{% endfor %}

{% set parameters %}{% for propertyName,propertySchema in schema.type.object.properties %}{{ propertyName|toCamel }}: {{ propertySchema|swiftSchemaType }}, {% endfor %}{% endset %}
public init({{ parameters|trimTrailingComma }}) {
{% for propertyName,propertySchema in schema.type.object.properties %}
    self.{{ propertyName|toCamel }} = {{ propertyName|toCamel }}
{% endfor %}
}

public init(copying building: {{ name }}) {
{% for propertyName,propertySchema in schema.type.object.properties %}
    self.{{ propertyName|toCamel }} = building.{{ propertyName|toCamel }}
{% endfor %}
}

{% set buildParameters %}{% for propertyName,propertySchema in schema.type.object.properties %}{{ propertyName|toCamel }}: self.{{ propertyName|toCamel }}, {% endfor %}{% endset %}
public func build() -> {{ name }} {
    return {{ name }}({{ buildParameters|trimTrailingComma }})
}
{% endset %}
{{ contents|setIndentation:"    " }}
}

{% endfor %}
