{% include "header.stencil" %}
import PromiseKit
import SwiftToolbox

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
        return firstly { () -> Promise<(HTTPURLResponse, Data)> in
{% if operation|hasParameter:"body" %}
{% for parameter in operation.parameters where parameter|isParameter:"body" %}
            let body = try JSONEncoder.rfc3339Encoder.encode({{ parameter|parameterName|toCamel }})
{% endfor %}
{% else %}
            let body: Data? = nil
{% endif %}
            return self.client.makeRequest(method: "{{ operationType|uppercase }}", path: "{{ path }}",
                pathParameters: pathParameters, queryParameters: queryParameters,
                body: body, headers: headers)
        }.map { arguments -> {% call firstResponseType operation %} in
            let (response, data) = arguments
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
