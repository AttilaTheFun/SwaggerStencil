{% include "header.stencil" %}
package client

{% import "handler_parameters.stencil" %}
{% import "handler_responses.stencil" %}
{% import "encode_item_to_string.stencil" %}
{% import "encode_parameter.stencil" %}
{% import "encode_path_parameters.stencil" %}
{% import "encode_error.stencil" %}
{% import "decode_response.stencil" %}
{% set existsPathParameter %}{{ swagger|hasParameter:"path" }}{% endset %}
{% set existsBodyParameter %}{{ swagger|hasParameter:"body" }}{% endset %}
import (
    "bytes"
    "encoding/json"
    "net/http"
    "net/url"
{% if existsPathParameter %}
    "strings"
{% endif %}
    "time"

    "{{ path }}/models"
)

// Client - Implements the the interface for this webservice by proxying to a remote instance of the service.
type Client struct{}

{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{{ path|handlerName:operationType }}{% endset %}
// {{ handlerName }} - {{ operation.summary }}
func (Client) {{ handlerName }}({% call handlerParameters operation %}) {% call handlerResponses operation %} {
{% set hasQueryParameter %}{{ operation|hasParameter:"query" }}{% endset %}
{% set hasPathParameter %}{{ operation|hasParameter:"path" }}{% endset %}
{% set hasHeaderParameter %}{{ operation|hasParameter:"header" }}{% endset %}
{% set hasBodyParameter %}{{ operation|hasParameter:"body" }}{% endset %}
    var err error
    path := "{{ path }}"
{% call setupResponses operation %}
{% call setupDefaultResponse operation %}
{% if hasHeaderParameter %}
    headerParameters := http.Header{}
{% endif %}
{% if hasQueryParameter %}
    queryParameters := url.Values{}
{% endif %}

{% for either in operation.parameters %}
{% call encodeParameter operation either %}

{% endfor %}
{% if hasPathParameter %}
    replacer := strings.NewReplacer({% call encodePathParameters operation %})
    path = replacer.Replace(path)

{% endif %}
    // Build the URL:
    u, err := url.Parse("http://hermes:8080" + path)
{% if hasQueryParameter %}
    u.RawQuery = queryParameters.Encode()
{% endif %}
{% call encodeError operation %}

    // Build the request:
{% if hasBodyParameter %}
    buffer := bytes.NewBuffer(bodyBytes)
{% endif %}
    request, err := http.NewRequest("{{ operationType|uppercase }}", u.String(), {% if hasBodyParameter %}buffer{% else %}nil{% endif %})
{% call encodeError operation %}

{% if hasHeaderParameter %}
    // Add the headers:
    request.Header = headerParameters

{% endif %}
    // Make the request:
    client := &http.Client{Timeout: time.Second * 10}
    response, err := client.Do(request)
{% call encodeError operation %}

    defer response.Body.Close()

{% call decodeResponse operation %}

    {% call returnString "response.StatusCode" operation %}
}

{% endfor %}
{% endfor %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}