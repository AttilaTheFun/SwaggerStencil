package service


import (
	"/Users/Logan/swift/SwaggerStencil/Tests/SwaggerStencilTests/Templates/Go/Generated/models/models.go"
)

// Service - Defines the interface for this webservice.
type Service interface {

    // GetEstimatesTime - Time Estimates
    GetEstimatesTime(startLatitude float64, startLongitude float64, customerUUID string, productID string)

    // GetProducts - Product Types
    GetProducts(latitude float64, longitude float64)

    // GetEstimatesPrice - Price Estimates
    GetEstimatesPrice(startLatitude float64, startLongitude float64, endLatitude float64, endLongitude float64)

    // GetHistory - User Activity
    GetHistory(offset int64, limit int64)

    // GetMe - User Profile
    GetMe()
}
