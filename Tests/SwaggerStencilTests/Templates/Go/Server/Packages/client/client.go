{% include "header.stencil" %}
package client

{% import "handler_parameters.stencil" %}
{% import "handler_responses.stencil" %}
{% import "item_encoding.stencil" %}
{% import "encode_parameters.stencil" %}
{% import "encode_error.stencil" %}
{% import "decode_response.stencil" %}
{% set existsBodyParameter %}{{ swagger|hasParameter:"body" }}{% endset %}
import (
{% if existsBodyParameter %}
    "bytes"
{% endif %}
    "encoding/json"
    "net/http"
    "net/url"
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
{% call setupResponses operation %}
{% call setupDefaultResponse operation %}
{% if hasPathParameter %}
    pathParameters := mux.Vars(r)
{% endif %}
{% if hasHeaderParameter %}
    headerParameters := r.Header
{% endif %}

    // Build the URL:
    u, err := url.Parse("http://envoy:8080{{ path }}")
{% call encodeError operation %}

{% if hasQueryParameter %}
    q := u.Query()
{% endif %}

{% call encodeParameters operation %}

{% if hasQueryParameter %}
    u.RawQuery = q.Encode()
{% endif %}

    // Build the request:
    var buffer *bytes.Buffer
{% if hasBodyParameter %}
    buffer = bytes.NewBuffer(bodyBytes)
{% endif %}
    request, err := http.NewRequest("{{ operationType|uppercase }}", u.String(), buffer)
{% call encodeError operation %}

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