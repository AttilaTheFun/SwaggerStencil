{% include "header.stencil" %}
import Foundation
import SwiftToolbox

public struct API {
    public static var client = Client(baseURL: URL(string: "{{ swagger.host.absoluteString }}")!)
}
