import Foundation
import PromiseKit
import Models

{% import "handler_parameters.stencil" %}
{% import "handler_response.stencil" %}
{% import "decode_response.stencil" %}
{% import "encode_item_to_string.stencil" %}
extension API {
{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{{ path|handlerName:operationType }}{% endset %}

    /// {{ operation.summary }}
    public static func {{ handlerName|toCamel }}({% call handlerParameters operation %}) -> {% call handlerResponse operation %} {
{% if operation|hasParameter:"path" %}
        var pathParameters = [String: String]()
{% for parameter in operation.parameters where parameter|isParameter:"path" %}
        pathParameters["{{ parameter|parameterName }}"] = {% call encodeParameterToString parameter %}
{% endfor %}
{% else %}
        let pathParameters = [String: String]()
{% endif %}

{% if operation|hasParameter:"query" %}
        var queryParameters = [String: String]()
{% for parameter in operation.parameters where parameter|isParameter:"query" %}
        queryParameters["{{ parameter|parameterName }}"] = {% call encodeParameterToString parameter %}
{% endfor %}
{% else %}
        let queryParameters = [String: String]()
{% endif %}

{% if operation|hasParameter:"body" %}
{% for parameter in operation.parameters where parameter|isParameter:"body" %}
        let body = try? JSONEncoder().encode({{ parameter|parameterName|toCamel }})
{% endfor %}
{% else %}
        let body: Data? = nil
{% endif %}

{% if operation|hasNonAuthHeaderParameter %}
        var headers = [String: String]()
{% for parameter in operation.parameters where parameter|isParameter:"header" %}
{% if parameter|parameterName != "Authenticated-User-ID" %}
        headers["{{ parameter|parameterName }}"] = {% call encodeParameterToString parameter %}
{% endif %}
{% endfor %}
{% else %}
        let headers = [String: String]()
{% endif %}

        return firstly {
            self.client.makeRequest(method: "{{ operationType|uppercase }}", path: "{{ path }}",
                                    pathParameters: pathParameters, queryParameters: queryParameters,
                                    body: body, headers: headers)
        }.then { (response, data) -> {% call firstResponseType operation %} in
            switch response.statusCode {
{% for code,either in operation.responses %}
            case {{ code }}:
{% call decodeResponse either %}
{% endfor %}
            default:
{% if operation.defaultResponse.some %}
{% call decodeError operation.defaultResponse %}
{% endif %}
            }
        }
    }
{% endfor %}
{% endfor %}
}

{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}